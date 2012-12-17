#
# This is the product configuration for a full umts_spyder
#

DEVICE_FOLDER := device/motorola/umts_spyder

# Device overlay
    DEVICE_PACKAGE_OVERLAYS += $(DEVICE_FOLDER)/overlay/aosp

# Audio
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/audio/alsa.omap4.so:/system/lib/hw/alsa.omap4.so \
    $(DEVICE_FOLDER)/audio/audio.primary.omap4.so:/system/lib/hw/audio.primary.umts_spyder.so \
    $(DEVICE_FOLDER)/audio/audio_policy.omap4.so:/system/lib/hw/audio_policy.omap4.so \
    $(DEVICE_FOLDER)/audio/libasound.so:/system/lib/libasound.so \
    $(DEVICE_FOLDER)/audio/libaudio_ext.so:/system/lib/libaudio_ext.so

# Hardware HALs
PRODUCT_PACKAGES += \
    hwcomposer.umts_spyder

# Modem
PRODUCT_PACKAGES += \
    Stk

# Root files
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/root/default.prop:/root/default.prop \
    $(DEVICE_FOLDER)/root/init.mapphone.rc:/root/init.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/init.mapphone.rc:/root/init.mapphone_umts.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/root/ueventd.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/root/ueventd.mapphone_umts.rc \
    $(DEVICE_FOLDER)/root/init.usb.rc:/root/init.usb.rc \

# Kexec files and ti ducati or rootfs files
ifeq ($(BOARD_USES_KEXEC),true)
ifeq ($(TARGET_PRODUCT),full_umts_spyder)
PRODUCT_COPY_FILES += device/motorola/common/prebuilt/etc/rootfs/init:root/init
endif
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/kexec/devtree:system/etc/kexec/devtree \
    $(OUT)/ramdisk.img:system/etc/kexec/ramdisk.img \
    $(DEVICE_FOLDER)/prebuilt/etc/firmware/ducati-m3.bin:system/etc/firmware/ducati-m3.bin \
    $(OUT)/kernel:system/etc/kexec/kernel
else
ifeq ($(TARGET_PRODUCT),full_umts_spyder)
PRODUCT_COPY_FILES += device/motorola/common/prebuilt/etc/rootfs/init:system/etc/rootfs/init
else
PRODUCT_COPY_FILES += $(OUT)/root/init:system/etc/rootfs/init
endif
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/root/default.prop:/system/etc/rootfs/default.prop \
    system/core/rootdir/init.rc:/system/etc/rootfs/init.rc \
    system/core/rootdir/ueventd.rc:/system/etc/rootfs/ueventd.rc \
    $(DEVICE_FOLDER)/root/init.usb.rc:/system/etc/rootfs/init.usb.rc \
    $(DEVICE_FOLDER)/root/init.mapphone.rc:/system/etc/rootfs/init.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/init.mapphone.rc:/system/etc/rootfs/init.mapphone_umts.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/system/etc/rootfs/ueventd.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/system/etc/rootfs/ueventd.mapphone_umts.rc \
    $(OUT)/root/sbin/adbd:system/etc/rootfs/sbin/adbd
endif

# Prebuilts
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/bin/battd:system/bin/battd \
    $(DEVICE_FOLDER)/prebuilt/bin/mount_ext3.sh:system/bin/mount_ext3.sh \
    $(DEVICE_FOLDER)/prebuilt/etc/gps.conf:system/etc/gps.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/media_codecs.xml:system/etc/media_codecs.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/audio_policy.conf:system/etc/audio_policy.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/vold.fstab:system/etc/vold.fstab \


# copy all kernel modules under the "modules" directory to system/lib/modules
ifneq ($(BOARD_USES_KEXEC),true)
PRODUCT_COPY_FILES += $(shell \
    find device/motorola/umts_spyder/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')
endif

$(call inherit-product, device/motorola/common/common.mk)
$(call inherit-product-if-exists, vendor/motorola/umts_spyder/umts_spyder-vendor.mk)
ifneq ($(BOARD_USES_KEXEC),true)
$(call inherit-product-if-exists, vendor/motorola/umts_spyder/umts_spyder-vendor-pvr.mk)
$(call inherit-product-if-exists, vendor/motorola/umts_spyder/umts_spyder-vendor-stock-camera.mk)
$(call inherit-product-if-exists, vendor/motorola/umts_spyder/umts_spyder-vendor-stock-ducati.mk)
endif
