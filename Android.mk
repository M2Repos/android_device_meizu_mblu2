LOCAL_PATH := $(call my-dir)
ifneq ($(filter $(TARGET_DEVICE),mblu2),)
include $(call all-makefiles-under,$(LOCAL_PATH))
include $(CLEAR_VARS)
endif
