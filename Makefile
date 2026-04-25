SHELL			:= /bin/bash
NPROC			:= $(shell nproc)

# Top level directories that all subsystems inherit
REPO_DIR		:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SCRIPTS_DIR		:= $(REPO_DIR)/scripts
BUILD_DIR		:= $(REPO_DIR)/build
EXTERN_DIR		:= $(REPO_DIR)/extern

STAGING_DIR		:= $(BUILD_DIR)/staging

# Uncommon or overridden commands
PRINTF			:= builtin printf
VIVADO			:= vivado
XSCT			:= xsct

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

include $(REPO_DIR)/mk/config.mk
include $(REPO_DIR)/mk/functions.mk
include $(REPO_DIR)/mk/vivado.mk
include $(REPO_DIR)/mk/fsbl.mk
include $(REPO_DIR)/mk/uboot.mk

fetch-extern: uboot-fetch

clean:
	@$(MAKE) vivado-clean
	@$(MAKE) fsbl-clean

