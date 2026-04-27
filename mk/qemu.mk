.PHONY: qemu-uboot qemu-help

qemu-uboot: $(UBOOT_STAGED_STAMP)
	$(QEMU) \
		-machine type=$(QEMU_MACHINE_TYPE) \
		-accel tcg \
		-dtb $(STAGING_DIR)/u-boot.dtb \
		-serial stdio \
		-serial null \
		-monitor telnet:127.0.0.1:55555,server,nowait \
		-kernel $(STAGING_DIR)/$(UBOOT_ELF) \
		-display none \
		-net nic -net user,hostfwd=udp::6666-:6666 \
		-m 2048M

qemu-help:
	@$(PRINTF) '%s\n' "QEMU targets:"
	@$(call print_help_entry,"qemu-uboot","Runs the U-Boot binary from the staging directory under QEMU")

