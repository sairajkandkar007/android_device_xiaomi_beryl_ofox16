# SPDX-License-Identifier: Apache-2.0

LOCAL_PATH := device/xiaomi/beryl

PRODUCT_SHIPPING_API_LEVEL := 35

# Recovery device configuration is intentionally kept free of legacy TWRP
# vendor/omni dependencies. OrangeFox provides the recovery build layer.

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/recovery.fstab
