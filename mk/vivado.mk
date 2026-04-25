# This can be overridden at run time to select a different Arty preset file (output will
# still go to the VIVADO_PROJ_DIR directory)
VIVADO_PROJ_NAME	:= arty-z7-base
VIVADO_PROJ_DIR		:= $(BUILD_DIR)/vivado
VIVADO_TCLARGS		:= $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(NPROC)
VIVADO_SOURCE_TCL	:= $(SCRIPTS_DIR)/build-vivado-proj.tcl
VIVADO_PRESETS		:= $(REPO_DIR)/presets/$(VIVADO_PROJ_NAME).tcl
VIVADO_XSA		:= $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xsa

.PHONY: vivado-help vivado-build vivado-clean

vivado-stage: $(VIVADO_STAGED_STAMP)

$(VIVADO_STAGED_STAMP): $(VIVADO_XSA)
	unzip $(VIVADO_XSA) $(HW_EXPORT_DIR)

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
