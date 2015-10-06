set outputDir ./vivado
file mkdir $outputDir
read_verilog ./bidirectional_xor_memory.v
read_verilog ../ram/simple_dual_port_ram.v
read_xdc constraints.xdc
#create_clock -period 2.50 clk
#synth_design -no_iobuf -include_dirs ../. -top std_fifo -part xc7v2000t
synth_design -include_dirs ../. -top bidirectional_xor_memory -part xc7v2000t
#synth_design -top bidirectional_xor_memory -part xc7a200t
write_checkpoint -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt
opt_design
place_design
route_design
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_utilization -file $outputDir/post_route_util.rpt
