UBOOT_SRC_DIR			:= $(EXTERN_DIR)/u-boot
# Source tree wsa cloned to extern/
UBOOT_SRC_CLONED_STAMP		:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_cloned
# Source tree was branched for hacking
UBOOT_SRC_BRANCHED_STAMP	:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_branched
# Configuration was changed
UBOOT_SRC_CONFIG_STAMP		:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_config
# We perform out of tree builds for u-boot
UBOOT_BUILD_DIR			:= $(BUILD_DIR)/u-boot
UBOOT_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_uboot_elf_staged

.PHONY: uboot-stage uboot-build uboot-defconfig uboot-menuconfig uboot-fetch uboot-help uboot-clean uboot-distclean

uboot-stage: $(UBOOT_STAGED_STAMP)

$(UBOOT_STAGED_STAMP): $(UBOOT_BUILD_DIR)/$(UBOOT_ELF)
	install -D -m 644 $< $(STAGING_DIR)/$(UBOOT_ELF)
	install -D -m 644 \
		$(UBOOT_BUILD_DIR)/arch/$(ARCH)/dts/$(UBOOT_DEVICE_TREE).dtb \
		$(STAGING_DIR)/$(UBOOT_DEVICE_TREE).dtb
	touch $@

uboot-build: $(UBOOT_BUILD_DIR)/$(UBOOT_ELF)

$(UBOOT_BUILD_DIR)/$(UBOOT_ELF): $(UBOOT_SRC_CONFIG_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) DEVICE_TREE=$(UBOOT_DEVICE_TREE)

uboot-defconfig: $(UBOOT_SRC_CONFIG_STAMP)

$(UBOOT_SRC_CONFIG_STAMP): $(UBOOT_SRC_BRANCHED_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) $(UBOOT_DEFCONFIG)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) compile_commands.json
	ln -sf $(UBOOT_BUILD_DIR)/compile_commands.json $(UBOOT_SRC_DIR)/compile_commands.json
	touch $(UBOOT_SRC_CONFIG_STAMP)

# Optional menuconfig step (have to run defconfig first)
uboot-menuconfig: $(UBOOT_SRC_CONFIG_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR)
	touch $(UBOOT_SRC_CONFIG_STAMP)

uboot-fetch: $(UBOOT_SRC_BRANCHED_STAMP)

$(UBOOT_SRC_BRANCHED_STAMP): $(UBOOT_SRC_CLONED_STAMP)
	cd $(UBOOT_SRC_DIR) && git checkout -b $(UBOOT_DEV_BRANCH)
	touch $@

$(UBOOT_SRC_CLONED_STAMP):
	mkdir -pv $(EXTERN_DIR)
	git clone $(GIT_FLAGS) --branch $(UBOOT_SRC_TAG) $(UBOOT_SRC_URL) $(UBOOT_SRC_DIR)
	touch $@

uboot-help:
	@$(PRINTF) '%s\n' "U-Boot targets:"
	@$(call print_help_entry,"uboot-stage","Stage U-Boot ELF for bootgen")
	@$(call print_help_entry,"uboot-build","Builds U-Boot and device tree from default config")
	@$(call print_help_entry,"uboot-menuconfig","Runs the U-Boot menuconfig")
	@$(call print_help_entry,"uboot-fetch","Clones and branches U-Boot sources")
	@$(call print_help_entry,"uboot-clean","Removes U-Boot build artifacts")
	@$(call print_help_entry,"uboot-distclean","Removes all U-Boot components")

uboot-clean:
	rm -rf $(UBOOT_BUILD_DIR)
	rm -f $(STAGING_DIR)/$(UBOOT_ELF)
	rm -f $(STAGING_DIR)/$(UBOOT_DEVICE_TREE).dtb
	rm -f $(UBOOT_STAGED_STAMP)
	rm -f $(UBOOT_SRC_DIR)/compile_commands.json

uboot-distclean: uboot-clean
	rm -rf $(UBOOT_SRC_DIR)

