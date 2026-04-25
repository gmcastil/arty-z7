QEMU_MACHINE_TYPE=xilinx-zynq-a9

.PHONY: qemu-uboot

qemu-uboot: $(UBOOT_STAGED_STAMP)
	$(QEMU) \
		-machine type=$(QEMU_MACHINE_TYPE) \
		-accel tcg \
		-dtb $(STAGING_DIR)/$(UBOOT_DEVICE_TREE).dtb \
		-serial stdio \
		-serial null \
		-monitor telnet:127.0.0.1:55555,server,nowait \
		-kernel $(STAGING_DIR)/$(UBOOT_ELF) \
		-display none \
		-m 2048M


