boot-stage: $(STAGING_DIR)/BOOT.BIN

$(STAGING_DIR)/BOOT.BIN: $(STAGING_DIR)/$(BOOT_BIF) $(FSBL_STAGED_STAMP) $(UBOOT_STAGED_STAMP) $(VIVADO_STAGED_STAMP)
	cd $(STAGING_DIR) && $(BOOTGEN) -image $(BOOT_BIF) -arch $(PLATFORM) -o BOOT.BIN -log trace
	cd $(STAGING_DIR) && md5sum system.bit fsbl.elf u-boot.elf u-boot.dtb > BOOT.MD5

$(STAGING_DIR)/$(BOOT_BIF): $(BIF_DIR)/$(BOOT_BIF)
	install -D -m 644 $< $(STAGING_DIR)

boot-help:
	@$(PRINTF) '%s\n' "Boot targets:"
	@$(call print_help_entry,"boot-stage","Creates a BOOT.BIN in the staging directory with MD5 checksums")
	@$(call print_help_entry,"boot-clean","Removes current BOOT.BIN and MD5 checksums from the staging directory")

boot-clean:
	rm -f $(STAGING_DIR)/$(BOOT_BIF)
	rm -f $(STAGING_DIR)/BOOT.BIN
	rm -f $(STAGING_DIR)/BOOT.MD5
	rm -f $(STAGING_DIR)/bootgen_log.txt
