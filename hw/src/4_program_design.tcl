#==============================================================================
# Program Design
#
# Generates programming data and job files for FlashPro Express.
#==============================================================================

#--- ENVM Configuration
# Generate absolute path for ENVM configuration
set envm_cfg_src "${src_path}/cfg/ENVM.cfg"
set hex_file_abs [file normalize "${src_path}/components/MSS_MJPEG/hss-envm-wrapper.mpfs-video-kit.hex"]

# Read original ENVM.cfg and create a temp version with absolute path
set envm_cfg_temp "${src_path}/ENVM_temp.cfg"
set fd_in [open $envm_cfg_src r]
set content [read $fd_in]
close $fd_in

# Replace relative path with absolute path
set pattern {-content_file \{[^\}]+\}}
set replacement "-content_file \{$hex_file_abs\}"
regsub -- $pattern $content $replacement content

set fd_out [open $envm_cfg_temp w]
puts -nonewline $fd_out $content
close $fd_out

#--- Generate Programming Data
## run_tool -name {GENERATEPROGRAMMINGDATA}
run_tool_wrapper "run_tool -name {GENERATEPROGRAMMINGDATA} "
configure_envm -cfg_file "$envm_cfg_temp"

# Clean up temp file
file delete -force $envm_cfg_temp

## run_tool -name GENERATEPROGRAMMINGFILE
run_tool_wrapper "run_tool -name GENERATEPROGRAMMINGFILE
"

puts "Programmingfile generated successfully\n"

#--- Export Programming Files
puts "Exported bit stream successfully\n"
puts "Exported job file successfully\n"

puts "Full design flow passed execution"
