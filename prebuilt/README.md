# Stock recovery prebuilts

This directory contains exact stock Android 16 Beryl inputs and evidence used by the OrangeFox build.

## Layout

- `vendor_boot.img` — stock vendor_boot v4 reference image.
- `kernel` — stock prebuilt kernel.
- `dtb.img` / `dtbs/` — stock DTB inputs.
- `dtbo.img` — stock DTBO image.
- `modules/` — selected kernel modules required by recovery.
- `wlan/` — stock WLAN firmware, userspace, init files, libraries and WLAN modules.
- `decryption/` — stock crypto/FBE evidence and payloads:
  - `vendor/` — vendor-side KeyMint/Keymaster/Gatekeeper/FBE payloads.
  - `system/` — system-side crypto/FBE payloads.
  - `services/init/` — discovered stock service rc files.
  - `services/bins/` — exact binaries referenced by discovered service declarations.
  - `services/deps/` — recursively resolved ELF dependencies.
  - `config/fstab/` — recovery-relevant stock fstab/configuration evidence.
  - `config/selinux/` — relevant stock SELinux evidence.
  - `services/key-service-scan.txt` — service discovery report.
  - `services/key-service-deps.txt` — ELF dependency report.
- `recovery-modules.list` — authoritative selected recovery module list.
- `stock-artifacts.txt` — source stock-image metadata.

The sync workflow regenerates the extracted payload directories from the exact stock release. Device-specific files should not be copied from another device tree.
