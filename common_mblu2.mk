# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from mblu2 device
$(call inherit-product, device/meizu/mblu2/device.mk)

PRODUCT_BRAND := Meizu
PRODUCT_DEVICE := mblu2
PRODUCT_MANUFACTURER := Meizu
PRODUCT_MODEL := M2

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_GMS_CLIENTID_BASE := android-meizu
PRODUCT_BUILD_PROP_OVERRIDES += PRIVATE_BUILD_DESC="meizu_M6Note-user 7.1.2 N2G47H m1721.Flyme_7.0.1539977208 release-keys"
BUILD_FINGERPRINT := "Meizu/meizu_M6Note/M6Note:7.1.2/N2G47H/m1721.Flyme_7.0.1539977208:user/release-keys"
endif
