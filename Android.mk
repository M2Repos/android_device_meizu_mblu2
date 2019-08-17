LOCAL_PATH := $(call my-dir)
ifneq ($(filter mblu2,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))
include $(CLEAR_VARS)
BOARD_RECOVERY_IMAGE_PREPARE := $(LOCAL_PATH)/recovery/recovery_inject.sh "$(TARGET_RECOVERY_ROOT_OUT)"
endif
