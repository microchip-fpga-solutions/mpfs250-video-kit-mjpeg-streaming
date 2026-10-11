# Creating SmartDesign "JPEG_top"
set sd_name {JPEG_top}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB_BUS_Interface_APB_PEN_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB_BUS_Interface_APB_PSEL_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB_BUS_Interface_APB_PWRITE_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {apb_clk} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {apb_reset_n} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {arready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {awready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {bvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {clr_intr_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_ctrl_ready_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {eof_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {fic_clk} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {h264_encoder_en} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_reset_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {resetn_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rlast} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {sys_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wready} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {arvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {awvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {bready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {frm_interrupt_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wlast} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wr_done_eof_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wvalid} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {APB_BUS_Interface_APB_PADDR_I} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {APB_BUS_Interface_APB_PWDATA_I} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {bid} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {bresp} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {chroma_in} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {frame_ddr_addr_i_0} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {luma_in} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rdata} -port_direction {IN} -port_range {[63:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rid} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rresp} -port_direction {IN} -port_range {[1:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {araddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arid} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arlock} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awaddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awid} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awlock} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {frame_bytes_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {frame_index_o} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {wdata} -port_direction {OUT} -port_range {[63:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {wstrb} -port_direction {OUT} -port_range {[7:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {BIF_1} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"AWID:awid" \
"AWADDR:awaddr" \
"AWLEN:awlen" \
"AWSIZE:awsize" \
"AWBURST:awburst" \
"AWLOCK:awlock" \
"AWCACHE:awcache" \
"AWPROT:awprot" \
"AWVALID:awvalid" \
"AWREADY:awready" \
"WDATA:wdata" \
"WSTRB:wstrb" \
"WLAST:wlast" \
"WVALID:wvalid" \
"WREADY:wready" \
"BID:bid" \
"BRESP:bresp" \
"BVALID:bvalid" \
"BREADY:bready" \
"ARID:arid" \
"ARADDR:araddr" \
"ARLEN:arlen" \
"ARSIZE:arsize" \
"ARBURST:arburst" \
"ARLOCK:arlock" \
"ARCACHE:arcache" \
"ARPROT:arprot" \
"ARVALID:arvalid" \
"ARREADY:arready" \
"RID:rid" \
"RDATA:rdata" \
"RRESP:rresp" \
"RLAST:rlast" \
"RVALID:rvalid" \
"RREADY:rready" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {APB_BUS_Interface} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {slave} -port_bif_mapping {\
"PADDR:APB_BUS_Interface_APB_PADDR_I" \
"PSELx:APB_BUS_Interface_APB_PSEL_I" \
"PENABLE:APB_BUS_Interface_APB_PEN_I" \
"PWRITE:APB_BUS_Interface_APB_PWRITE_I" \
"PWDATA:APB_BUS_Interface_APB_PWDATA_I" } 

# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}



# Add DDR_AXI4_ARBITER_PF_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_AXI4_ARBITER_PF_C0} -instance_name {DDR_AXI4_ARBITER_PF_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_req_i} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_data_valid_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_done_o}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:r0_rstart_addr_i} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_AXI4_ARBITER_PF_C0_0:rdata_o}



# Add JPEG_Encoder_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {JPEG_Encoder_C0} -instance_name {JPEG_Encoder_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {JPEG_Encoder_0:HRES_I} -value {0000011110000000}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {JPEG_Encoder_0:VRES_I} -value {0000010000111000}



# Add MJPEG_DDR_WRITE_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MJPEG_DDR_WRITE} -instance_name {MJPEG_DDR_WRITE_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "MJPEG_DDR_WRITE_0:reset_i" "resetn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "MJPEG_DDR_WRITE_0:h264_encoder_en_i" "h264_encoder_en" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "JPEG_Encoder_0:ARSTN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:ddr_ctrl_ready_i" "ddr_ctrl_ready_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:reset_i" "read_reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:sys_clk_i" "MJPEG_DDR_WRITE_0:ddr_clk_i" "fic_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_ack_o" "MJPEG_DDR_WRITE_0:write_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_data_valid_i" "MJPEG_DDR_WRITE_0:rdata_rdy_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_done_o" "MJPEG_DDR_WRITE_0:write_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_req_i" "MJPEG_DDR_WRITE_0:write_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:APB_CLK_I" "apb_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:APB_RESETN_I" "apb_reset_n" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:DATA_VALID_I" "data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:DATA_VALID_O" "MJPEG_DDR_WRITE_0:data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:EOF_I" "MJPEG_DDR_WRITE_0:frame_end_i" "eof_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:PIX_CLK_I" "MJPEG_DDR_WRITE_0:h264_clk_i" "sys_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:clr_intr_i" "clr_intr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:frm_interrupt_o" "frm_interrupt_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:wr_done_eof_o" "wr_done_eof_o" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_burst_size_i" "MJPEG_DDR_WRITE_0:write_length_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_data_i" "MJPEG_DDR_WRITE_0:rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_wstart_addr_i" "MJPEG_DDR_WRITE_0:write_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:DATA_C_I" "chroma_in" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:DATA_O" "MJPEG_DDR_WRITE_0:data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"JPEG_Encoder_0:DATA_Y_I" "luma_in" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:frame_bytes_o" "frame_bytes_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:frame_ddr_addr_i_0" "frame_ddr_addr_i_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MJPEG_DDR_WRITE_0:frame_index_o" "frame_index_o" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_BUS_Interface" "JPEG_Encoder_0:APB_BUS_Interface" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIF_1" "DDR_AXI4_ARBITER_PF_C0_0:MIRRORED_SLAVE_AXI4" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "JPEG_top"
generate_component -component_name ${sd_name}
