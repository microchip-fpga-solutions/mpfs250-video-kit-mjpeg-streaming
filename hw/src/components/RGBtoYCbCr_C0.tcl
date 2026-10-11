# Exporting Component Description of RGBtoYCbCr_C0 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T-1FCG1152E
# Create and Configure the core component RGBtoYCbCr_C0
create_and_configure_core -core_vlnv "Microchip:SolutionCore:RGBtoYCbCr:$RGBtoYCbCrver" -component_name {RGBtoYCbCr_C0} -params {\
"G_DATA_BIT_WIDTH:8"  \
"G_FORMAT:0"  \
"G_PIXELS:1"  \
"G_YCbCr_FORMAT:2"   }
# Exporting Component Description of RGBtoYCbCr_C0 to TCL done
