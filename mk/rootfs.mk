ROOTFS_PACKAGES		:= $(shell cat $(REPO_DIR)/cfg/rootfs-packages.txt | tr '\n' ',')
ROOTFS_TAR		:= $(STAGING_DIR)/rootfs.tar

.PHONY: rootfs-bootstrap rootfs-image rootfs-help

rootfs-bootstrap: $(ROOTFS_DONE_STAMP)

$(ROOTFS_DONE_STAMP): $(LINUX_STAGED_STAMP)
	# Build our rootfs as a tarball first to get around some permissions problems
	$(DEBSTRAP) \
		--aptopt='Acquire::http { Proxy "http://localhost:3142"; }' \
		--logfile=$(REPO_DIR)/rootfs-build.log \
		--verbose \
		--arch=armhf trixie \
		--include=$(ROOTFS_PACKAGES) \
		--hook-dir=$(REPO_DIR)/rootfs-hooks \
		--customize-hook='mkdir -p "$$1/lib/modules" && cp -a $(LINUX_STAGE_DIR)/lib/modules/. "$$1/lib/modules/"' \
		--customize-hook='mkdir -p "$$1/usr/include" && cp -a $(LINUX_STAGE_DIR)/usr/include/. "$$1/usr/include/"' \
		$(ROOTFS_TAR)
	touch $@

rootfs-image: $(LINUX_STAGED_STAMP) $(ROOTFS_DONE_STAMP) $(STAGING_DIR)/BOOT.BIN
	mkdir -pv $(STAGING_DIR)/extlinux
	cp $(REPO_DIR)/cfg/extlinux.conf $(STAGING_DIR)/extlinux/extlinux.conf
	# Pass environment variables to the build-rootfs script (it relies on those being set)
	ROOTFS_DIR=$(ROOTFS_DIR) BUILD_DIR=$(BUILD_DIR) \
		STAGING_DIR=$(STAGING_DIR) REPO_DIR=$(REPO_DIR) \
		PATH=$(PATH):/sbin:/usr/sbin \
		$(SCRIPTS_DIR)/build-rootfs

rootfs-help:
	@$(PRINTF) '%s\n' "Rootfs targets:"
	@$(call print_help_entry,"rootfs-bootstrap","Builds a rootfs tarball via mmdebstrap")
	@$(call print_help_entry,"rootfs-image","Builds a bootable image file suitable for writing to SD")

rootfs-clean:
	rm -f $(ROOTFS_TAR)
	rm -f $(ROOTFS_DONE_STAMP)
	rm -f rootfs-build.log
