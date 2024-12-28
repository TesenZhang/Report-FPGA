transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {snake_top.vo}

vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj/../Sim {E:/FPGA/FinalProject_1/Quartus_prj/../Sim/tb_key_debounce.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb_key_debounce

add wave *
view structure
view signals
run -all
