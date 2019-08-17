$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, build/target/product/embedded.mk)
$(call inherit-product, vendor/omni/config/common.mk)

PRODUCT_MANUFACTURER := Meizu
PRODUCT_RELEASE_NAME := mblu2
PRODUCT_NAME := omni_mblu2
PRODUCT_DEVICE := mblu2
PRODUCT_MODEL := M2
PRODUCT_BRAND := Meizu
