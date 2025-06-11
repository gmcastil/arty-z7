# Xilinx linux kernel git repository
KERNEL_SRC_URL			:= https://github.com/Xilinx/linux-xlnx.git
KERNEL_SRC_TAG			:= xilinx-v2024.2
KERNEL_SRC_DIR			:= $(EXTERN_DIR)/linux-xlnx

KERNEL_DEFCONFIG		:= xilinx_zynq_defconfig
KERNEL_IMAGE			:= zImage
# Platform to create a device tree for (see linux-xlnx/arch/arm/boot/dts/xilinx for options)
KERNEL_DTB			?= zynq-zc702.dtb
# User can override a new configuration file to use and optionally run menuconfig after
KERNEL_CONFIG			?= $(CONFIG_DIR)/arty-z7.config

# Out of tree build location
KERNEL_BUILD_DIR		:= $(BUILD_DIR)/kernel

# Build artifacts for usage elsewhere
KERNEL_RELEASE			:= $(KERNEL_BUILD_DIR)/.kernel-release
KERNEL_CONFIG_SHA256		:= $(KERNEL_BUILD_DIR)/.kernel-config-sha256
# The kernel release string needs to be computed several times later when setting up paths
# or copying modules and headers. So we use lazy evaluation here.
KERNEL_RELEASE_STR		= $(shell [[ -f $(KERNEL_RELEASE) ]] && cat $(KERNEL_RELEASE))

# Dependancy stamps
KERNEL_STAMP_CONFIG_FINAL	:= $(KERNEL_BUILD_DIR)/.stamp-kernel-config-final
KERNEL_STAMP_BUILD		:= $(KERNEL_BUILD_DIR)/.stamp-kernel-build
KERNEL_STAMP_BUILD_DTB		:= $(KERNEL_BUILD_DIR)/.stamp-kernel-build-dtb
KERNEL_STAMP_INSTALL		:= $(KERNEL_BUILD_DIR)/.stamp-kernel-install

.PHONY: kernel-help
.PHONY: kernel-install kernel-build kernel-dtb
.PHONY: kernel-config kernel-menuconfig kernel-reconfigure
.PHONY: kernel-fetch kernel-refresh
.PHONY: kernel-clean kernel-distclean

kernel-help:
	@$(PRINTF) "Kernel build targets:"
	@$(PRINTF) "  kernel-distclean     Remove both kernel build and source trees"
	@$(PRINTF) "  kernel-clean         Deletes the kernel build directory and cleans the source tree"
	@$(PRINTF) "  kernel-fetch         Clone the kernel source repository"
	@$(PRINTF) "  kernel-refresh       Reset and clean the kernel source tree"
	@$(PRINTF) "  kernel-defconfig     Initialize .config from $(KERNEL_DEFCONFIG)"
	@$(PRINTF) "  kernel-config        Overwrite with saved config"
	@$(PRINTF) "  kernel-menuconfig    Run menuconfig on existing .config and finalize"
	@$(PRINTF) "  kernel-build         Build kernel image and modules"
	@$(PRINTF) "  kernel-dtb           Build selected DTB: $(KERNEL_DTB)"
	@$(PRINTF) "  kernel-install       Install image, modules, headers, and LSP metadata"

kernel-install: $(KERNEL_STAMP_INSTALL)
	$(PRINTF) "Kernel install complete" >&1

# Installs the kernel, modules, headers, and a compiler commands file for clangd
$(KERNEL_STAMP_INSTALL): $(KERNEL_STAMP_BUILD) $(KERNEL_STAMP_BUILD_DTB)
	$(MKDIR) -pv $(STAGING_DIR)/boot $(STAGING_DIR)/lib $(STAGING_DIR)/usr
	# Install the kernel image and minimal device tree
	$(INSTALL) -m 644 $(KERNEL_BUILD_DIR)/arch/$(ARCH)/boot/$(KERNEL_IMAGE) \
		$(STAGING_DIR)/boot/
	$(INSTALL) -m 644 $(KERNEL_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(KERNEL_DTB) \
		$(STAGING_DIR)/boot/
	# Install kernel modules
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) INSTALL_MOD_PATH=$(STAGING_DIR) modules_install
	# Install kernel headers
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) INSTALL_HDR_PATH=$(STAGING_DIR)/usr headers_install
	# Adjust the symlink in the rootfs directory so that it points to where
	# the headers are rather than a hard coded path to the source tree. The same correction
	# needs to be made when constructing the initramfs.
	$(RM) -fv $(STAGING_DIR)/lib/modules/$(KERNEL_RELEASE_STR)/build
	$(LN) -sfv /usr/include $(STAGING_DIR)/lib/modules/$(KERNEL_RELEASE_STR)/build
	# Generate compile commands for clangd (i.e., LSP needs to know how we built this)
	$(KERNEL_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-d $(KERNEL_BUILD_DIR) -o $(KERNEL_SRC_DIR)/compile_commands.json 
	# Now we can create a stamp file
	$(TOUCH) $@

# Launches the kernel build
kernel-build: $(KERNEL_STAMP_BUILD)
	@$(PRINTF) "Info: Kernel build complete" >&1

# Launches the kernel device tree compilation
kernel-dtb: $(KERNEL_STAMP_BUILD_DTB)
	@$(PRINTF) "Info: Kernel device tree build complete" >&1

# Compiles the DTB that was chosen (the dtbs target builds everything for this arch)
$(KERNEL_STAMP_BUILD_DTB): $(KERNEL_STAMP_BUILD)
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) dtbs
	$(TOUCH) $@

# Builds the kernel and modules from whatever the finalized configuration was
$(KERNEL_STAMP_BUILD): $(KERNEL_STAMP_CONFIG_FINAL)
	# Build the kernel image for booting
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) $(KERNEL_IMAGE)
	# Build kernel modules
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) modules
	$(TOUCH) $@

# Finalizes the configuration with a config hash and kernel release
$(KERNEL_STAMP_CONFIG_FINAL): $(KERNEL_BUILD_DIR)/.config
	$(SHA256) $(KERNEL_BUILD_DIR)/.config > $(KERNEL_CONFIG_SHA256)
	$(MAKE) -s -C $(KERNEL_SRC_DIR) O=$(KERNEL_BUILD_DIR) kernelrelease > $(KERNEL_RELEASE)
	$(TOUCH) $@

# Use an existing configuration or override with KERNEL_CONFIG
kernel-config: $(KERNEL_BUILD_DIR) $(KERNEL_SRC_DIR)/Makefile
	@if [[ -f "$(KERNEL_BUILD_DIR)/.config" ]]; then \
		$(PRINTF) "Warning: Overwriting existing configuration with $(KERNEL_CONFIG)"; \
	fi
	$(INSTALL) -m 664 "$(KERNEL_CONFIG)" "$(KERNEL_BUILD_DIR)/.config"
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) olddefconfig
	# Configuration might have been overwritten so we invalidate it here
	$(RM) -f $(KERNEL_CONFIG_SHA256) $(KERNEL_RELEASE) $(KERNEL_STAMP_CONFIG_FINAL)

# Runs the kernel menuconfig with existing configuration or runs `make defconfig` if no
# kernel configuration has been created yet
kernel-menuconfig:
	@if [[ ! -f $(KERNEL_BUILD_DIR)/.config ]]; then \
		$(PRINTF) "Warning: No existing configuration found. Running defconfig."; \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) mrproper; \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) $(KERNEL_DEFCONFIG); \
	fi
	# Running menuconfig obviously modifies the .config so we invalidate it here
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) menuconfig
	$(RM) -f \
		$(KERNEL_CONFIG_SHA256) \
		$(KERNEL_RELEASE) \
		$(KERNEL_STAMP_CONFIG_FINAL)

# Use an upstream defconfig for an initial configuration, which doesn't
# finalize a configuration (e.g., running a build after this will use existing config)
kernel-defconfig: $(KERNEL_BUILD_DIR) $(KERNEL_SRC_DIR)/Makefile
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) mrproper
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) $(KERNEL_DEFCONFIG); \
	# Running defconfig generates a new baseline .config but doesn't finalize it
	$(RM) -f \
		$(KERNEL_CONFIG_SHA256) \
		$(KERNEL_RELEASE) \
		$(KERNEL_STAMP_CONFIG_FINAL)

$(KERNEL_BUILD_DIR)/.config:
	@$(PRINTF) "Error: No .config file found in $(KERNEL_BUILD_DIR). Run one of `kernel-config`, `kernel-menuconfig`, or `kernel-defconfig`" >&2
	@$(EXIT)

# Clones the kernel source repository
kernel-fetch: $(KERNEL_SRC_DIR)/Makefile

$(KERNEL_BUILD_DIR): $(BUILD_DIR)
	$(MKDIR) -p $@

$(KERNEL_SRC_DIR)/Makefile: $(EXTERN_DIR)
	if [[ ! -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) clone $(GIT_FLAGS) --branch $(KERNEL_SRC_TAG) $(KERNEL_SRC_URL) $(KERNEL_SRC_DIR); \
	fi

# Aggressively cleans the kernel source repository
kernel-refresh:
	if [[ -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) -C $(KERNEL_SRC_DIR) checkout $(KERNEL_SRC_TAG); \
		$(GIT) -C $(KERNEL_SRC_DIR) reset --hard; \
		$(GIT) -C $(KERNEL_SRC_DIR) clean -dfx; \
	fi

# Cleans the kernel source tree and deletes the build directory
kernel-clean: kernel-refresh
	$(RM) -f $(KERNEL_SRC_DIR)/compile_commands.json
	$(RM) -rf $(KERNEL_BUILD_DIR)

kernel-distclean: kernel-clean
	$(RM) -rf $(KERNEL_SRC_DIR)

