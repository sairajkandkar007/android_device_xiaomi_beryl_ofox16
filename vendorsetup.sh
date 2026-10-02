# SPDX-License-Identifier: Apache-2.0

# Modern Android lunch target.
add_lunch_combo fox_beryl-ap2a-eng

# Stock Android 16 Beryl recovery is carried by vendor_boot's vendor ramdisk.
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VENDOR_BOOT_RECOVERY=1
export FOX_REFERENCE_VENDOR_BOOT_IMAGE=$(gettop)/device/xiaomi/beryl/prebuilt/vendor_boot.img
export OF_FORCE_PREBUILT_KERNEL=1

# Universal/non-ROM-specific OrangeFox build.
export FOX_VANILLA_BUILD=1

# Android 16 / API 36 support.
export FOX_ADD_API_V36_PREBUILTS=2
export OF_DONT_SUBSTITUTE_PERMISSIONS=1

# Stock userdata is F2FS with Android FBE/casefolding support.
export OF_FORCE_DATA_FORMAT_F2FS=1
export OF_FORCE_CASEFOLDING=1
export OF_UNBIND_SDCARD_F2FS=1
export OF_WIPE_METADATA_AFTER_DATAFORMAT=1
export OF_LOOP_DEVICE_ERRORS_TO_LOG=1

# Stock vendor ramdisk is LZ4-compressed.
export OF_USE_LZ4_COMPRESSION=1

# Beryl uses AIDL boot control for A/B slot handling.
export OF_USE_AIDL_BOOT_CONTROL=1

# Keep the vendor_boot recovery within the stock 64 MiB partition.
export FOX_DRASTIC_SIZE_REDUCTION=1

# Newer boot-image tooling is useful for Android 16 images.
export FOX_USE_UPDATED_MAGISKBOOT=1

# Use extreme reduction only because stock vendor_boot is 64 MiB.
# Keep this last so OrangeFox applies it after the other build variables.
export FOX_EXTREME_SIZE_REDUCTION=1
