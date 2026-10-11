# Creating SmartDesign "FIC_CONVERTER"
set sd_name {FIC_CONVERTER}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PENABLE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PSEL} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PWRITE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PREADYS0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PREADYS1} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSLVERRS0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSLVERRS1} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PREADY} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB3mmaster_PSLVERR} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PENABLES} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSELS0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSELS1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PWRITES} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PADDR} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PWDATA} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PRDATAS0} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PRDATAS1} -port_direction {IN} -port_range {[31:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {APB3mmaster_PRDATA} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PADDRS} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PWDATAS} -port_direction {OUT} -port_range {[31:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {APBmslave} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"PADDR:PADDRS" \
"PSELx:PSELS1" \
"PENABLE:PENABLES" \
"PWRITE:PWRITES" \
"PRDATA:PRDATAS1" \
"PWDATA:PWDATAS" \
"PREADY:PREADYS1" \
"PSLVERR:PSLVERRS1" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {APBmslave0} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"PADDR:PADDRS" \
"PSELx:PSELS0" \
"PENABLE:PENABLES" \
"PWRITE:PWRITES" \
"PRDATA:PRDATAS0" \
"PWDATA:PWDATAS" \
"PREADY:PREADYS0" \
"PSLVERR:PSLVERRS0" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {APB3mmaster} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {mirroredMaster} -port_bif_mapping {\
"PADDR:APB3mmaster_PADDR" \
"PSELx:APB3mmaster_PSEL" \
"PENABLE:APB3mmaster_PENABLE" \
"PWRITE:APB3mmaster_PWRITE" \
"PRDATA:APB3mmaster_PRDATA" \
"PWDATA:APB3mmaster_PWDATA" \
"PREADY:APB3mmaster_PREADY" \
"PSLVERR:APB3mmaster_PSLVERR" } 

# Add CoreAPB3_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreAPB3_C0} -instance_name {CoreAPB3_C0_0}





# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB3mmaster" "CoreAPB3_C0_0:APB3mmaster" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APBmslave" "CoreAPB3_C0_0:APBmslave1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APBmslave0" "CoreAPB3_C0_0:APBmslave0" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "FIC_CONVERTER"
generate_component -component_name ${sd_name}
