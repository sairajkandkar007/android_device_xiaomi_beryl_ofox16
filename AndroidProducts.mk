#
# Copyright (C) 2025-2026 The OrangeFox Recovery Project
# Device: beryl
# Target: OrangeFox fox_16.0 / Android 16 / BP2A
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_beryl.mk \
    $(LOCAL_DIR)/fox_beryl.mk

COMMON_LUNCH_CHOICES := \
    twrp_beryl-bp2a-eng \
    twrp_beryl-eng \
    fox_beryl-bp2a-eng \
    fox_beryl-eng
