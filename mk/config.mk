# Common Xilinx variables
VIVADO_VERSION		:= 2024.2

# Common tool arguments
GIT_FLAGS		:= -c advice.detachedHead=false --no-single-branch --depth 1

# Cross compilation settings
CROSS_COMPILE		:= arm-linux-gnueabihf-
ARCH			:= arm

# FSBL specific settings
FSBL_CFLAGS		:= -DFSBL_DEBUG_INFO
FSBL_ELF		:= fsbl.elf

# U-boot specific settings
UBOOT_SRC_URL		:= https://source.denx.de/u-boot/u-boot
UBOOT_SRC_TAG		:= v2026.04
# Branch that we will create locally for device tree development
UBOOT_DEV_BRANCH	:= arty-z7-dts
UBOOT_DEFCONFIG		:= xilinx_zynq_virt_defconfig
UBOOT_DEVICE_TREE	:= zynq-arty-z7
UBOOT_ELF		:= u-boot.elf

# QEMU settings
QEMU_MACHINE_TYPE	:=xilinx-zynq-a9

# Bootgen specific settings
PLATFORM		:= zynq
BOOT_BIF		:= arty-z7-20.bif

# LINUX_SRC_URL		:=
# LINUX_SRC_TAG		:=

