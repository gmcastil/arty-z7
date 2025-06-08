include make/busybox.mk

INITRAMFS_DIR		:= $(PWD)/initramfs
INITRAMFS_IMAGE		:= $(PWD)/initramfs.cpio.gz

INITRAMFS_FILES		:= \
			   $(INITRAMFS_DIR)/init \
			   $(INITRAMFS_DIR)/bin/busybox

INITRAMFS_SYMLINKS	:= \
			   $(INITRAMFS_DIR)/bin/sh \
			   $(INITRAMFS_DIR)/bin/ls \
			   $(INITRAMFS_DIR)/bin/mount \
			   $(INITRAMFS_DIR)/bin/umount \
			   $(INITRAMFS_DIR)/bin/echo \
			   $(INITRAMFS_DIR)/bin/cat \
			   $(INITRAMFS_DIR)/bin/dmesg \
			   $(INITRAMFS_DIR)/bin/sleep \
			   $(INITRAMFS_DIR)/bin/reboot

INITRAMFS_MODULES_DEP	:= $(INITRAMFS_DIR)/lib/modules/$(KERNEL_RELEASE)/modules.dep

.PHONY: initramfs initramfs-clean

initramfs: $(INITRAMFS_IMAGE)

# Once files and symlinks are made, we add an extra few directories and
# then archive it all up
$(INITRAMFS_IMAGE): $(INITRAMFS_FILES) $(INITRAMFS_SYMLINKS) $(INITRAMFS_MODULES_DEP)
	$(MKDIR) -p $(INITRAMFS_DIR)/{dev,sys,proc}
	$(MKDIR) -p $(INITRAMFS_DIR)/{mnt,tmp,var}
	cd $(INITRAMFS_DIR) && find . | cpio -o -H newc | gzip -n > $@

# Symlink common commands (including /bin/sh) to busybox
$(INITRAMFS_DIR)/bin/%: $(INITRAMFS_DIR)/bin/busybox
	ln -sfv busybox $@

# Busybox gets built and statically linked on its own, so we just pluck it out here
$(INITRAMFS_DIR)/bin/busybox: $(BUSYBOX_BIN)
	$(MKDIR) -p $(@D)
	$(INSTALL) -m 700 $< $@

# Kernel is going to look for init in the root directory
$(INITRAMFS_DIR)/init: $(CONFIG_DIR)/initramfs.init
	$(INSTALL) -m 744 $< $@

# Copy kernel modules from the staging directory to the initramfs
$(INITRAMFS_MODULES_DEP): $(KERNEL_BUILD_DIR)/.stamp-kernel-install
	$(MKDIR) -p $(INITRAMFS_DIR)/lib/modules
	$(CP) -av $(STAGING_DIR)/lib/modules/$(KERNEL_RELEASE) $(INITRAMFS_DIR)/lib/modules/

initramfs-clean:
	$(RM) -rf $(INITRAMFS_DIR)
	$(RM) -f $(INITRAMFS_IMAGE)
