ifneq ($(wildcard vendor/lineage/.),)
LINEAGEOS_BUILD := true
endif

MBLU2_32_BUILD := false

ifeq ($(LINEAGEOS_BUILD),true)
PRODUCT_MAKEFILES := $(LOCAL_DIR)/lineage_mblu2.mk
endif
