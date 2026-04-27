UBOOT_SRC_DIR			:= $(EXTERN_DIR)/u-boot
# We perform out of tree builds for u-boot
UBOOT_BUILD_DIR			:= $(BUILD_DIR)/u-boot
# Source tree wsa cloned to extern/
UBOOT_SRC_CLONED_STAMP		:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_cloned
# Source tree was branched for hacking
UBOOT_SRC_BRANCHED_STAMP	:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_branched
# Configuration was changed
UBOOT_CONFIG_STAMP		:= $(UBOOT_BUILD_DIR)/.stamp_uboot_src_config
UBOOT_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_uboot_elf_staged

.PHONY: uboot-rebuild uboot-stage uboot-build uboot-defconfig uboot-menuconfig
.PHONY: uboot-fetch uboot-help uboot-clean uboot-distclean

# Convenience target to rebuild after modifying U-boot source - forces a rebuild
# regardless of stamp states
uboot-rebuild:
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) DEVICE_TREE=$(UBOOT_DEVICE_TREE)
	$(UBOOT_SRC_DIR)/scripts/gen_compile_commands.py \
		-d $(UBOOT_BUILD_DIR) \
		-o $(UBOOT_SRC_DIR)/compile_commands.json

uboot-stage: $(UBOOT_STAGED_STAMP)

$(UBOOT_STAGED_STAMP): $(UBOOT_BUILD_DIR)/$(UBOOT_ELF)
	install -D -m 644 $< $(STAGING_DIR)/$(UBOOT_ELF)
	# Copy the device tree to the staging directory, but rename it so that the
	# .bif file can always reference it when building the BOOT.BIN
	install -D -m 644 \
		$(UBOOT_BUILD_DIR)/arch/$(ARCH)/dts/$(UBOOT_DEVICE_TREE).dtb \
		$(STAGING_DIR)/u-boot.dtb
	touch $@

uboot-build: $(UBOOT_BUILD_DIR)/$(UBOOT_ELF)

$(UBOOT_BUILD_DIR)/$(UBOOT_ELF): $(UBOOT_CONFIG_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) DEVICE_TREE=$(UBOOT_DEVICE_TREE)
	$(UBOOT_SRC_DIR)/scripts/gen_compile_commands.py \
		-d $(UBOOT_BUILD_DIR) \
		-o $(UBOOT_SRC_DIR)/compile_commands.json

uboot-defconfig: $(UBOOT_CONFIG_STAMP)

$(UBOOT_CONFIG_STAMP): $(UBOOT_SRC_BRANCHED_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR) $(UBOOT_DEFCONFIG)
	touch $(UBOOT_CONFIG_STAMP)

# Optional menuconfig step (have to run defconfig first)
uboot-menuconfig: $(UBOOT_CONFIG_STAMP)
	$(MAKE) -C $(UBOOT_SRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(UBOOT_BUILD_DIR)
	touch $(UBOOT_CONFIG_STAMP)

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
	@$(call print_help_entry,"uboot-rebuild","Forces a rebuild after an initial build")
	@$(call print_help_entry,"uboot-stage","Stage U-Boot ELF for bootgen")
	@$(call print_help_entry,"uboot-build","Builds U-Boot and device tree")
	@$(call print_help_entry,"uboot-defconfig","Runs the U-Boot defconfig with default config")
	@$(call print_help_entry,"uboot-menuconfig","Runs the U-Boot menuconfig")
	@$(call print_help_entry,"uboot-fetch","Clones and branches U-Boot sources")
	@$(call print_help_entry,"uboot-clean","Removes U-Boot build artifacts")
	@$(call print_help_entry,"uboot-distclean","Removes all U-Boot components")

uboot-clean:
	rm -rf $(UBOOT_BUILD_DIR)
	rm -f $(STAGING_DIR)/$(UBOOT_ELF)
	rm -f $(STAGING_DIR)/u-boot.dtb
	rm -f $(UBOOT_STAGED_STAMP)
	rm -f $(UBOOT_SRC_DIR)/compile_commands.json

uboot-distclean: uboot-clean
	rm -rf $(UBOOT_SRC_DIR)

