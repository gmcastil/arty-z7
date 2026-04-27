# This can be overridden at run time to select a different Arty preset file (output will
# still go to the VIVADO_PROJ_DIR directory)
VIVADO_PROJ_NAME	:= arty-z7-base
VIVADO_PROJ_DIR		:= $(BUILD_DIR)/vivado
VIVADO_TCLARGS		:= $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(NPROC)
VIVADO_SOURCE_TCL	:= $(SCRIPTS_DIR)/build-vivado-proj.tcl
VIVADO_PRESETS		:= $(REPO_DIR)/presets/$(VIVADO_PROJ_NAME).tcl
VIVADO_XSA		:= $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xsa
VIVADO_STAGED_STAMP	:= $(STAGING_DIR)/.stamp_vivado_staged

.PHONY: vivado-stage vivado-build vivado-help vivado-clean

vivado-stage: $(VIVADO_STAGED_STAMP)

$(VIVADO_STAGED_STAMP): $(VIVADO_XSA)
	mkdir -pv $(STAGING_DIR)
	# Extract whatever the bitstream is called in the XSA and name it system.bit so that
	# the .bif file is able to find it when its time to build the BOOT.BIN
	unzip -p $(VIVADO_XSA) $(VIVADO_PROJ_NAME).bit > $(STAGING_DIR)/system.bit
	unzip -j $(VIVADO_XSA) ps7_init_gpl.c -d $(STAGING_DIR)
	touch $@

vivado-build: $(VIVADO_XSA)

$(VIVADO_XSA): $(VIVADO_SOURCE_TCL) $(VIVADO_PRESETS)
	mkdir -pv $(VIVADO_PROJ_DIR)
	# Change to the project directory to avoid random Vivado droppings littering the repo
	cd $(VIVADO_PROJ_DIR) && $(VIVADO) -mode batch \
		-notrace \
		-log $(VIVADO_PROJ_DIR)/vivado.log \
		-journal $(VIVADO_PROJ_DIR)/vivado.jou \
		-source $(VIVADO_SOURCE_TCL) \
		-tclargs $(VIVADO_TCLARGS)

vivado-help:
	@$(PRINTF) '%s\n' "Vivado project targets:"
	@$(call print_help_entry,"vivado-stage","Stage bitstream and FSBL configuration source")
	@$(call print_help_entry,"vivado-build","Build Vivado project and overwrites if needed")
	@$(call print_help_entry,"vivado-clean","Removes Vivado build directory")

vivado-clean:
	rm -rf $(VIVADO_PROJ_DIR)
	rm -f $(VIVADO_STAGED_STAMP)
	rm -f $(STAGING_DIR)/system.bit
	rm -f $(STAGING_DIR)/ps7_init_gpl.c

