transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Vending_machine_refund.vo}

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_3_3/Quartus_prj/../Sim {E:/FPGA/Lab_3_3/Quartus_prj/../Sim/tb_Vending_machine_refund.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb_Vending_machine_refund

add wave *
view structure
view signals
run -all
