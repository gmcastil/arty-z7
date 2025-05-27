# The kernel and U-boot don't follow the same conventions, so identify them explicitly
KERNEL_ARCH		:= arm
KERNEL_CROSS_COMPILE	:= arm-linux-gnueabihf-
KERNEL_DEFCONFIG	:= xilinx_zynq_defconfig
KERNEL_IMAGE		:= zImage

