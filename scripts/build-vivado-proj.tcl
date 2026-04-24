proc log_err {msg} {
    puts "Error: ${msg}"
}

proc usage {} {
    puts "Usage: vivado -mode back -source build-vivado-proj.tcl -tclargs <proj_name> <proj_dir> <jobs>"
}

if {[llength $argv] != 3} {
    usage
    exit 1
}

# From tclargs
set proj_name [lindex $argv 0]
set proj_dir [lindex $argv 1]
set nproc [lindex $argv 2]

set part "xc7z020clg400-1"

# Find the presets file relative to where this script was stored (assumes that there is an adjacent
# 'presets' directory containing the presets saved from the Vivado IP configuration tool)
set scripts_dir [file dirname [file normalize [info script]]]
set repo_dir [file dirname "${scripts_dir}"]
set preset_file [file join "${repo_dir}" "presets" "${proj_name}.tcl"]

# Exported hardware location
set xsa_file [file join "${proj_dir}" "${proj_name}.xsa"]
# Block design name
set bd_design "design_1"

# Create the project on disk
if {[catch {create_project -part "${part}" -force "${proj_name}" "${proj_dir}"} err]} {
    log_err "Could not create project: ${err}"
    exit 1
}

# Use VHDL instead of Verilog
set_property target_language VHDL [current_project]

# And suppress some critical warnings related to memory timings that are harmless
set_msg_config -id {PSU-1} -suppress
set_msg_config -id {PSU-2} -suppress

# Create empty block design
if {[catch {create_bd_design "${bd_design}"} err]} {
    log_err "Could not create block design: ${err}"
    exit 1
}

# Instantiate the Zynq PS subsystem in the block design
set ps7_name "processing_system7_0"
set ps7_ip "xilinx.com:ip:processing_system7:5.5"
if {[catch {create_bd_cell -type ip -vlnv "${ps7_ip}" "${ps7_name}"} err]} {
    log_err "Could not instantiate processing subsystem: ${err}"
    exit 1
}

# Make the FIXED_IO and DDR interface ports external
make_bd_intf_pins_external [get_bd_intf_pins "${ps7_name}/FIXED_IO"]
make_bd_intf_pins_external [get_bd_intf_pins "${ps7_name}/DDR"]

# Now apply the PS7 presets - this is the Tcl file that is created by the Vivado
# IP configuration wizard when saving the IP configuration to a file.
source "${preset_file}"
# The apply_preset proc takes an input argument but never uses it and just returns
# the preset values as a dict
set_property -dict [apply_preset {}] [get_bd_cells "${ps7_name}"]

# Create the VHDL wrapper and add it to the project
set wrapper_file [make_wrapper -files [get_files "${bd_design}.bd"] -top]
add_files -norecurse "${wrapper_file}"

# Synthesis
launch_runs synth_1 -jobs "${nproc}"
wait_on_runs synth_1

# Implementation and bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs "${nproc}"
wait_on_runs impl_1

# Export hardware platform including bitstream
write_hw_platform -fixed -include_bit -force -file "${xsa_file}"
