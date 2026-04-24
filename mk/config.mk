# Common Xilinx variables
VIVADO_VERSION		:= 2024.2

# Common tool arguments
GIT_FLAGS		:= -c advice.detatchedHead=false --no-single-branch --depth 1

# Cross compilation settings
CROSS_COMPILE		:= arm-linux-gnueabihf-
ARCH			:= arm

# FSBL specific settings
FSBL_CFLAGS		:= -DFSBL_DEBUG_INFO
FSBL_ELF		:= fsbl.elf

# URL for repositories cloned into extern/
# UBOOT_SRC_TAG		:=
# LINUX_SRC_URL		:=
# LINUX_SRC_TAG		:=

