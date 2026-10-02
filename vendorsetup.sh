# SPDX-License-Identifier: Apache-2.0

add_lunch_combo fox_beryl-userdebug
add_lunch_combo fox_beryl-eng

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

# Beryl uses AIDL boot control for A/B slot handling.
export OF_USE_AIDL_BOOT_CONTROL=1

# Keep the vendor_boot recovery within the stock 64 MiB partition.
export FOX_DRASTIC_SIZE_REDUCTION=1

# Newer boot-image tooling is useful for Android 16 images.
export FOX_USE_UPDATED_MAGISKBOOT=1
