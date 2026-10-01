# SPDX-License-Identifier: Apache-2.0

add_lunch_combo fox_beryl-userdebug
add_lunch_combo fox_beryl-eng

# Stock Android 16 Beryl recovery is carried by vendor_boot's vendor ramdisk.
export FOX_AB_DEVICE=1
export FOX_VENDOR_BOOT_RECOVERY=1

# Android 16 / API 36 support.
export FOX_ADD_API_V36_PREBUILTS=2
export OF_DONT_SUBSTITUTE_PERMISSIONS=1
