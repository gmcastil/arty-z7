.PHONY: rootfs-bootstrap rootfs-image

rootfs-bootstrap: $(ROOTFS_STAMP_DONE)

$(ROOTFS_STAMP_DONE): $(LINUX_STAGED_STAMP)
	# Build our rootfs as a tarball first to get around some permissions problems
	$(DEBSTRAP) \
		--arch=armhf trixie \
		--include=openssh-server \
		--include=build-essential \
		--include=python3 \
		--include=vim \
		--customize-hook='mkdir -p $$1/lib/modules && cp -r $(LINUX_STAGE_DIR)/lib/modules/$(LINUX_RELEASE)-* $$1/lib/modules/' \
		--customize-hook='mkdir -p $$1/boot/extlinux && cp $(REPO_DIR)/cfg/extlinux.conf $$1/boot/extlinux/' \
		--customize-hook='cp -rT $(LINUX_STAGE_DIR)/usr/include $$1/usr/include' \
		$(ROOTFS_DIR).tar
	touch $@

rootfs-image: $(LINUX_STAGED_STAMP) $(ROOTFS_STAMP_DONE) $(STAGING_DIR)/BOOT.BIN
	mkdir -pv $(STAGING_DIR)/extlinux
	cp $(REPO_DIR)/cfg/extlinux.conf $(STAGING_DIR)/extlinux/extlinux.conf
	# Pass environment variables to the build-rootfs script (it relies on those being set)
	ROOTFS_DIR=$(ROOTFS_DIR) BUILD_DIR=$(BUILD_DIR) \
		STAGING_DIR=$(STAGING_DIR) REPO_DIR=$(REPO_DIR) \
		PATH=$(PATH):/sbin:/usr/sbin \
		$(SCRIPTS_DIR)/build-rootfs

rootfs-clean:
	rm -rf $(ROOTFS_DIR)
