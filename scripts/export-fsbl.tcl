proc log_err {msg} {
    puts "Error: ${msg}"
}

proc log_info {msg} {
    puts "Info: ${msg}"
}

# Identify the processor we are targeting so that we can generate the
# appropriate FSBL source, BSP components, device tree, and PMU firmware (if
# applicable).
proc get_proc_name {proc_num} {
    if {[hsi::current_hw_design -quiet] == ""} {
        error "No hardware design currently open"
        return 1
    }
    set procs [hsi::get_cells -hierarchical -filter { IP_TYPE == "PROCESSOR" }]
    set proc_name [lindex ${procs} ${proc_num}]

    return ${proc_name}
}

# Generates the FSBL source code for a Zynq-7000 or a ZynqMP hardware design
proc generate_fsbl {xsa_file hw_dir fsbl_dir} {
    # Export the hardware design if it hasn't been done yet (the no_overwrite
    # option is not supported on some older versions of Vivado / XSCT)
    set hw_design [hsi::open_hw_design -outdir "${hw_dir}" -no_overwrite "${xsa_file}"]
    # This returns nothing if it fails and a hardware aobject if it succeeds
    if {${hw_design} eq ""} {
        log_err "Failed to open hardware design from ${xsa_file}"
        exit 1
    }
    set proc_name [get_proc_name 0]

    log_info "Generating FSBL source for ${proc_name} at ${fsbl_dir}"
    switch ${proc_name} {
        "ps7_cortexa9_0" {
            hsi::generate_app -hw ${hw_design} -os standalone \
                -proc ${proc_name} -app zynq_fsbl -dir ${fsbl_dir}
        }

        "psu_cortexa53_0" {
            hsi::generate_app -hw ${hw_design} -os standalone \
                -proc ${proc_name} -app zynqmp_fsbl -dir ${fsbl_dir}
        }

        default {
            log_err "Unsupported processor ${proc_name}."
            return 1
        }
    }
    hsi::close_hw_design ${hw_design}
    # Infer success or failure based on whether we found a Makefile or not
    return [file exists "${fsbl_dir}/Makefile"]
}
