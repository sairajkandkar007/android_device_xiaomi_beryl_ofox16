# SPDX-License-Identifier: Apache-2.0

FDEVICE="beryl"

# OrangeFox requires FOX_BUILD_DEVICE to be set before its build variables
# are processed. Keep this device-selection logic inside the device tree.
fox_get_target_device() {
    if echo "$BASH_SOURCE" | grep -q "/$FDEVICE/"; then
        FOX_BUILD_DEVICE="$FDEVICE"
    elif set | grep BASH_ARGV | grep -q "\\b$FDEVICE\\b"; then
        FOX_BUILD_DEVICE="$FDEVICE"
    elif echo "${BASH_SOURCE[0]}" | grep -q "/$FDEVICE/"; then
        FOX_BUILD_DEVICE="$FDEVICE"
    elif echo "$0" | grep -q "$FDEVICE"; then
        FOX_BUILD_DEVICE="$FDEVICE"
    fi
}

if [ -z "${1:-}" ] && [ -z "${FOX_BUILD_DEVICE:-}" ]; then
    fox_get_target_device
fi

if [ "${1:-}" = "$FDEVICE" ] || [ "${FOX_BUILD_DEVICE:-}" = "$FDEVICE" ]; then
    export FOX_BUILD_DEVICE="$FDEVICE"

    # Modern Android lunch target.
    add_lunch_combo fox_beryl-ap2a-eng

    # Stock Android 16 Beryl recovery is carried by vendor_boot's vendor ramdisk.
    export FOX_AB_DEVICE=1
    export FOX_VIRTUAL_AB_DEVICE=1
    export FOX_VENDOR_BOOT_RECOVERY=1
    export FOX_VARIANT="vBaR"
    export FOX_REFERENCE_VENDOR_BOOT_IMAGE="$(gettop)/device/xiaomi/beryl/prebuilt/vendor_boot.img"
    export OF_FORCE_PREBUILT_KERNEL=1

    # Universal/non-ROM-specific OrangeFox build.
    export FOX_VANILLA_BUILD=1

    # Android 16 / API 36 support.
    export FOX_ADD_API_V36_PREBUILTS=2
    export OF_DEFAULT_KEYMASTER_VERSION=4.0
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

    # Keep extreme reduction last so OrangeFox applies it after other build vars.
    export FOX_EXTREME_SIZE_REDUCTION=1
else
    if [ -z "${FOX_BUILD_DEVICE:-}" ] && [ -z "${BASH_SOURCE:-}" ]; then
        echo "I: This script requires bash. Not processing the $FDEVICE"
    fi
fi
