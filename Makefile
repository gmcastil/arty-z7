SHELL			:= /bin/bash
NPROC			:= $(shell nproc)

# Top level directories that all subsystems inherit
REPO_DIR		:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SCRIPTS_DIR		:= $(REPO_DIR)/scripts
BIF_DIR			:= $(REPO_DIR)/bif
BUILD_DIR		:= $(REPO_DIR)/build
EXTERN_DIR		:= $(REPO_DIR)/extern

STAGING_DIR		:= $(BUILD_DIR)/staging
HW_EXPORT_DIR		:= $(BUILD_DIR)/hw_export
ROOTFS_DIR		:= $(STAGING_DIR)/rootfs

# Uncommon or overridden commands
PRINTF			:= builtin printf
VIVADO			:= vivado
XSCT			:= xsct
# QEMU			:= qemu-system-aarch64
QEMU			:= qemu-system-arm
BOOTGEN			:= bootgen
DEBSTRAP		:= mmdebstrap

.PHONY: help
help:
	@$(PRINTF) '%s\n' "Top-level targets:"
	@$(call print_help_entry,"fetch-extern","Shallow clones of all external software repositories")
	@$(call print_help_entry,"clean","Cleans all build artifacts from BUILD_DIR")
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory vivado-help
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory fsbl-help
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory uboot-help
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory qemu-help
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory boot-help
	@$(PRINTF) '\n'
	@$(MAKE) --no-print-directory linux-help

include $(REPO_DIR)/mk/config.mk
include $(REPO_DIR)/mk/stamps.mk
include $(REPO_DIR)/mk/functions.mk
include $(REPO_DIR)/mk/vivado.mk
include $(REPO_DIR)/mk/fsbl.mk
include $(REPO_DIR)/mk/uboot.mk
include $(REPO_DIR)/mk/qemu.mk
include $(REPO_DIR)/mk/boot.mk
include $(REPO_DIR)/mk/rootfs.mk
include $(REPO_DIR)/mk/linux.mk

fetch-extern: uboot-fetch linux-fetch

clean:
	@$(MAKE) vivado-clean
	@$(MAKE) fsbl-clean
	@$(MAKE) uboot-clean
	@$(MAKE) boot-clean
	@$(MAKE) linux-clean
	rm -rf $(REPO_DIR)/NA
	rm -rf $(REPO_DIR)/.Xil
