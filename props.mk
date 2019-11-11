# ADB
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += persist.sys.usb.config=adb
endif

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += ro.boot.btmacaddr=00:00:00:00:00:00

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=192m \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heaptargetutilization=0.75

# DRM
PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true

# Graphics and codecs
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=1 \
    ro.opengles.version=196609 \
    ro.sf.lcd_density=300 \
    ro.vendor.mtk_config_max_dram_size=0x800000000 \
    ro.vendor.mtk_pq_color_mode=1 \
    ro.vendor.mtk_pq_support=2 \
    vendor.mtk.vdec.waitkeyframeforplay=1

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    persist.sys.mtk.disable.incoming.fix=1 \
    persist.vendor.connsys.chipid=-1 \
    persist.vendor.connsys.patch.version=-1 \
    persist.vendor.radio.fd.counter=150 \
    persist.vendor.radio.fd.off.counter=50 \
    persist.vendor.radio.fd.off.r8.counter=50 \
    persist.vendor.radio.fd.r8.counter=150 \
    persist.vendor.radio.msimmode=dsds \
    persist.vendor.radio.mtk_dsbp_support=1 \
    persist.vendor.radio.mtk_ps2_rat=G \
    ro.boot.opt_lte_support=1 \
    ro.boot.opt_md1_support=5 \
    ro.boot.opt_ps1_rat=Lf/Lt/W/G \
    ro.boot.opt_using_default=1 \
    ro.telephony.default_network=9,9 \
    ro.vendor.mtk_flight_mode_power_off_md=1 \
    ro.vendor.mtk_log_hide_gps=1 \
    ro.vendor.mtk_protocol1_rat_config=Lf/Lt/W/G \
    ro.vendor.mtk_ril_mode=c6m_3rild \
    ro.vendor.mtk_sim_hot_swap_common_slot=1
