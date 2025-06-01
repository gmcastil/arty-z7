# Xilinx linux kernel git repository
KERNEL_SRC_URL		:= https://github.com/Xilinx/linux-xlnx.git
KERNEL_SRC_TAG		:= xilinx-v2024.2
KERNEL_SRC_DIR		:= $(EXTERN_DIR)/linux-xlnx

KERNEL_DEFCONFIG	:= xilinx_zynq_defconfig
KERNEL_IMAGE		:= zImage
# Platform to create a device tree for (see linux-xlnx/arch/arm/boot/dts/xilinx for options)
KERNEL_DTB		?= zynq-zc702.dtb

# User can override a new configuration file to use and optionally run menuconfig after
KERNEL_CONFIG		?= $(CONFIG_DIR)/arty-z7.config

# Out of tree build location
KERNEL_BUILD_DIR	:= $(BUILD_DIR)/kernel

.PHONY: kernel-help
.PHONY: kernel-install kernel-build
.PHONY: kernel-config kernel-menuconfig kernel-reconfigure
.PHONY: kernel-fetch kernel-refresh
.PHONY: kernel-show-vars kernel-clean

kernel-help:
	@$(PRINTF) '%s\n' ""
	@$(PRINTF) '%s\n' "Kernel Makefile Targets:"
	@$(PRINTF) '%s\n' "  kernel-fetch         Clone the kernel source repository"
	@$(PRINTF) '%s\n' "  kernel-refresh       Reset and clean the kernel source tree"
	@$(PRINTF) '%s\n' "  kernel-config        Configure the kernel using defconfig or a saved .config"
	@$(PRINTF) '%s\n' "  kernel-menuconfig    Launch interactive configuration menu"
	@$(PRINTF) '%s\n' "  kernel-reconfigure   Delete the config stamp to allow reconfiguring"
	@$(PRINTF) '%s\n' "  kernel-build         Build the kernel image and modules"
	@$(PRINTF) '%s\n' "  kernel-install       Install image, modules, headers, and compile_commands.json"
	@$(PRINTF) '%s\n' "  kernel-clean         Delete the kernel build directory and LSP metadata"
	@$(PRINTF) '%s\n' "  kernel-distclean     Remove both the build and source directories"
	@$(PRINTF) '%s\n' "  kernel-show-vars     Display current kernel build configuration"
	@$(PRINTF) '%s\n' ""

kernel-install: $(KERNEL_BUILD_DIR)/.stamp-kernel-install
	$(PRINTF) '%s\n' "Kernel install complete" >&1

# Installs the kernel, modules, headers, and a compiler commands file for clangd
$(KERNEL_BUILD_DIR)/.stamp-kernel-install: $(KERNEL_BUILD_DIR)/.stamp-kernel-install $(KERNEL_BUILD_DIR)/.stamp-kernel-dtb
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
	# Generate compile commands for clangd (i.e., LSP needs to know how we built this)
	$(KERNEL_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-d $(KERNEL_BUILD_DIR) -o $(KERNEL_SRC_DIR)/compile_commands.json 
	$(TOUCH) $@

# Launches the kernel build
kernel-build: $(KERNEL_BUILD_DIR)/.stamp-kernel-build
	$(PRINTF) '%s\n' "Kernel build complete" >&1

# Launches the kernel device tree compilation
kernel-dtb: $(KERNEL_BUILD_DIR)/.stamp-kernel-dtb
	$(PRINTF) '%s\n' "Kernel device tree complete" >&1

# Compiles the DTB that was chosen (the dtbs target builds everything for this arch)
$(KERNEL_BUILD_DIR)/.stamp-kernel-dtb: $(KERNEL_BUILD_DIR)/.stamp-kernel-build
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) dtbs
	$(TOUCH) $(KERNEL_BUILD_DIR)/.stamp-kernel-dtb

# Builds the kernel (depends on kernel-config instead of the config
# stamp, since we want to make sure the config was hashed before building)
$(KERNEL_BUILD_DIR)/.stamp-kernel-build: kernel-config
	# Build the kernel image for booting
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) $(KERNEL_IMAGE)
	# Build kernel modules
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) modules
	$(TOUCH) $@

# Requires that kernel configuration was performed and hashes the result
kernel-config: $(KERNEL_BUILD_DIR)/.stamp-kernel-config
	# Hash the .config so we know what was built
	$(SHA256) $(KERNEL_BUILD_DIR)/.config > $(KERNEL_BUILD_DIR)/.last_config.sha256

# Configures the kernel with an initial configuration
$(KERNEL_BUILD_DIR)/.stamp-kernel-config: $(KERNEL_BUILD_DIR) $(KERNEL_SRC_DIR)/Makefile
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
	# When no configuration was provided, we force menuconfig
	if [[ -z "$(KERNEL_CONFIG)" ]]; then \
		$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
			O=$(KERNEL_BUILD_DIR) menuconfig; \
	fi
	$(TOUCH) $@

# Runs the kernel menuconfig if the configuration has already been initialized
kernel-menuconfig: $(KERNEL_BUILD_DIR)/.stamp-kernel-config
	$(MAKE) -C $(KERNEL_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(KERNEL_BUILD_DIR) menuconfig
	# Hash the .config now, since we may have touched it
	$(SHA256) $(KERNEL_BUILD_DIR)/.config > $(KERNEL_BUILD_DIR)/.last_config.sha256

# Resets the configuration
kernel-reconfigure:
	$(RM) -f $(KERNEL_BUILD_DIR)/.stamp-kernel-config
	$(MAKE) kernel-config

# Clones the kernel source repository
kernel-fetch: $(KERNEL_SRC_DIR)/Makefile

$(KERNEL_BUILD_DIR): $(BUILD_DIR)
	$(MKDIR) -p $@

$(KERNEL_SRC_DIR)/Makefile: $(EXTERN_DIR)
	if [[ ! -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) clone $(GIT_FLAGS) --branch $(KERNEL_SRC_TAG) $(KERNEL_SRC_URL) $(KERNEL_SRC_DIR); \
	fi

# Shows internal variables for debugging
kernel-show-vars:
	@$(PRINTF) '%s\n' "KERNEL_SRC_URL     = $(KERNEL_SRC_URL)"
	@$(PRINTF) '%s\n' "KERNEL_SRC_TAG     = $(KERNEL_SRC_TAG)"
	@$(PRINTF) '%s\n' "KERNEL_SRC_DIR     = $(KERNEL_SRC_DIR)"
	@$(PRINTF) '%s\n' "KERNEL_DEFCONFIG   = $(KERNEL_DEFCONFIG)"
	@$(PRINTF) '%s\n' "KERNEL_IMAGE       = $(KERNEL_IMAGE)"
	@$(PRINTF) '%s\n' "KERNEL_CONFIG      = $(KERNEL_CONFIG)"
	@$(PRINTF) '%s\n' "KERNEL_BUILD_DIR   = $(KERNEL_BUILD_DIR)"

# Aggressively cleans the kernel source repository
kernel-refresh:
	if [[ -d $(KERNEL_SRC_DIR) ]]; then \
		$(GIT) -C $(KERNEL_SRC_DIR) checkout $(KERNEL_SRC_TAG); \
		$(GIT) -C $(KERNEL_SRC_DIR) reset --hard; \
		$(GIT) -C $(KERNEL_SRC_DIR) clean -dfx; \
	fi

kernel-clean:
	$(RM) -f $(KERNEL_SRC_DIR)/compile_commands.json
	$(RM) -rf $(KERNEL_BUILD_DIR)

kernel-distclean: kernel-clean
	$(RM) -rf $(KERNEL_SRC_DIR)

