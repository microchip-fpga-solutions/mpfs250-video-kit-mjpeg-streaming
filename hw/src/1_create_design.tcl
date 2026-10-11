#==============================================================================
# Generate base design
#==============================================================================

#--- MSS Component
#exec $mss_config_loc -CONFIGURATION_FILE:$src_path/components/MSS_MJPEG/MSS_MJPEG.cfg -OUTPUT_DIR:${src_path}/components/MSS_MJPEG
import_mss_component -file "$src_path/components/MSS_MJPEG/MSS_MJPEG.cxz"

#--- HDL Sources
import_files -library {work} -hdl_source "$src_path/hdl/ddr_write_controller_jpeg_fifo.v"
import_files -library {work} -hdl_source "$src_path/hdl/frame_controls_gen.v"
import_files -library {work} -hdl_source "$src_path/hdl/apb_wrapper.vhd"
import_files -library {work} -hdl_source "$src_path/hdl/data_packer_mjpeg.vhd"
import_files -library {work} -hdl_source "$src_path/hdl/ram2port.vhd"
import_files -library {work} -hdl_source "$src_path/hdl/video_fifo.vhd"

#--- IP Core Components
source $src_path/components/PF_IOD_GENERIC_RX_C0.tcl
source $src_path/components/Bayer_Interpolation_C0.tcl
source $src_path/components/CoreAPB3_C0.tcl
source $src_path/components/CORERESET.tcl
source $src_path/components/CORERESET_PF_C1.tcl
source $src_path/components/CORERESET_PF_C2.tcl
source $src_path/components/CORERESET_PF_C5.tcl
source $src_path/components/CORERXIODBITALIGN_C1.tcl
source $src_path/components/Color_Correction_Matrix_C0.tcl
source $src_path/components/DDR_AXI4_ARBITER_PF_C0.tcl
source $src_path/components/Gamma_Correction_C0.tcl
source $src_path/components/Image_Enhancement_C0.tcl
# IMAGE_SCALER removed - not in design
source $src_path/components/INIT_MONITOR.tcl
source $src_path/components/JPEG_Encoder_C0.tcl
source $src_path/components/mipicsi2rxdecoderPF_C1.tcl
source $src_path/components/PF_CCC_C0.tcl
source $src_path/components/PF_CCC_C2.tcl
source $src_path/components/PF_CLK_DIV_C0.tcl
source $src_path/components/PF_OSC_C0.tcl
source $src_path/components/PF_XCVR_REF_CLK_C0.tcl
source $src_path/components/RGBtoYCbCr_C0.tcl
 build_design_hierarchy

#--- SmartDesign Components
source $src_path/components/apb3_if.tcl
source $src_path/components/video_fifo.tcl
source $src_path/components/CAM_IOD_TIP_TOP.tcl
 build_design_hierarchy
source $src_path/components/CLOCKS_AND_RESETS.tcl
 build_design_hierarchy
source $src_path/components/FIC_CONVERTER.tcl
 build_design_hierarchy
source $src_path/components/MJPEG_DDR_WRITE.tcl
 build_design_hierarchy
source $src_path/components/IMX334_IF_TOP.tcl
 build_design_hierarchy
source $src_path/components/JPEG_top.tcl
 build_design_hierarchy
source $src_path/components/video_pipeline.tcl
 build_design_hierarchy
source $src_path/components/video_processing.tcl
 build_design_hierarchy

#--- Top Level Design
source $src_path/components/top.tcl
 build_design_hierarchy
set_root -module {top::work}
save_project
puts "Design generated successfully
"
