vim:
	vim -p makefile bidirectional_xor_memory.v compile.tcl

tcl: common.vh
	vivado -mode tcl < compile.tcl

common.vh: abs.vh log2.vh
	cp ../common/common.vh .

abs.vh:
	cp ../common/abs.vh .

log2.vh:
	cp ../common/log2.vh .
