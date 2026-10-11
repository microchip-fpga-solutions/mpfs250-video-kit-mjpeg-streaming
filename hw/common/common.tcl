#==============================================================================
# Central table of IP-core versions, tool profiles and device information.
#
# This is the ONE place to update when moving to a new Libero or IP release:
# script.tcl builds every download_core VLNV from these variables, so a version
# bump here propagates to the whole flow. One variable per core (a core used at
# several instances -- PF_CCC, CorePCS, CORERESET_PF -- still has a single
# version, so it appears once).
#==============================================================================

#--- IP Core Versions
set Bayer_Interpolationver {4.8.1}
set CoreAPB3ver {4.2.100}
set CORERESET_PFver {2.3.100}
set CORERESET_PFver {2.3.100}
set CORERESET_PFver {2.3.100}
set CORERESET_PFver {2.3.100}
set CORERXIODBITALIGNver {2.3.103}
set DDR_AXI4_ARBITER_PFver {2.2.0}
set Gamma_Correctionver {4.3.0}
set Image_Enhancementver {4.6.0}
set Color_Correction_Matrixver {1.0.0}
set PFSOC_INIT_MONITORver {1.0.309}
set JPEG_Encoderver {1.3.0}
set mipicsi2rxdecoderPFver {5.1.0}
set PF_CCCver {2.2.222}
set PF_CCCver {2.2.222}
set PF_CLK_DIVver {1.0.103}
set PF_IOD_GENERIC_RXver {2.1.117}
set PF_OSCver {1.0.102}
set PF_XCVR_REF_CLKver {1.0.103}
set RGBtoYCbCrver {4.6.0}

#--- Tool Profiles
set synprofile1 {Synplify Pro ME}
set simuprofile1 {QuestaSim ME} 

#--- Device Details
set die_eval {MPFS250T}
set eval_package {FCG1152}
set eval_part_range {EXT}

#--- Utility Procedures
# A common procedure called by all tests.
# Computes the runtime for each command run in Libero

proc run_tool_wrapper { cmd } {

# get tool name from the command

regexp {run_tool\s+-name\s+\{*(\w*)\}*} $cmd full1 tool;

puts "Starting $tool command";

set full_cmd  "time \{ $cmd \}" ;

set TIME_start [clock seconds];

set runtime [eval $full_cmd ];

set TIME_taken [expr [clock seconds] - $TIME_start];

puts  "\nRUNTIME:$tool=$TIME_taken secs\n";

set runtime_secs [ expr [lindex $runtime 0]/1000000];

puts "\nRUNTIME_bytime:$tool=$runtime_secs secs\n"; 
}
