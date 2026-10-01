#!/usr/bin/env python3
import math
import pathlib
import struct
import sys

if len(sys.argv) != 4:
    raise SystemExit("usage: analyze_vendor_boot.py VENDOR_BOOT OUT_DIR REPORT")

src = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
report = pathlib.Path(sys.argv[3])
out.mkdir(parents=True, exist_ok=True)
b = src.read_bytes()

if b[:8] != b"VNDRBOOT":
    raise SystemExit(f"Unexpected vendor_boot magic: {b[:8]!r}")

version, page_size, kernel_addr, ramdisk_size = struct.unpack_from("<4I", b, 8)
ramdisk_addr = struct.unpack_from("<I", b, 24)[0]
cmdline = b[28:2076].split(b"\0", 1)[0].decode("utf-8", "replace")
name = b[2080:2096].split(b"\0", 1)[0].decode("utf-8", "replace")
header_size = struct.unpack_from("<I", b, 2096)[0]
dtb_size = struct.unpack_from("<I", b, 2100)[0]
dtb_addr = struct.unpack_from("<Q", b, 2104)[0]

info = [
    f"header_version={version}",
    f"page_size={page_size}",
    f"kernel_addr=0x{kernel_addr:x}",
    f"ramdisk_addr=0x{ramdisk_addr:x}",
    f"vendor_ramdisk_size={ramdisk_size}",
    f"header_size={header_size}",
    f"dtb_size={dtb_size}",
    f"dtb_addr=0x{dtb_addr:x}",
    f"name={name}",
    f"cmdline={cmdline}",
]

ramdisk_base = math.ceil(header_size / page_size) * page_size
info.append(f"ramdisk_base=0x{ramdisk_base:x}")

ramdisk_end = ramdisk_base + ramdisk_size
if ramdisk_end > len(b):
    info.append(
        f"warning=declared vendor ramdisk ends at 0x{ramdisk_end:x}, "
        f"but image ends at 0x{len(b):x}; clamping to image size"
    )
    ramdisk_end = len(b)

ramdisk = b[ramdisk_base:ramdisk_end]
(out / "vendor_ramdisk.bin").write_bytes(ramdisk)

if version >= 4:
    table_size, table_count, table_entry_size, bootconfig_size = struct.unpack_from("<4I", b, 2112)
    info.extend([
        f"vendor_ramdisk_table_size={table_size}",
        f"vendor_ramdisk_table_entry_num={table_count}",
        f"vendor_ramdisk_table_entry_size={table_entry_size}",
        f"bootconfig_size={bootconfig_size}",
    ])
    table_base = math.ceil((ramdisk_base + ramdisk_size + dtb_size) / page_size) * page_size
    info.append(f"ramdisk_table_base=0x{table_base:x}")

    if table_entry_size == 108 and table_count * table_entry_size <= table_size:
        for i in range(table_count):
            off = table_base + i * table_entry_size
            if off + table_entry_size > len(b):
                break
            fragment_size, fragment_offset, fragment_type = struct.unpack_from("<3I", b, off)
            fragment_name = b[off + 12:off + 44].split(b"\0", 1)[0].decode("utf-8", "replace")
            info.append(
                f"ramdisk_fragment[{i}]: size={fragment_size} "
                f"offset=0x{fragment_offset:x} type={fragment_type} name={fragment_name}"
            )
            if fragment_offset + fragment_size <= len(ramdisk):
                fragment = ramdisk[fragment_offset:fragment_offset + fragment_size]
                safe_name = fragment_name or str(fragment_type)
                (out / f"ramdisk_fragment_{i}_{safe_name}.bin").write_bytes(fragment)

report.write_text("\n".join(info) + "\n")
