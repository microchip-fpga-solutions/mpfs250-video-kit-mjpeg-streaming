# Creating SmartDesign "video_pipeline"
set sd_name {video_pipeline}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SYS_CLK_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {encoder_en_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {frame_start_i} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_O} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {encoder_en_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {eof_encoder_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {frame_start_encoder_o} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {B_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M11_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M12_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M13_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M21_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M22_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M23_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M31_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M32_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_M33_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_O1_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_O2_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COEF_O3_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COMMON_CONST_I} -port_direction {IN} -port_range {[19:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {DATA_I} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {hres_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {vres_i} -port_direction {IN} -port_range {[15:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {DATA_B_O} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {DATA_G_O} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {DATA_R_O} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {Y_AVG_O} -port_direction {OUT} -port_range {[31:0]}


# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}
sd_invert_pins -sd_name ${sd_name} -pin_names {AND2_0:B}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {AND2_0:Y}



# Add Bayer_Interpolation_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Bayer_Interpolation_C0} -instance_name {Bayer_Interpolation_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Bayer_Interpolation_C0_0:BAYER_FORMAT_I} -value {GND}



# Add Color_Correction_Matrix_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Color_Correction_Matrix_C0} -instance_name {Color_Correction_Matrix_C0_0}



# Add frame_controls_gen_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {frame_controls_gen} -hdl_file {hdl\frame_controls_gen.v} -instance_name {frame_controls_gen_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {frame_controls_gen_0:h_scale_factor_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {frame_controls_gen_0:v_scale_factor_o}



# Add Gamma_Correction_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Gamma_Correction_C0} -instance_name {Gamma_Correction_C0_0}



# Add Image_Enhancement_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Image_Enhancement_C0} -instance_name {Image_Enhancement_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Image_Enhancement_C0_0:ENABLE_I} -value {VCC}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "Bayer_Interpolation_C0_0:RESETN_I" "Color_Correction_Matrix_C0_0:RESETN_I" "Gamma_Correction_C0_0:RESETN_I" "Image_Enhancement_C0_0:RESETN_I" "RESETN_I" "frame_controls_gen_0:resetn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "frame_controls_gen_0:frame_start_r1_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_VALID_I" "DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:FRAME_START_I" "frame_controls_gen_0:frame_start_i" "frame_start_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:FRAME_START_O" "Image_Enhancement_C0_0:FRAME_START_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:RGB_VALID_O" "Color_Correction_Matrix_C0_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:SYS_CLK_I" "Color_Correction_Matrix_C0_0:SYS_CLK_I" "Gamma_Correction_C0_0:SYS_CLK_I" "Image_Enhancement_C0_0:SYS_CLK_I" "SYS_CLK_I" "frame_controls_gen_0:sys_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Color_Correction_Matrix_C0_0:DATA_VALID_O" "Gamma_Correction_C0_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_VALID_O" "frame_controls_gen_0:data_valid_r1_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Gamma_Correction_C0_0:DATA_VALID_O" "Image_Enhancement_C0_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:DATA_VALID_O" "frame_controls_gen_0:data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"encoder_en_i" "frame_controls_gen_0:encoder_en_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"encoder_en_o" "frame_controls_gen_0:encoder_en_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"eof_encoder_o" "frame_controls_gen_0:eof_encoder_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_controls_gen_0:frame_start_encoder_o" "frame_start_encoder_o" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_CONST_I" "Image_Enhancement_C0_0:B_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O" "Color_Correction_Matrix_C0_0:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_I" "DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O" "Color_Correction_Matrix_C0_0:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O" "Color_Correction_Matrix_C0_0:R_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M11_I" "Color_Correction_Matrix_C0_0:COEF_M11_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M12_I" "Color_Correction_Matrix_C0_0:COEF_M12_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M13_I" "Color_Correction_Matrix_C0_0:COEF_M13_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M21_I" "Color_Correction_Matrix_C0_0:COEF_M21_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M22_I" "Color_Correction_Matrix_C0_0:COEF_M22_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M23_I" "Color_Correction_Matrix_C0_0:COEF_M23_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M31_I" "Color_Correction_Matrix_C0_0:COEF_M31_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M32_I" "Color_Correction_Matrix_C0_0:COEF_M32_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_M33_I" "Color_Correction_Matrix_C0_0:COEF_M33_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_O1_I" "Color_Correction_Matrix_C0_0:COEF_O1_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_O2_I" "Color_Correction_Matrix_C0_0:COEF_O2_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COEF_O3_I" "Color_Correction_Matrix_C0_0:COEF_O3_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COMMON_CONST_I" "Image_Enhancement_C0_0:COMMON_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Color_Correction_Matrix_C0_0:B_O" "Gamma_Correction_C0_0:BLUE_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Color_Correction_Matrix_C0_0:G_O" "Gamma_Correction_C0_0:GREEN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Color_Correction_Matrix_C0_0:R_O" "Gamma_Correction_C0_0:RED_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_B_O" "frame_controls_gen_0:data_b_r1_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_G_O" "frame_controls_gen_0:data_g_r1_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_R_O" "frame_controls_gen_0:data_r_r1_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_CONST_I" "Image_Enhancement_C0_0:G_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Gamma_Correction_C0_0:BLUE_O" "Image_Enhancement_C0_0:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Gamma_Correction_C0_0:GREEN_O" "Image_Enhancement_C0_0:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Gamma_Correction_C0_0:RED_O" "Image_Enhancement_C0_0:R_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:B_O" "frame_controls_gen_0:data_b_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:G_O" "frame_controls_gen_0:data_g_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:R_CONST_I" "R_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:R_O" "frame_controls_gen_0:data_r_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:Y_AVG_O" "Y_AVG_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_controls_gen_0:hres_i" "hres_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_controls_gen_0:vres_i" "vres_i" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "video_pipeline"
generate_component -component_name ${sd_name}
