include mk/busybox.mk

INITRAMFS_DIR		:= $(PWD)/initramfs
INITRAMFS_IMAGE		:= $(PWD)/initramfs.cpio.gz

# This needs to be lazily evaluated since the kernel release string
# doesnt necessarily exist at parsing time
INITRAMFS_MODULES_DEP	= $(INITRAMFS_DIR)/lib/modules/$(KERNEL_RELEASE_STR)/modules.dep
# This file always gets installed as part of `make headers_install` so
# we use it as a sentinel file
INITRAMFS_HEADERS_DEP	= $(INITRAMFS_DIR)/usr/include/linux/version.h

.PHONY: initramfs initramfs-refresh initramfs-clean

initramfs: $(INITRAMFS_IMAGE)

# Once files and symlinks are made, we add an extra few directories and
# then archive it all up
$(INITRAMFS_IMAGE): busybox-install $(INITRAMFS_MODULES_DEP) $(INITRAMFS_HEADERS_DEP)
	$(FAKEROOT) sh -c 'cd $(INITRAMFS_DIR) && find . | cpio -o -H newc | gzip -n > $@'

# Copy kernel modules from the staging directory to the initramfs
$(INITRAMFS_MODULES_DEP): $(KERNEL_STAMP_INSTALL)
	$(MKDIR) -p $(INITRAMFS_DIR)/lib/modules
	$(CP) -av $(STAGING_DIR)/lib/modules/$(KERNEL_RELEASE_STR) $(INITRAMFS_DIR)/lib/modules/
	# Adjust the symlink to the source tree to point to the headers
	$(RM) -fv $(INITRAMFS_DIR)/lib/modules/$(KERNEL_RELEASE_STR)/build
	$(LN) -sfv /usr/include $(INITRAMFS_DIR)/lib/modules/$(KERNEL_RELEASE_STR)/build

$(INITRAMFS_HEADERS_DEP): $(KERNEL_STAMP_INSTALL)
	$(MKDIR) -p $(INITRAMFS_DIR)/usr
	$(CP) -av $(STAGING_DIR)/usr/include $(INITRAMFS_DIR)/usr/

# Recreates the archive from whatever is in the initramfs directory
# (requires that its been run before or has the necessary input products
# to have been run before)
initramfs-refresh:
	$(RM) -fv $(INITRAMFS_IMAGE)
	# Just archive the entire contents - whatever is in there goes!
	$(FAKEROOT) sh -c 'cd $(INITRAMFS_DIR) && find . | cpio -o -H newc | gzip -n > $(INITRAMFS_IMAGE)'

initramfs-clean:
	$(GIT) clean -dfx $(INITRAMFS_DIR)
	$(RM) -f $(INITRAMFS_IMAGE)
