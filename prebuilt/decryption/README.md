# Beryl recovery decryption payload

This directory is split into recovery payload and inspection evidence.

- `vendor/` — stock vendor-side KeyMint/Gatekeeper libraries and service payload.
- `system/` — stock system-side vold, keystore2 and related crypto libraries.
- `config/` — recovery-relevant fstab, init, VINTF and SELinux configuration.
- `services/` — exact security service executables referenced by relevant stock init files.
- `dependencies/` — ELF dependencies discovered from those exact security services.
- `evidence/` — scan reports used to decide what should be integrated; not automatically installed.
- `manifest.txt` — generated inventory.

The sync workflow intentionally scopes service extraction to KeyMint, Keymaster, Gatekeeper, TEE-supplicant, Keystore2 and vold init files. Unrelated vendor services must not enter this directory.
