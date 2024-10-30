transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_2_3_1/RTL {E:/FPGA/Lab_2_3_1/RTL/asyn_flip_flop.v}

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_2_3_1/Quartus_prj/../Sim {E:/FPGA/Lab_2_3_1/Quartus_prj/../Sim/tb_asyn_flip_flop.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_asyn_flip_flop

add wave *
view structure
view signals
run 1 us
