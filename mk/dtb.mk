DTB_SRC_DIR		:= $(PWD)/dts

DTB_BUILD_DIR		:= $(BUILD_DIR)/dtb

.PHONY: dtb-qemu dtb-arty-z720 dtb-clean

dtb-qemu: $(DTB_BUILD_DIR)/system-qemu.dtb
dtb-arty-z720: $(DTB_BUILD_DIR)/system-arty-z720.dtb

$(DTB_BUILD_DIR)/system-qemu.dtb: $(DTB_BUILD_DIR)/qemu.pp.dts
	$(DTC) -I dts -O dtb -o $@ $<

$(DTB_BUILD_DIR)/qemu.pp.dts: $(DTB_SRC_DIR)/qemu/qemu.dts $(DTB_SRC_DIR)/include/zynq-7000.dtsi
	$(MKDIR) -p $(DTB_BUILD_DIR)
	$(CPP) -nostdinc -P -I $(DTB_SRC_DIR)/include -undef -x assembler-with-cpp $< -o $@

dtb-clean:
	$(RM) -rf $(DTB_BUILD_DIR)
