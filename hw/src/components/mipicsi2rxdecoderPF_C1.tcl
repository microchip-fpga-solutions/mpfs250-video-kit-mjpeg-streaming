# Exporting Component Description of mipicsi2rxdecoderPF_C1 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250T-1FCG1152E
# Create and Configure the core component mipicsi2rxdecoderPF_C1
create_and_configure_core -core_vlnv "Microchip:SolutionCore:mipicsi2rxdecoderPF:$mipicsi2rxdecoderPFver" -component_name {mipicsi2rxdecoderPF_C1} -params {\
"g_DATAWIDTH:10"  \
"g_FIFO_SIZE:12"  \
"g_FORMAT:0"  \
"g_INPUT_DATA_INVERT:0"  \
"g_LANE_WIDTH:4"  \
"g_NO_OF_VC:1"  \
"g_NUM_OF_PIXELS:1"   }
# Exporting Component Description of mipicsi2rxdecoderPF_C1 to TCL done
