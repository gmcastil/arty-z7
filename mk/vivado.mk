# This can be overridden at run time to select a different Arty preset file (output will
# still go to the VIVADO_PROJ_DIR directory)
VIVADO_PROJ_NAME	:= arty-z7-base
VIVADO_PROJ_DIR		:= $(BUILD_DIR)/vivado
VIVADO_TCLARGS		:= $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(NPROC)
VIVADO_SOURCE_TCL	:= $(SCRIPTS_DIR)/build-vivado-proj.tcl
VIVADO_PRESETS		:= $(REPO_DIR)/presets/$(VIVADO_PROJ_NAME).tcl

.PHONY: vivado-help vivado-build vivado-clean

vivado-build: $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xsa

$(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xsa: $(VIVADO_SOURCE_TCL) $(VIVADO_PRESETS)
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
	@$(call print_help_entry,"vivado-build","Build Vivado project (overwrites existing)")
	@$(call print_help_entry,"vivado-clean","Removes Vivado build directory")

vivado-clean:
	rm -rf $(VIVADO_PROJ_DIR)
