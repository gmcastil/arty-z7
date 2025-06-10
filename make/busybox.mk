BUSYBOX_SRC_URL		:= https://github.com/mirror/busybox.git
BUSYBOX_SRC_TAG		:= 1_36_1
BUSYBOX_SRC_DIR		:= $(EXTERN_DIR)/busybox

BUSYBOX_CONFIG		?= $(CONFIG_DIR)/basic-busybox-static.config

BUSYBOX_BUILD_DIR	:= $(BUILD_DIR)/busybox
BUSYBOX_BIN		:= $(BUSYBOX_BUILD_DIR)/busybox

BUSYBOX_STAMP_INSTALL	:= $(BUSYBOX_BUILD_DIR)/.stamp-busybox-install

.PHONY: busybox busybox-install busybox-clean

# This target installs the busybox binary and all applets where the
# initramfs expects them to be. This should only be called by the
# initramfs build process.
busybox-install: $(BUSYBOX_STAMP_INSTALL)

$(BUSYBOX_STAMP_INSTALL): $(BUSYBOX_BIN) $(INITRAMFS_DIR)
	$(MAKE) -C $(BUSYBOX_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUSYBOX_BUILD_DIR) CONFIG_PREFIX=$(INITRAMFS_DIR) install

busybox: $(BUSYBOX_BIN)
	@$(PRINTF) "Info: Busybox build complete" >&1

$(BUSYBOX_BIN): $(BUSYBOX_BUILD_DIR)/.config
	$(MAKE) -C $(BUSYBOX_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUSYBOX_BUILD_DIR)

$(BUSYBOX_BUILD_DIR)/.config: $(BUSYBOX_SRC_DIR)/Makefile
	@mkdir -p $(@D)
	# Clean everything out, including old .config
	$(MAKE) -C $(BUSYBOX_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUSYBOX_BUILD_DIR) mrproper
	# Copy in the saved .config (can be overridden with path to BUSYBOX_CONFIG)
	$(INSTALL) -m 664 $(BUSYBOX_CONFIG) $(BUSYBOX_BUILD_DIR)/.config
	# Update config if sources changed
	$(YES) "" |  $(MAKE) -C $(BUSYBOX_SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUSYBOX_BUILD_DIR) oldconfig

$(BUSYBOX_SRC_DIR)/Makefile: $(EXTERN_DIR)
	$(GIT) clone $(GIT_FLAGS) --branch $(BUSYBOX_SRC_TAG) $(BUSYBOX_SRC_URL) $(BUSYBOX_SRC_DIR)

busybox-clean:
	rm -rf $(BUSYBOX_BUILD_DIR)


