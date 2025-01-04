########### CONFIGS ############

set SIM_DIR "."
set RLT_DIR "rtl"
set VERIF_DIR "verif"
set PARAMS_FILE "params.txt"

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


proc get_params {file_path} {
    set params ""
    
    set file_id [open $file_path r]
    
    # Read the file line by line
    while {[gets $file_id line] >= 0} {
        # Prepend "-generic_top" to each line
        append params "-generic_top $line "
    }
    
    close $file_id
    
    return $params
}

######## CD TO SIM_DIR #########

##if {![file isdirectory $SIM_DIR]} {
##    # Directory does not exist, create it
##    file mkdir $SIM_DIR
##    puts "Directory created: $SIM_DIR"
##}

##cd $SIM_DIR
##puts "Changed to directory: $SIM_DIR"

########## GET FILES ###########

set rtl_files [get_files $RLT_DIR]
set verif_files [get_files $VERIF_DIR]
set all_files "$rtl_files $verif_files"

######### COMPILE RTL ##########

eval exec xvlog -log xvlog.log $all_files

########## ELABORATE ###########

set params [get_params $PARAMS_FILE]

eval exec xelab -log xelab.log $params -top tb_RISC_V_TEST -snapshot tb_and_snapshot -timescale 1ns/1ps

########## SIMULATE ############

exec xsim -log xsim.log -R tb_and_snapshot
