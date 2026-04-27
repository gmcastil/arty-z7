# Vivado stamps
VIVADO_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_vivado_staged

# FSBL stamps
FSBL_SRC_GENERATE_STAMP		:= $(FSBL_SRC_GENERATE_DIR)/.stamp_fsbl_src_generated
FSBL_SRC_COPIED_STAMP		:= $(FSBL_SRC_DIR)/.stamp_fsbl_src_copied
FSBL_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_fsbl_elf_staged

# U-Boot stamps
UBOOT_SRC_CLONED_STAMP		:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_cloned
UBOOT_SRC_BRANCHED_STAMP	:= $(UBOOT_SRC_DIR)/.stamp_uboot_src_branched
UBOOT_CONFIG_STAMP		:= $(UBOOT_BUILD_DIR)/.stamp_uboot_src_config
UBOOT_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_uboot_elf_staged

# Linux stamps
LINUX_SRC_CLONED_STAMP		:= $(LINUX_SRC_DIR)/.stamp_linux_src_cloned
LINUX_SRC_BRANCHED_STAMP	:= $(LINUX_SRC_DIR)/.stamp_linux_src_branched
LINUX_CONFIG_STAMP		:= $(LINUX_BUILD_DIR)/.stamp_linux_src_config
LINUX_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_linux_staged

# Rootfs stamps
ROOTFS_STAMP_DONE		:= $(ROOTFS_DIR)/.stamp_rootfs_done