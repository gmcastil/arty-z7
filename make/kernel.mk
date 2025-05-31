# Xilinx linux kernel git repository
KERNEL_SRC_URL		:= https://github.com/Xilinx/linux-xlnx.git
KERNEL_SRC_TAG		:= xilinx-v2024.2
KERNEL_SRC_DIR		:= $(EXTERN_DIR)/linux-xlnx

KERNEL_DEFCONFIG	:= xilinx_zynq_defconfig
KERNEL_IMAGE		:= zImage

# User can override a new configuration file to use and optionally run menuconfig after
KERNEL_CONFIG		?= $(CONFIG_DIR)/arty-z7.config

# Out of tree build location
KERNEL_BUILD_DIR	:= $(BUILD_DIR)/kernel

.PHONY: kernel-install kernel-build
.PHONY: kernel-config kernel-menuconfig kernel-reconfigure
.PHONY: kernel-fetch kernel-refresh
.PHONY: kernel-show-vars kernel-clean

kernel-install: $(KERNEL_BUILD_DIR)/.stamp-kernel-install

# Installs the kernel, modules, headers, and a compiler commands file for clangd
$(KERNEL_BUILD_DIR)/.stamp-kernel-install: kernel-build
	$(MKDIR) -pv $(STAGING_DIR)/boot $(STAGING_DIR)/lib $(STAGING_DIR)/usr
	# Install the kernel image
	$(INSTALL) -m 644 $(KERNEL_BUILD_DIR)/arch/$(ARCH)/boot/$(KERNEL_IMAGE) \
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
$(KERNEL_BUILD_DIR)/.stamp-kernel-config: $(KERNEL_BUILD_DIR)
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
	$(RM) -f $(KERNEL_SRC_DIR)

