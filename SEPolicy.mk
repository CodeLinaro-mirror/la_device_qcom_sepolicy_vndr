# Board specific SELinux policy variable definitions
ifeq ($(call is-vendor-board-platform,QCOM),true)
SEPOLICY_PATH:= device/qcom/sepolicy_vndr
QSSI_SEPOLICY_PATH:= device/qcom/sepolicy
SYS_ATTR_PROJECT_PATH := $(TOP)/device/qcom/sepolicy/generic/public/attribute
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS := \
    $(SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/public \
    $(QSSI_SEPOLICY_PATH)/qva/public

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS := \
    $(SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/private \
    $(QSSI_SEPOLICY_PATH)/qva/private

ifeq (,$(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _tb))
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(QSSI_SEPOLICY_PATH)/generic/car_private
else ifeq ($(TARGET_USES_CAR_FEATURES), true)
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(QSSI_SEPOLICY_PATH)/generic/car_private
endif

#once all the services are moved to Product /ODM above lines will be removed.
# sepolicy rules for product images
PRODUCT_PUBLIC_SEPOLICY_DIRS := \
    $(PRODUCT_PUBLIC_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/product/public \
    $(QSSI_SEPOLICY_PATH)/qva/product/public

PRODUCT_PRIVATE_SEPOLICY_DIRS := \
    $(PRODUCT_PRIVATE_SEPOLICY_DIRS) \
    $(QSSI_SEPOLICY_PATH)/generic/product/private \
    $(QSSI_SEPOLICY_PATH)/qva/product/private

ifeq (,$(filter sdm845 sdm710, $(TARGET_BOARD_PLATFORM)))
    BOARD_SEPOLICY_DIRS := \
       $(BOARD_SEPOLICY_DIRS) \
       $(SEPOLICY_PATH) \
       $(SEPOLICY_PATH)/generic/vendor/common \
       $(SEPOLICY_PATH)/qva/vendor/common \
       $(SEPOLICY_PATH)/generic/vendor/common/attribute \

    ifeq (,$(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _tb))
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/car_common
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/car_common
    else ifeq ($(TARGET_USES_CAR_FEATURES), true)
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/car_common
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/car_common
    endif

    ifeq ($(TARGET_SEPOLICY_DIR),)
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/$(TARGET_BOARD_PLATFORM)
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/$(TARGET_BOARD_PLATFORM)
    else
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/$(TARGET_SEPOLICY_DIR)
      BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/$(TARGET_SEPOLICY_DIR)
    endif

    ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/test
    BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/test
    BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/test/sysmonapp
    endif
endif

#Include sepolicy if ES enabled
ifeq ($(BOARD_SUPPORTS_RAMDISK_EARLY_INIT),true)
    #Include early services polcies
    ifneq ($(TARGET_ES_SEPOLICY_DIR),)
    ifneq ($(TARGET_SEPOLICY_DIR),)
    #folder path generic/vendor/early_services/gen3_metal or gen4_au
    BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/generic/vendor/$(TARGET_ES_SEPOLICY_DIR)/$(TARGET_SEPOLICY_DIR)
    BOARD_SEPOLICY_DIRS += $(SEPOLICY_PATH)/qva/vendor/$(TARGET_ES_SEPOLICY_DIR)/$(TARGET_SEPOLICY_DIR)
    endif #End TARGET_SEPOLICY_DIR (gen3_metal or gen4_au)
    endif #End TARGET_ES_SEPOLICY_DIR
endif #End BOARD_SUPPORTS_RAMDISK_EARLY_INIT

endif
