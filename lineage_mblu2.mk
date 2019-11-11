ifneq ($(MBLU2_32_BUILD),true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from common
$(call inherit-product, device/meizu/mblu2/common_mblu2.mk)

PRODUCT_NAME := lineage_mblu2
