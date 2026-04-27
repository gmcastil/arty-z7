LINUX_SRC_DIR			:= $(EXTERN_DIR)/linux
# We perform out of tree builds for linux
LINUX_BUILD_DIR			:= $(BUILD_DIR)/linux
# Source tree was cloned to extern/
LINUX_SRC_CLONED_STAMP		:= $(LINUX_SRC_DIR)/.stamp_linux_src_cloned
# Source tree was branched for hacking
LINUX_SRC_BRANCHED_STAMP	:= $(LINUX_SRC_DIR)/.stamp_linux_src_branched
# Configuration was changed
LINUX_CONFIG_STAMP		:= $(LINUX_BUILD_DIR)/.stamp_linux_src_config
LINUX_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_linux_staged

.PHONY: linux-rebuild linux-release linux-stage linux-build linux-build-dt linux-defconfig
.PHONY: linux-menuconfig linux-fetch linux-help linux-clean linux-distclean

linux-rebuild:
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) $(LINUX_IMAGE)
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) modules
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) xilinx/$(LINUX_DEVICE_TREE).dtb
	$(LINUX_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-d $(LINUX_BUILD_DIR) \
		-o $(LINUX_SRC_DIR)/compile_commands.json

# Convenience target for getting the kernel version during development
linux-release:
	$(MAKE) -C $(LINUX_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) kernelrelease

linux-stage: $(LINUX_STAGED_STAMP)

$(LINUX_STAGED_STAMP): \
	$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/$(LINUX_IMAGE) \
	$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(LINUX_DEVICE_TREE).dtb
	mkdir -pv $(ROOTFS_DIR)/lib $(ROOTFS_DIR)/usr
	# Install the kernel image
	install -D -m 644 $(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/$(LINUX_IMAGE) \
		$(STAGING_DIR)/$(LINUX_IMAGE)
	# Install the kernel modules
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) INSTALL_MOD_PATH=$(ROOTFS_DIR) modules_install
	# Install kernel headers
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr headers_install
	# Install the kernel device tree
	install -D -m 644 $(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(LINUX_DEVICE_TREE).dtb \
		$(STAGING_DIR)/$(LINUX_DEVICE_TREE).dtb
	# Remove the broken symlink left behind
	rm -f $(ROOTFS_DIR)/lib/modules/$(LINUX_RELEASE)/build
	touch $@

linux-build: \
	$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/$(LINUX_IMAGE) \
	$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(LINUX_DEVICE_TREE).dtb

linux-build-dt: $(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(LINUX_DEVICE_TREE).dtb

$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/dts/xilinx/$(LINUX_DEVICE_TREE).dtb: $(LINUX_CONFIG_STAMP)
	# Note that the device tree recipe in the kernel source uses the pattern vendor/board.dtb
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) xilinx/$(LINUX_DEVICE_TREE).dtb

$(LINUX_BUILD_DIR)/arch/$(ARCH)/boot/$(LINUX_IMAGE): $(LINUX_CONFIG_STAMP)
	# Kernel itself
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) $(LINUX_IMAGE)
	# Kernel modules
	$(MAKE) -C $(LINUX_SRC_DIR) -j$(NPROC) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) modules
	# LSP support file
	$(LINUX_SRC_DIR)/scripts/clang-tools/gen_compile_commands.py \
		-d $(LINUX_BUILD_DIR) \
		-o $(LINUX_SRC_DIR)/compile_commands.json

linux-defconfig: $(LINUX_CONFIG_STAMP)

$(LINUX_CONFIG_STAMP): $(LINUX_SRC_BRANCHED_STAMP)
	$(MAKE) -C $(LINUX_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) mrproper
	$(MAKE) -C $(LINUX_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) $(LINUX_DEFCONFIG)
	touch $@

# Optional menuconfig step (have to run defconfig first)
linux-menuconfig: $(LINUX_CONFIG_STAMP)
	$(MAKE) -C $(LINUX_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		O=$(LINUX_BUILD_DIR) menuconfig
	touch $(LINUX_CONFIG_STAMP)

linux-fetch: $(LINUX_SRC_BRANCHED_STAMP)

$(LINUX_SRC_BRANCHED_STAMP): $(LINUX_SRC_CLONED_STAMP)
	cd $(LINUX_SRC_DIR) && git checkout -b $(LINUX_DEV_BRANCH)
	touch $@

$(LINUX_SRC_CLONED_STAMP):
	mkdir -pv $(EXTERN_DIR)
	git clone $(GIT_FLAGS) --branch $(LINUX_SRC_TAG) $(LINUX_SRC_URL) $(LINUX_SRC_DIR)
	touch $@

linux-help:
	@$(PRINTF) '%s\n' "Linux kernel targets:"
	@$(call print_help_entry,"linux-rebuild","Forces a rebuild after an initial build")
	@$(call print_help_entry,"linux-release","Runs the kernelrelease target")
	@$(call print_help_entry,"linux-stage","Stages the kernel and modules before creating rootfs")
	@$(call print_help_entry,"linux-build","Builds kernel, modules, and device tree")
	@$(call print_help_entry,"linux-build-dt","Builds kernel device tree only")
	@$(call print_help_entry,"linux-defconfig","Runs the kernel defconfig with default config")
	@$(call print_help_entry,"linux-menuconfig","Runs the kernel menuconfig")
	@$(call print_help_entry,"linux-fetch","Clones and branches kernel sources")
	@$(call print_help_entry,"linux-clean","Removes kernel build artifacts")
	@$(call print_help_entry,"linux-distclean","Removes all kernel components")

linux-clean:
	rm -rf $(LINUX_BUILD_DIR)
	rm -f $(STAGING_DIR)/$(LINUX_IMAGE)
	rm -f $(STAGING_DIR)/$(LINUX_DEVICE_TREE).dtb
	rm -f $(LINUX_STAGED_STAMP)
	rm -rf $(ROOTFS_DIR)/lib/modules/$(LINUX_RELEASE)
	@$(PRINTF) '%s\n' "NOTE: Kernel headers may be left behind in $(ROOTFS_DIR)/usr/include"

linux-distclean: linux-clean
	rm -rf $(LINUX_SRC_DIR)

