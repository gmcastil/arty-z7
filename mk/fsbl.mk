# We generate the source tree using XSCT to here
FSBL_SRC_GENERATE_DIR		:= $(EXTERN_DIR)/zynq_fsbl
FSBL_SRC_GENERATE_TCL		:= $(SCRIPTS_DIR)/export-fsbl.tcl
FSBL_SRC_GENERATE_STAMP		:= $(FSBL_SRC_GENERATE_DIR)/.stamp_fsbl_src_generated
# And then we copy it from the generated directory to the build directory since
# the FSBL source does not support out-of-tree builds
FSBL_SRC_DIR			:= $(BUILD_DIR)/zynq_fsbl
FSBL_HW_EXPORT_DIR		:= $(BUILD_DIR)/hw_export
FSBL_SRC_COPIED_STAMP		:= $(FSBL_SRC_DIR)/.stamp_fsbl_src_copied
FSBL_ELF_STAGED_STAMP		:= $(STAGING_DIR)/.stamp_fsbl_elf_staged

.PHONY: fsbl-stage fsbl-build fsbl-generate fsbl-help fsbl-clean fsbl-distclean

fsbl-stage: $(FSBL_ELF_STAGED_STAMP)

$(FSBL_ELF_STAGED_STAMP): $(FSBL_SRC_DIR)/$(FSBL_ELF)
	install -D -m 644 $< $(STAGING_DIR)/$(FSBL_ELF)
	touch $@

fsbl-build: $(FSBL_SRC_DIR)/$(FSBL_ELF)

$(FSBL_SRC_DIR)/$(FSBL_ELF): $(FSBL_SRC_COPIED_STAMP)
	$(MAKE) -C $(FSBL_SRC_DIR) clean
	$(MAKE) -C $(FSBL_SRC_DIR) -j1 CFLAGS=$(FSBL_CFLAGS) EXEC=$(FSBL_ELF)

$(FSBL_SRC_COPIED_STAMP): $(FSBL_SRC_GENERATE_STAMP)
	rsync -azrP $(FSBL_SRC_GENERATE_DIR) $(BUILD_DIR)
	touch $@

fsbl-generate: $(FSBL_SRC_GENERATE_STAMP)

$(FSBL_SRC_GENERATE_STAMP): $(FSBL_SRC_GENERATE_TCL) $(VIVADO_XSA)
	mkdir -pv $(BUILD_DIR)
	mkdir -pv $(EXTERN_DIR)
	$(XSCT) -eval "source $(FSBL_SRC_GENERATE_TCL); \
		generate_fsbl {$(VIVADO_XSA)} {$(FSBL_HW_EXPORT_DIR)} {$(FSBL_SRC_GENERATE_DIR)}"
	touch $@

fsbl-help:
	@$(PRINTF) '%s\n' "FSBL targets:"
	@$(call print_help_entry,"fsbl-stage","Stage FSBL ELF for bootgen")
	@$(call print_help_entry,"fsbl-build","Build FSBL ELF")
	@$(call print_help_entry,"fsbl-generate","Exports FSBL source from a given XSA file")
	@$(call print_help_entry,"fsbl-clean","Removes FSBL build artifacts")
	@$(call print_help_entry,"fsbl-distclean","Removes FSBL source directory")

fsbl-clean:
	rm -rf $(FSBL_SRC_DIR)
	rm -rf $(FSBL_HW_EXPORT_DIR)
	rm -f $(FSBL_ELF_STAGED_STAMP)
	rm -f $(STAGING_DIR)/$(FSBL_ELF)

fsbl-distclean: fsbl-clean
	rm -rf $(FSBL_SRC_GENERATE_DIR)


