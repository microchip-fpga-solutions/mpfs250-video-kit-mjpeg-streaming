# Exporting Component Description of Bayer_Interpolation_C0 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T-1FCG1152E
# Create and Configure the core component Bayer_Interpolation_C0
create_and_configure_core -core_vlnv "Microchip:SolutionCore:Bayer_Interpolation:$Bayer_Interpolationver" -component_name {Bayer_Interpolation_C0} -params {\
"G_AXI4LITE:0"  \
"G_AXI4STREAM:0"  \
"G_BAYER_FORMAT:0"  \
"G_DATA_WIDTH:8"  \
"G_PIXELS:1"  \
"G_RAM_SIZE:2048"   }
# Exporting Component Description of Bayer_Interpolation_C0 to TCL done
