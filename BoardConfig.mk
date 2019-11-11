LOCAL_PATH := device/meizu/mblu2

# Architecture
ifeq ($(MBLU2_32_BUILD),true)
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
endif

# Board
TARGET_BOOTLOADER_BOARD_NAME := mt6735
TARGET_BOARD_PLATFORM := mt6735
TARGET_NO_BOOTLOADER := true
ifneq ($(MBLU2_32_BUILD),true)
TARGET_IS_64_BIT := true
endif

# Kernel
ifeq ($(MBLU2_32_BUILD),true)
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,32N2
else
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
endif

BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
TARGET_KERNEL_SOURCE := kernel/meizu/mblu2
TARGET_KERNEL_CONFIG := mblu2_defconfig
BOARD_MKBOOTIMG_ARGS := \
    --board $(TARGET_BOARD_PLATFORM) \
    --kernel_offset 0x8000 \
    --pagesize 2048

ifeq ($(MBLU2_32_BUILD),true)
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
BOARD_MKBOOTIMG_ARGS += \
    --base 0x40000000 \
    --ramdisk_offset 0x4000000 \
    --second_offset 0xF00000 \
    --tags_offset 0xE000000
else
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_MKBOOTIMG_ARGS += \
    --base 0x40078000 \
    --ramdisk_offset 0x3F88000 \
    --second_offset 0xE88000 \
    --tags_offset 0xDF88000
endif

# Partitons
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 50331648
BOARD_FLASH_BLOCK_SIZE := 131072

# Recovery
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery/root/etc/twrp.stock
TW_USE_MODEL_HARDWARE_ID_FOR_DEVICE_ID := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_HAS_NO_SELECT_BUTTON := true
RECOVERY_SDCARD_ON_DATA := true
TW_EXCLUDE_TWRPAPP := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_CRYPTO := true
TW_THEME := portrait_hdpi
TW_USE_TOOLBOX := true
