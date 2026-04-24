proc log_err {msg} {
    puts "Error: ${msg}"
}

proc usage {} {
    puts "Usage: vivado -mode back -source build-arty-z7-base.tcl -tclargs <proj_name> <proj_dir> <jobs>"
    return 0
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

# Need to find the presets file
set scripts_dir [file dirname [file normalize [info script]]]
set repo_dir [file dirname "${scripts_dir}"]
# PS7 configuration presets
set preset_file [file join "${repo_dir}" "presets" "arty-z7-base.tcl"]

# Exported hardware location
set xsa_file [file join "${proj_dir}" "${proj_name}.xsa"]
# Block design name
set bd_design "design_1"

# Create the project on disk
if {[catch {create_project -part "${part}" -force -verbose "${proj_name}" "${proj_dir}"} err]} {
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
if {[catch {create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0} err]} {
    log_err "Could not instantiate processing subsystem: ${err}"
    exit 1
}

# Maybe just make these external interfaces
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" } [get_bd_cells processing_system7_0]

# Now apply the PS7 presets
source "${preset_file}"
set ps7 [get_bd_cells processing_system7_0]
set_property -dict [apply_preset "${ps7}"] "${ps7}"

# Create the VHDL wrapper and add it to the project
set wrapper_file [make_wrapper -files [get_files "${bd_design}.bd"] -top]
add_files -norecurse "${wrapper_file}"

# Synthesis
launch_runs synth_1 -jobs "${nproc}"
wait_on_runs synth_1

# Implementation
launch_runs impl_1 -jobs "${nproc}"
wait_on_runs impl_1

# Bitstream
launch_runs impl_1 -to_step write_bitstream -jobs "${nproc}"
wait_on_runs impl_1

# Export hardware platform including bitstream
write_hw_platform -fixed -include_bit -force -file "${xsa_file}"
#
# make_wrapper -files [get_files /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/design_1.bd] -top
#
# remove_files  /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/ip/processing_system7_0/processing_system7_0.xci
# file delete -force /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/ip/processing_system7_0
# file delete -force /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/ip/processing_system7_0
# make_wrapper -files [get_files /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/design_1.bd] -top
# WARNING: [BD 5-700] No address spaces matched 'get_bd_addr_spaces -of_objects /processing_system7_0 -filter {path == /processing_system7_0/Data}'
# WARNING: [BD 5-699] No address segments matched 'get_bd_addr_segs -of_objects {}'
# Wrote  : </storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/design_1.bd>
# Wrote  : </storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/ui/bd_1f5defd0.ui>
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/sim/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# make_wrapper: Time (s): cpu = 00:00:03 ; elapsed = 00:00:15 . Memory (MB): peak = 8400.215 ; gain = 0.000 ; free physical = 19498 ; free virtual = 22196
# add_files -norecurse /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# launch_runs synth_1 -jobs 2
# INFO: [BD 41-1662] The design 'design_1.bd' is already validated. Therefore parameter propagation will not be re-run.
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/sim/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# INFO: [BD 41-1029] Generation completed for the IP Integrator block processing_system7_0 .
# Exporting to file /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh
# Generated Hardware Definition File /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.hwdef
# WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
# [Thu Apr 23 15:40:57 2026] Launched design_1_processing_system7_0_0_synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/design_1_processing_system7_0_0_synth_1/runme.log
# [Thu Apr 23 15:40:57 2026] Launched synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/synth_1/runme.log
# launch_runs: Time (s): cpu = 00:00:22 ; elapsed = 00:00:25 . Memory (MB): peak = 8463.148 ; gain = 61.043 ; free physical = 19294 ; free virtual = 22019
# reset_run synth_1
# launch_runs synth_1 -jobs 2
# WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
# [Thu Apr 23 15:45:33 2026] Launched synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/synth_1/runme.log
# launch_runs impl_1 -jobs 2
# [Thu Apr 23 15:48:25 2026] Launched impl_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/impl_1/runme.log
# launch_runs impl_1 -to_step write_bitstream -jobs 2
# [Thu Apr 23 15:51:53 2026] Launched impl_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/impl_1/runme.log
# write_hw_platform -fixed -include_bit -force -file /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa
# INFO: [Project 1-1918] Creating Hardware Platform: /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa ...
# INFO: [Project 1-1943] The Hardware Platform can be used for Hardware
# INFO: [Project 1-1941] Successfully created Hardware Platform: /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa
# INFO: [Hsi 55-2053] elapsed time for repository (/tools/Xilinx/Vivado/2024.2/data/embeddedsw) loading 5 seconds
# write_hw_platform: Time (s): cpu = 00:00:03 ; elapsed = 00:00:08 . Memory (MB): peak = 8720.887 ; gain = 122.648 ; free physical = 19005 ; free virtual = 21832
