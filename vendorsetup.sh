FDEVICE="beryl"
fox_get_target_device() {
    local chkdev=""
    if [ -n "$ZSH_VERSION" ]; then
        local current_source="${(%):-%x}"
        chkdev=$(echo "$current_source" | grep -w "$FDEVICE")
    elif [ -n "$BASH_VERSION" ]; then
        chkdev=$(echo "$BASH_SOURCE" | grep -w "$FDEVICE")
    fi
    if [ -n "$chkdev" ]; then FOX_BUILD_DEVICE="$FDEVICE"; else
        if [ -n "$BASH_VERSION" ]; then chkdev=$(set | grep BASH_ARGV | grep -w "$FDEVICE")
        elif [ -n "$ZSH_VERSION" ]; then chkdev=$(echo "$*" | grep -w "$FDEVICE"); fi
        [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
    fi
}
[ -z "$1" -a -z "$FOX_BUILD_DEVICE" ] && fox_get_target_device
if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
export LC_ALL="C"
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export OF_MAINTAINER="beryl-ofox14"
export BUILD_USERNAME=beryl
export BUILD_HOSTNAME=ofox
export FOX_TARGET_DEVICES="beryl,citrine"
export TARGET_DEVICE_ALT="citrine"
export FOX_VENDOR_BOOT_RECOVERY=1
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_AB_DEVICE=1
export FOX_VANILLA_BUILD=1
export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
export FOX_RECOVERY_VENDOR_BOOT_PARTITION="/dev/block/by-name/vendor_boot"
export TW_INCLUDE_CRYPTO=1
export TW_INCLUDE_CRYPTO_FBE=1
export TW_INCLUDE_FBE_METADATA_DECRYPT=1
export TW_USE_FSCRYPT_POLICY=2
export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_BUSYBOX_BINARY=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_ZSTD_BINARY=1
export FOX_USE_LZ4_BINARY=1
export FOX_USE_DATE_BINARY=1
export FOX_REPLACE_TOOLBOX_GETPROP=1
export FOX_USE_UPDATED_MAGISKBOOT=1
export FOX_COMPRESS_EXECUTABLES=1
export FOX_DELETE_AROMAFM=1
export FOX_DELETE_INITD_ADDON=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_ENABLE_FRP_ADDON=1
else
if [ -z "$FOX_BUILD_DEVICE" ] && [ -z "$BASH_SOURCE" ] && [ -z "$ZSH_VERSION" ]; then echo "I: This script requires bash or zsh. Not processing $FDEVICE"; fi
fi
