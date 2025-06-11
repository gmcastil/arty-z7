# GNU make happily deletes what it considers to be intermediate products which
# we want to preserve everywhere
.SECONDARY:

# Tools
SHELL			:= /bin/bash
GIT			:= git
XSCT			:= xsct
EXIT			:= exit
BOOTGEN			:= bootgen
DTC			:= dtc
RM			:= rm -v
CP			:= cp -v
LN			:= ln -v
YES			:= yes
SHA256			:= sha256sum
TOUCH			:= touch
INSTALL			:= install
MKDIR			:= mkdir -v
PRINTF			:= printf '%s\n'
MKNOD			:= mknod
FAKEROOT		:= fakeroot

PWD			:= $(shell pwd)
JOBS			:= $(shell nproc)

# Do not inherit user-specific git settings
export GIT_CONFIG_GLOBAL=/dev/null
GIT_FLAGS		:= -c advice.detachedHead=false --no-single-branch --depth 1
# Make it go fast!
MAKEFLAGS		:= -j $(JOBS)

# Shared directories
BUILD_DIR		:= $(PWD)/build
CONFIG_DIR		:= $(PWD)/config
STAGING_DIR		:= $(PWD)/rootfs

# Cloned git repository locations
EXTERN_DIR		:= $(PWD)/extern

# Toolchain parameters
ARCH			:= arm
CROSS_COMPILE		:= arm-linux-gnueabihf-

include mk/kernel.mk
include mk/initramfs.mk
include mk/dtb.mk

.PHONY: clean
# Targets that use XSCT to generate output products need to be run serially
# .NOTPARALLEL: %/$(FSBL_ELF) %/system-top.dts

$(EXTERN_DIR):
	$(MKDIR) -p $@

$(BUILD_DIR):
	$(MKDIR) -p $@

# -- Utility targets --
clean: kernel-clean initramfs-clean
	$(RM) -rf $(BUILD_DIR)
	$(RM) -rf $(STAGING_DIR)

distclean: kernel-distclean clean
	$(RM) -rf $(EXTERN_DIR)

