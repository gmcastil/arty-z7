include config.mk
include arty-z7.mk

# GNU make happily deletes what it considers to be intermediate products which
# we want to preserve everywhere
.SECONDARY:

# Tools
SHELL			:= /bin/bash
GIT			:= git
BEAR			:= bear
XSCT			:= xsct
BOOTGEN			:= bootgen
DTC			:= dtc
GCC			:= gcc
SHA256			:= sha256sum
INSTALL			:= install
PRINTF			:= printf

PWD			:= $(shell pwd)
JOBS			:= $(shell nproc)

MAKEFLAGS		:= -j $(JOBS) --debug=b -n

# Do not inherit user-specific git settings
export GIT_CONFIG_GLOBAL=/dev/null
GIT_FLAGS		:= -c advice.detachedHead=false --no-single-branch --depth 1

BUILD_DIR		:= $(PWD)/build
STAGING_DIR		:= $(PWD)/rootfs

CONFIG_DIR		:= $(PWD)/config
KERNEL_BUILD_DIR	:= $(BUILD_DIR)/kernel

# Cloned git repository locations
XILINX_SRC_DIR		:= $(PWD)/Xilinx
KERNEL_SRC_DIR		:= $(XILINX_SRC_DIR)/linux-xlnx

# User can override a new configuration file to use
KERNEL_CONFIG		:= $(CONFIG_DIR)/arty-z7.config
KERNEL_MENUCONFIG	?= 0

# Targets that use XSCT to generate output products need to be run serially
# .NOTPARALLEL: %/$(FSBL_ELF) %/system-top.dts

# -- Kernel targets --
.PHONY: kernel-all kernel-install kernel-build kernel-config kernel-refresh kernel-fetch

.PHONY: clean

kernel-all: kernel-install

kernel-install: kernel-build $(STAGING_DIR)
	# Install the kernel to the output build directory
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) INSTALL_PATH=$(STAGING_DIR)/boot install
	# Install the modules to the output build directory
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) INSTALL_MOD_PATH=$(STAGING_DIR) modules_install
	# Install the kernel headers for use by userspace
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) INSTALL_HDR_PATH=$(STAGING_DIR)/usr headers_install
	# Generate compile commands for clangd (i.e., LSP needs to know how we built this)
	$(KERNEL_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-d $(KERNEL_BUILD_DIR) -o $(KERNEL_SRC_DIR)/compile_commands.json 

kernel-build: kernel-config
	# Build the kernel image
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) $(KERNEL_IMAGE)
	# Build kernel modules
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) modules

kernel-config: kernel-fetch
	# Note that we always start from a clean slate here
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) mrproper
	# If the configuration file was unset at runtime, we run defconfig,
	# otherwise we use the provided configuration and then run olddefconfig
	if [[ -z "$(KERNEL_CONFIG)" ]]; then \
		$(PRINTF) '%s\n' "No configuration provided, running defconfig" >&1; \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) $(KERNEL_DEFCONFIG); \
	elif [[ -f "$(KERNEL_CONFIG)" ]]; then \
		$(PRINTF) '%s\n' "Using existing configuration, running olddefconfig" >&1; \
		$(INSTALL) -m 664 "$(KERNEL_CONFIG)" "$(KERNEL_BUILD_DIR)/.config"; \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) olddefconfig; \
	else \
		$(PRINTF) '%s\n' "Kernel configuration file not found" >&2; exit 1; \
	fi
	# When no configuration is provided, we force menuconfig, otherwise user
	if [[ -z "$(KERNEL_CONFIG)" || "$(KERNEL_MENUCONFIG)" -eq 1 ]]; then \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) menuconfig; \
	fi
	# Hash the .config so we know what was built
	$(SHA256) $(KERNEL_BUILD_DIR)/.config > $(KERNEL_BUILD_DIR)/.last_config.sha256

kernel-refresh:
	if [[ -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) -C $(KERNEL_SRC_DIR) checkout $(KERNEL_SRC_TAG); \
		$(GIT) -C $(KERNEL_SRC_DIR) reset --hard; \
		$(GIT) -C $(KERNEL_SRC_DIR) clean -dfx; \
	fi

kernel-fetch: $(KERNEL_SRC_DIR)/Makefile

$(STAGING_DIR):
	mkdir -pv $(STAGING_DIR)
	mkdir -pv $(STAGING_DIR)/boot $(STAGING_DIR)/lib $(STAGING_DIR)/usr

$(XILINX_SRC_DIR):
	mkdir -pv $(XILINX_SRC_DIR)

$(KERNEL_SRC_DIR)/Makefile: $(XILINX_SRC_DIR)
	if [[ ! -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) clone $(GIT_FLAGS) --branch $(KERNEL_SRC_TAG) $(KERNEL_SRC_URL) $(KERNEL_SRC_DIR); \
	fi

clean:
	rm -f $(KERNEL_SRC_DIR)/compile_commands.json
	rm -rf $(BUILD_DIR)


