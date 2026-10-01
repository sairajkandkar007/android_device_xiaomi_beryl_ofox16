# Xiaomi Beryl — OrangeFox Android 16 device tree

Clean recovery tree for Redmi Note 14 5G / POCO M7 Pro 5G (`beryl`).

## Current target
- Android 16 / API 36 build environment
- MediaTek MT6855
- arm64
- Android boot image header v4
- A/B device
- dynamic logical partitions
- vendor_boot-based recovery architecture
- FBE/metadata-aware recovery layout

## Design rule
This tree intentionally does not inherit vendor/twrp/config/common.mk or the legacy Omni recovery stack.

The stock-image analysis release is kept in the repository release history: beryl-ofox16-analysis.

The current tree uses recovery-critical values established from the available stock/device-tree evidence. Super-partition sizing and vendor_boot ramdisk integration remain subject to final stock-image verification.

## Files
- BoardConfig.mk — hardware, boot image, partition and OrangeFox build configuration
- device.mk — minimal product configuration
- fox_beryl.mk — OrangeFox product
- AndroidProducts.mk — lunch/product registration
- vendorsetup.sh — OrangeFox Android 16 build variables
- recovery.fstab — logical, metadata, userdata and boot-critical partitions

## Next build work
1. Add exact stock vendor_boot/recovery ramdisk integration.
2. Add kernel/dtb prebuilts only after their formats and offsets are confirmed.
3. Reconcile the final super-partition size with the Android 16 stock image.
4. Build a first recovery image and compare its vendor_boot/recovery layout with stock.