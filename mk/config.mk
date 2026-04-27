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

LINUX_SRC_URL		:= https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
LINUX_SRC_TAG		:= v6.18
# Branch that we will create locally for device tree development
LINUX_DEV_BRANCH	:= arty-z7-dts
# This is the only defconfig in arch/arm/configs that enables support for Zynq devices
LINUX_DEFCONFIG		:= multi_v7_defconfig
LINUX_IMAGE		:= zImage
LINUX_DEVICE_TREE	:= zynq-arty-z7
# Output from running `make kernelrelease` used for fixing up paths
LINUX_RELEASE		:= 6.18.0


