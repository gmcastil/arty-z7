KERNEL_DEFCONFIG	:= xilinx_zynq_defconfig
KERNEL_IMAGE		:= zImage

# The kernel and U-boot don't follow the same conventions, so identify them explicitly
ARCH			:= arm
CROSS_COMPILE		:= arm-linux-gnueabihf-
