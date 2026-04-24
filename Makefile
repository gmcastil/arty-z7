SHELL			:= /bin/bash
NPROC			:= $(shell nproc)

REPO_DIR		:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SCRIPTS_DIR		:= $(REPO_DIR)/scripts
BUILD_DIR		:= $(REPO_DIR)/build

PRINTF			:= builtin printf
VIVADO			:= vivado

.PHONY: help
help:
	@$(MAKE) --no-print-directory vivado-help

include $(REPO_DIR)/mk/functions.mk
include $(REPO_DIR)/mk/vivado.mk

clean:
	@$(MAKE) vivado-clean

