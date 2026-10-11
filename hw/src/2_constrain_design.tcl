#==============================================================================
# Constrain Design
#
# Imports I/O, timing, and placement constraints for the design.
#==============================================================================

#--- Import Constraint Files
import_files -io_pdc {./src/constraints/VKPFSOC_MAC.pdc}
import_files -io_pdc {./src/constraints/VKPFSOC_MMUART0.pdc}
import_files -io_pdc {./src/constraints/VKPFSOC_MMUART1.pdc}
import_files -io_pdc {./src/constraints/user.pdc}
import_files -sdc {./src/constraints/user.sdc}
derive_constraints_sdc

#--- Organize Tool Files
organize_tool_files -tool {SYNTHESIZE} \
	-file ${PrjLocation}/constraint/top_derived_constraints.sdc\
	-module {top::work} \
	-input_type {constraint}
organize_tool_files -tool {PLACEROUTE} \
	-file ${PrjLocation}/constraint/top_derived_constraints.sdc \
	-file ${PrjLocation}/constraint/io/user.pdc\
	-file ${PrjLocation}/constraint/io/VKPFSOC_MMUART1.pdc\
	-file ${PrjLocation}/constraint/io/VKPFSOC_MMUART0.pdc\
	-file ${PrjLocation}/constraint/io/VKPFSOC_MAC.pdc\
	-file ${PrjLocation}/constraint/user.sdc \
	-module {top::work} \
	-input_type {constraint}
organize_tool_files -tool {VERIFYTIMING} \
	-file ${PrjLocation}/constraint/top_derived_constraints.sdc \
	-file ${PrjLocation}/constraint/user.sdc \
	-module {top::work} \
	-input_type {constraint}

#--- Run Constraint Management
## run_tool -name {CONSTRAINT_MANAGEMENT}
run_tool_wrapper "run_tool -name {CONSTRAINT_MANAGEMENT}
"
save_project 
 puts "Imported and derived constraints successfully
"
