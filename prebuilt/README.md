# Stock recovery prebuilts

This directory contains files intentionally used by or collected for the Beryl OrangeFox 16 recovery build.

## Layout

- `vendor_boot.img` — stock Android 16 vendor_boot v4 reference.
- `kernel`, `dtb.img`, `dtbo.img`, `dtbs/` — stock boot inputs.
- `modules/` — selected recovery kernel modules.
- `wlan/` — stock Beryl WLAN firmware, userspace, init files and modules.
- `decryption/` — stock FBE/KeyMint/Gatekeeper recovery material.
- `recovery-modules.list` — authoritative list of modules copied into the recovery payload.
- `stock-artifacts.txt` — stock-image provenance/reference information.

## Decryption layout

- `decryption/vendor/` — vendor-side crypto payload.
- `decryption/system/` — system-side crypto payload.
- `decryption/config/` — recovery-relevant configuration and init files.
- `decryption/services/` — exact security service executables discovered from stock init files.
- `decryption/dependencies/` — ELF dependencies of those discovered security services.
- `decryption/evidence/` — scan reports; these are evidence, not automatically installed recovery files.
- `decryption/manifest.txt` — generated inventory.

The sync workflow must keep evidence separate from payload and must not collect unrelated vendor services merely because they appear in stock init files.
