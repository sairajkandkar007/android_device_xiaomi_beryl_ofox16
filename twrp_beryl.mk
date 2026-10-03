#
# Copyright (C) 2025-2026 The OrangeFox Recovery Project
# Device: beryl
# Target: OrangeFox fox_14.1 (bp2a)
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# fox_14.1 common config path
$(call inherit-product, vendor/twrp/config/common.mk)

$(call inherit-product, device/xiaomi/beryl/device.mk)

PRODUCT_DEVICE := beryl
PRODUCT_NAME := twrp_beryl
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := POCO M7 Pro 5G
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
