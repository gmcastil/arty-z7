PWD			:= $(shell pwd)

# Shared directories
BUILD_DIR		:= $(PWD)/build
CONFIG_DIR		:= $(PWD)/config
STAGING_DIR		:= $(PWD)/rootfs

# Cloned git repository locations
EXTERN_DIR		:= $(PWD)/extern

# Toolchain parameters
ARCH			:= arm
CROSS_COMPILE		:= arm-linux-gnueabihf-

