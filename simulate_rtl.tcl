########### CONFIGS ############

set RLT_DIR "rtl"
set VERIF_DIR "verif"
set TESTS_DIR "tests"

########### HELPERS ############

proc get_files {dir} {
    set filename "${dir}/filelist.f"
    
    set file_id [open $filename r]
    set filelist ""
    
    while {[gets $file_id line] >= 0} {
        append filelist "$dir/$line " 
    }

    close $file_id
    
    return $filelist
}

proc get_tests {tests_dir {pattern *} {types ""}} {
    # Construct the glob command options based on the inputs
    set options "-directory $tests_dir $pattern"
    if {$types ne ""} {
        append options " -types $types"
    }

    return [eval glob $options]
}

############ MAIN ##############

# Get design and testbench files
set rtl_files [get_files $RLT_DIR]
set verif_files [get_files $VERIF_DIR]
set all_files "$rtl_files $verif_files"

# Get tests
set tests [get_tests $TESTS_DIR "*" "d"]

foreach test $tests {
    set test_name [file tail $test]
    file mkdir "$VERIF_DIR/results/$test_name"
    # Overide params of top module
    set IMEM_FILE "$test/imem.mem"
    set DMEM_FILE "$test/dmem.mem"
    set VREG_LOG "$VERIF_DIR/results/$test_name/vreg.log"
    set XREG_LOG "$VERIF_DIR/results/$test_name/xreg.log"
    set DMEM_LOG "$VERIF_DIR/results/$test_name/dmem.log"
    set PC_LOG "$VERIF_DIR/results/$test_name/pc.log"
    set DATA_ADDR_WIDTH 12

    # Compile RTL
    eval exec xvlog -log xvlog.log $all_files

    # Elabrate
    eval exec xelab \
        -log xelab.log \
        -generic_top IMEM_FILE=$IMEM_FILE \
        -generic_top DMEM_FILE=$DMEM_FILE \
        -generic_top VREG_LOG=$VREG_LOG \
        -generic_top XREG_LOG=$XREG_LOG \
        -generic_top DMEM_LOG=$DMEM_LOG \
        -generic_top PC_LOG=$PC_LOG \
        -generic_top DATA_ADDR_WIDTH=$DATA_ADDR_WIDTH \
        -top tb_RISC_V_TEST \
        -snapshot tb_and_snapshot \
        -timescale 1ns/1ps
    
    # Simulate
    exec xsim -log xsim.log -R tb_and_snapshot
}

exit