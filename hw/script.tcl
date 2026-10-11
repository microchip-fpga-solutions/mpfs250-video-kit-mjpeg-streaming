#==============================================================================
# Main build script for MJPEG Video Streaming Reference Design
#
# This script orchestrates the complete Libero SoC design flow:
# 1. Creates project and downloads IP cores
# 2. Sources design creation scripts
# 3. Applies constraints
# 4. Runs implementation
# 5. Generates programming files
#==============================================================================

set install_loc [defvar_get -name ACTEL_SW_DIR]
set mss_config_loc "$install_loc/bin64/pfsoc_mss"
# Get the directory where this script is located (works regardless of where you run from)
set script_dir [file dirname [file normalize [info script]]]
source $script_dir/common/common.tcl
set src_path $script_dir/src
set Prjname "VKPFSOC_MJPEG"
set PrjLocation "./$Prjname"

#--- Design Variables
#variable used in the design
set SimTime 100us
set Effort_Level true
set Multi_Pass_Layout false
set Repair_Min_Delay false

# Remove existing project if present
file delete -force ${PrjLocation}

# Create and configure new project
new_project \
	-name "$Prjname" \
	-location "$PrjLocation" \
	-family "PolarFireSoC" \
	-die $die_eval \
	-package $eval_package \
	-die_voltage "1.0" \
	-speed "-1" \
	-part_range $eval_part_range \
	-hdl "VERILOG"
smartdesign -memory_map_drc_change_error_to_warning 1 -bus_interface_data_width_drc_change_error_to_warning 1 -bus_interface_id_width_drc_change_error_to_warning 1

# Set tool profiles
select_profile -name $synprofile1
select_profile -name $simuprofile1

puts "Project created successfully"

#--- Download IP Cores
# Actel DirectCore IPs
download_core -vlnv "Actel:DirectCore:CoreAPB3:$CoreAPB3ver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Actel:DirectCore:CORERESET_PF:$CORERESET_PFver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Actel:DirectCore:CORERXIODBITALIGN:$CORERXIODBITALIGNver" -location {www.microchip-ip.com/repositories/DirectCore}

# Actel SgCore IPs
download_core -vlnv "Actel:SgCore:PF_CCC:$PF_CCCver" -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv "Actel:SgCore:PF_CLK_DIV:$PF_CLK_DIVver" -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv "Actel:SgCore:PF_OSC:$PF_OSCver" -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv "Actel:SgCore:PF_XCVR_REF_CLK:$PF_XCVR_REF_CLKver" -location {www.microchip-ip.com/repositories/SgCore}

# Actel SystemBuilder IPs
download_core -vlnv "Actel:SystemBuilder:PF_IOD_GENERIC_RX:$PF_IOD_GENERIC_RXver" -location {www.microchip-ip.com/repositories/SgCore}

# Microsemi SgCore IPs
download_core -vlnv "Microsemi:SgCore:PFSOC_INIT_MONITOR:$PFSOC_INIT_MONITORver" -location {www.microchip-ip.com/repositories/SgCore}

# Microsemi SolutionCore IPs
download_core -vlnv "Microsemi:SolutionCore:Gamma_Correction:$Gamma_Correctionver" -location {www.microchip-ip.com/repositories/DirectCore}

# Microchip SolutionCore IPs
download_core -vlnv "Microchip:SolutionCore:Bayer_Interpolation:$Bayer_Interpolationver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:Image_Enhancement:$Image_Enhancementver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:RGBtoYCbCr:$RGBtoYCbCrver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:DDR_AXI4_ARBITER_PF:$DDR_AXI4_ARBITER_PFver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:mipicsi2rxdecoderPF:$mipicsi2rxdecoderPFver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:JPEG_Encoder:$JPEG_Encoderver" -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv "Microchip:SolutionCore:Color_Correction_Matrix:$Color_Correction_Matrixver" -location {www.microchip-ip.com/repositories/DirectCore}

#--- Create Design
source $src_path/1_create_design.tcl

#--- Design Flow Stages
source $src_path/2_constrain_design.tcl
source $src_path/3_implement_design.tcl
source $src_path/4_program_design.tcl

#--- Close Project
close_project -save 1
