#
# Copyright (C) 2025-2026 The OrangeFox Recovery Project
# Device: beryl
# Target: OrangeFox fox_14.1
#
# SPDX-License-Identifier: GPL-3.0-only
#
DEVICE_PATH := device/xiaomi/beryl
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_TARGET_VNDK_VERSION := 34
BOARD_SHIPPING_API_LEVEL := 34
SHIPPING_API_LEVEL := 34
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock fastbootd \
    update_engine update_engine_sideload update_verifier checkpoint_gc otapreopt_script
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
PRODUCT_PACKAGES += linker.vendor_ramdisk e2fsck.vendor_ramdisk resize2fs.vendor_ramdisk fsck.vendor_ramdisk tune2fs.vendor_ramdisk
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6855:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6855

# Decryption payload (KeyMint mitee + Gatekeeper + keystore2 + vold)
ifneq ($(wildcard $(DEVICE_PATH)/prebuilt/decryption/vendor),)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/decryption/vendor,$(TARGET_COPY_OUT_RECOVERY)/root/vendor)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/decryption/system/system,$(TARGET_COPY_OUT_RECOVERY)/root/system)
endif

TW_THEME := portrait_hdpi
TW_DEFAULT_LANGUAGE := en
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := false
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_MAX_BRIGHTNESS := 4095
TW_DEFAULT_BRIGHTNESS := 2047
TW_EXCLUDE_APEX := true
TW_INCLUDE_FASTBOOTD := true
TW_FRAMERATE := 120
TW_NO_SCREEN_BLANK := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone0/temp"
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2
PLATFORM_VERSION := 14.0.0
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
TW_LOAD_VENDOR_BOOT_MODULES := true
TW_LOAD_VENDOR_MODULES := "ufs-mediatek-mod.ko phy-mtk-ufs.ko mtk-mmc.ko cqhci.ko blocktag.ko mitee.ko teeperf.ko mcDrvModule.ko mtk_iommu.ko system_heap.ko pinctrl-mtk-v2.ko pinctrl-mt6855.ko fts_touch_i2c.ko xiaomi_tp.ko lct_tp.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
