vlib work
vlog alu.v
vlog datapath.v
vlog regfile.v
vlog shifter.v
vsim -c work.datapath_tb
vsim -c work.regfile_tb
vsim -c work.shifter_tb
vsim -c work.ALU_tb
run -all
quit -f