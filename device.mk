# SPDX-License-Identifier: Apache-2.0

LOCAL_PATH := device/xiaomi/beryl

# Virtual A/B with a vendor ramdisk, matching the stock Android 16 layout.
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

# Generic recovery/first-stage ramdisk support.
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Keep dynamic-partition handling enabled without hard-coding a super size.
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Validate the recovery-side VINTF configuration.
PRODUCT_ENFORCE_VINTF_MANIFEST := true

# AIDL boot-control and recovery services used by the stock Beryl platform.
PRODUCT_PACKAGES += \
    android.hardware.boot-V1-ndk \
    fastbootd \
    vold.recovery \
    vold_prepare_subdirs.recovery \
    wait_for_keymaster.recovery

# Android security components needed by FBE/KeyMint recovery integration.
PRODUCT_PACKAGES += \
    android.hardware.security.keymint \
    android.hardware.security.secureclock \
    android.hardware.security.sharedsecret

# Recovery-side filesystem utilities.
PRODUCT_PACKAGES += \
    e2fsck.vendor_ramdisk \
    fsck.f2fs.vendor_ramdisk \
    resize2fs.vendor_ramdisk \
    tune2fs.vendor_ramdisk

# The recovery fstab remains the authoritative recovery mount configuration.
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery.fstab
