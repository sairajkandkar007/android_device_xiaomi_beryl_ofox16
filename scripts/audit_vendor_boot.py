#!/usr/bin/env python3
"""Strict Beryl vendor_boot v4 audit.

Usage:
  audit_vendor_boot.py FINAL_VENDOR_BOOT STOCK_VENDOR_BOOT REPORT [KERNEL] [DTB]

The audit compares the final image against the stock Beryl reference and
fails on any mismatch in the boot header, stock PLATFORM ramdisk fragment,
DTB, or v4 layout. Kernel verification is optional because vendor_boot v4
does not carry a kernel payload; when supplied, its SHA-256 is checked.
"""
from __future__ import annotations

import hashlib
import pathlib
import struct
import sys

PAGE = 4096
EXPECTED = {
    "version": 4,
    "page_size": 4096,
    "header_size": 2128,
    "stock_vendor_ramdisk_size": 45108641,
    "stock_platform_sha256": "fa07754b750252477146da508b94fdaefc87a9984c8a5c316df6614b5a309295",
    "dtb_size": 266395,
    "dtb_sha256": "e59a0d4299f3fda23e4a50caf067dea7f8e6e579",
    "kernel_sha256": "5e6f6089d1958d2ff8351602df43755f501b5249",
    "stock_bootconfig_size": 94,
}

def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def page_up(n: int, page: int = PAGE) -> int:
    return ((n + page - 1) // page) * page

def parse(path: pathlib.Path):
    b = path.read_bytes()
    if b[:8] != b"VNDRBOOT":
        raise ValueError(f"{path}: invalid vendor_boot magic: {b[:8]!r}")
    if len(b) < 2128:
        raise ValueError(f"{path}: image too small for v4 header")
    version, page_size, kernel_addr, ramdisk_size = struct.unpack_from("<4I", b, 8)
    ramdisk_addr = struct.unpack_from("<I", b, 24)[0]
    cmdline = b[28:2076].split(b"\0", 1)[0].decode("utf-8", "replace")
    name = b[2080:2096].split(b"\0", 1)[0].decode("utf-8", "replace")
    header_size = struct.unpack_from("<I", b, 2096)[0]
    dtb_size = struct.unpack_from("<I", b, 2100)[0]
    dtb_addr = struct.unpack_from("<Q", b, 2104)[0]
    table_size, table_count, entry_size, bootconfig_size = struct.unpack_from("<4I", b, 2112)

    header_end = page_up(header_size, page_size)
    ramdisk_off = header_end
    ramdisk_end = ramdisk_off + ramdisk_size
    dtb_off = page_up(ramdisk_end, page_size)
    dtb_end = dtb_off + dtb_size
    table_off = page_up(dtb_end, page_size)
    table_end = table_off + table_size
    bootconfig_off = page_up(table_end, page_size)
    bootconfig_end = bootconfig_off + bootconfig_size

    if bootconfig_end > len(b):
        raise ValueError(f"{path}: declared v4 layout exceeds image size")
    if table_count * entry_size > table_size:
        raise ValueError(f"{path}: ramdisk table entries exceed table size")

    fragments = []
    for i in range(table_count):
        off = table_off + i * entry_size
        size, rel_off, typ = struct.unpack_from("<3I", b, off)
        frag_name = b[off + 12:off + 44].split(b"\0", 1)[0].decode("utf-8", "replace")
        if rel_off + size > ramdisk_size:
            raise ValueError(f"{path}: fragment {i} exceeds vendor ramdisk")
        payload = b[ramdisk_off + rel_off:ramdisk_off + rel_off + size]
        fragments.append({
            "index": i, "size": size, "offset": rel_off, "type": typ,
            "name": frag_name, "sha256": sha256(payload), "payload": payload,
        })

    return {
        "bytes": b,
        "size": len(b),
        "version": version,
        "page_size": page_size,
        "kernel_addr": kernel_addr,
        "ramdisk_addr": ramdisk_addr,
        "ramdisk_size": ramdisk_size,
        "header_size": header_size,
        "dtb_size": dtb_size,
        "dtb_addr": dtb_addr,
        "cmdline": cmdline,
        "name": name,
        "table_size": table_size,
        "table_count": table_count,
        "entry_size": entry_size,
        "bootconfig_size": bootconfig_size,
        "ramdisk": b[ramdisk_off:ramdisk_end],
        "dtb": b[dtb_off:dtb_end],
        "table": b[table_off:table_end],
        "bootconfig": b[bootconfig_off:bootconfig_end],
        "fragments": fragments,
        "offsets": {
            "ramdisk": ramdisk_off, "dtb": dtb_off,
            "table": table_off, "bootconfig": bootconfig_off,
        },
    }

def check(report, label, actual, expected):
    ok = actual == expected
    report.append(f"{'PASS' if ok else 'FAIL'} {label}: actual={actual} expected={expected}")
    return ok

def main():
    if len(sys.argv) not in (4, 5, 6):
        raise SystemExit("usage: audit_vendor_boot.py FINAL STOCK REPORT [KERNEL] [DTB]")

    final_path, stock_path, report_path = map(pathlib.Path, sys.argv[1:4])
    kernel_path = pathlib.Path(sys.argv[4]) if len(sys.argv) >= 5 else None
    dtb_path = pathlib.Path(sys.argv[5]) if len(sys.argv) >= 6 else None

    final = parse(final_path)
    stock = parse(stock_path)
    report = [
        "Beryl OrangeFox vendor_boot v4 strict audit",
        f"final={final_path}",
        f"stock={stock_path}",
        "",
    ]
    failures = 0

    for label, actual, expected in (
        ("header_version", final["version"], EXPECTED["version"]),
        ("page_size", final["page_size"], EXPECTED["page_size"]),
        ("header_size", final["header_size"], EXPECTED["header_size"]),
        ("stock_vendor_ramdisk_size", stock["ramdisk_size"], EXPECTED["stock_vendor_ramdisk_size"]),
        ("stock_dtb_size", stock["dtb_size"], EXPECTED["dtb_size"]),
        ("stock_bootconfig_size", stock["bootconfig_size"], EXPECTED["stock_bootconfig_size"]),
    ):
        if not check(report, label, actual, expected):
            failures += 1

    if final["version"] != 4 or final["page_size"] != PAGE:
        failures += 1
    if final["entry_size"] != 108:
        report.append(f"FAIL final ramdisk_table_entry_size: actual={final['entry_size']} expected=108")
        failures += 1
    else:
        report.append("PASS final ramdisk_table_entry_size: actual=108 expected=108")

    stock_platform = next((x for x in stock["fragments"] if x["name"] == "PLATFORM"), None)
    final_platform = next((x for x in final["fragments"] if x["name"] == "PLATFORM"), None)
    if stock_platform is None:
        report.append("FAIL stock PLATFORM fragment: not found")
        failures += 1
    else:
        if not check(report, "stock PLATFORM sha256", stock_platform["sha256"], EXPECTED["stock_platform_sha256"]):
            failures += 1
    if final_platform is None:
        report.append("FAIL final PLATFORM fragment: not found")
        failures += 1
    elif stock_platform is not None:
        if not check(report, "final PLATFORM sha256", final_platform["sha256"], stock_platform["sha256"]):
            failures += 1
        if not check(report, "final PLATFORM size", final_platform["size"], stock_platform["size"]):
            failures += 1

    final_recovery = next((x for x in final["fragments"] if x["name"] == "RECOVERY"), None)
    if final_recovery is None:
        report.append("FAIL final RECOVERY fragment: not found")
        failures += 1
    else:
        report.append(f"PASS final RECOVERY fragment present: size={final_recovery['size']} sha256={final_recovery['sha256']}")

    for name, obj in (("final", final), ("stock", stock)):
        report.append(
            f"{name} layout: ramdisk=0x{obj['offsets']['ramdisk']:x}, "
            f"dtb=0x{obj['offsets']['dtb']:x}, table=0x{obj['offsets']['table']:x}, "
            f"bootconfig=0x{obj['offsets']['bootconfig']:x}"
        )
        report.append(
            f"{name} table: size={obj['table_size']} count={obj['table_count']} "
            f"entry_size={obj['entry_size']}"
        )
        report.append(
            f"{name} bootconfig_sha256={sha256(obj['bootconfig'])} "
            f"cmdline={obj['cmdline']!r}"
        )
        for f in obj["fragments"]:
            report.append(
                f"{name} fragment[{f['index']}]: name={f['name']} size={f['size']} "
                f"offset=0x{f['offset']:x} type={f['type']} sha256={f['sha256']}"
            )

    if dtb_path:
        got = dtb_path.read_bytes()
        if not check(report, "external DTB size", len(got), EXPECTED["dtb_size"]):
            failures += 1
        if not check(report, "external DTB sha256", sha256(got), EXPECTED["dtb_sha256"]):
            failures += 1
    else:
        report.append("INFO external DTB check skipped: no DTB argument supplied")

    if kernel_path:
        got = sha256(kernel_path.read_bytes())
        if not check(report, "external kernel sha256", got, EXPECTED["kernel_sha256"]):
            failures += 1
    else:
        report.append("INFO external kernel check skipped: no kernel argument supplied")

    report.append("")
    report.append(f"RESULT={'FAIL' if failures else 'PASS'}")
    report_path.write_text("\n".join(report) + "\n")
    print("\n".join(report))
    raise SystemExit(1 if failures else 0)

if __name__ == "__main__":
    main()
