include config.mk
include arty-z7.mk

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

# GNU make happily deletes what it considers to be intermediate products which
# we want to preserve everywhere
.SECONDARY:

# Do not inherit user-specific git settings
export GIT_CONFIG_GLOBAL=/dev/null
GIT_FLAGS		:= -c advice.detachedHead=false --no-single-branch --depth 1

BUILD_DIR		:= $(PWD)/build
KERNEL_BUILD_DIR	:= $(BUILD_DIR)/kernel
CONFIG_DIR		:= $(PWD)/config

# Cloned git repository locations
XILINX_SRC_DIR		:= $(PWD)/Xilinx
KERNEL_SRC_DIR		:= $(XILINX_SRC_DIR)/linux-xlnx

# User can override a new configuration file to use
ARTY_CONFIG		:= $(CONFIG_DIR)/arty-z7.config

# Targets that use XSCT to generate output products need to be run serially
# .NOTPARALLEL: %/$(FSBL_ELF) %/system-top.dts

.PHONY: kernel
kernel: $(KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/$(KERNEL_IMAGE)

$(XILINX_SRC_DIR):
	mkdir $(XILINX_SRC_DIR)

# -- Kernel targets --
$(KERNEL_SRC_DIR)/Makefile: $(XILINX_SRC_DIR)
	if [[ ! -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) clone $(GIT_FLAGS) --branch $(KERNEL_SRC_TAG) $(KERNEL_SRC_URL) $(KERNEL_SRC_DIR); \
	fi

$(KERNEL_BUILD_DIR)/.config: $(KERNEL_SRC_DIR)/Makefile
	# Note that we always start from a clean slate here
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) mrproper
	# If the configuration file was unset at runtime, we run defconfig,
	# otherwise we use olddefconfig
	if [[ -z "$(ARTY_CONFIG)" ]]; then \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) $(KERNEL_DEFCONFIG); \
	elif [[ -f "$(ARTY_CONFIG)" ]]; then \
		$(INSTALL) -m 664 "$(ARTY_CONFIG)" "$@"; \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) olddefconfig; \
	else \
		$(PRINTF) '%s\n' "Kernel configuration file not found" >&2; exit 1; \
	fi
	# Now run menuconfig on which configuration that was selected
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) menuconfig
	# Hash the .config so we know what was built
	$(SHA256) $(KERNEL_BUILD_DIR)/.config > $(KERNEL_BUILD_DIR)/.last_config.sha256

# Build the kernel 
$(KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/$(KERNEL_IMAGE): $(KERNEL_BUILD_DIR)/.config
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) -j$(JOBS) $(KERNEL_IMAGE)
	$(KERNEL_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-o $(KERNEL_SRC_DIR)/compile_commands.json \
		-d $(KERNEL_BUILD_DIR)

.PHONY: kernel-refresh
kernel-refresh:
	if [[ -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) -C $(KERNEL_SRC_DIR) checkout $(KERNEL_SRC_TAG); \
		$(GIT) -C $(KERNEL_SRC_DIR) reset --hard; \
		$(GIT) -C $(KERNEL_SRC_DIR) clean -dfx; \
	fi

clean:
	rm -f $(PWD)/build/kernel/.config
	rm -rf $(PWD)/build/kernel

