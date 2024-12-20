transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/Quartus_prj/ipcore_dir {E:/FPGA/Lab_4/Quartus_prj/ipcore_dir/pll_ip.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/RTL {E:/FPGA/Lab_4/RTL/vga_pic.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/RTL {E:/FPGA/Lab_4/RTL/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/RTL {E:/FPGA/Lab_4/RTL/vga_char.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/Quartus_prj/db {E:/FPGA/Lab_4/Quartus_prj/db/pll_ip_altpll.v}

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_4/Quartus_prj/../Sim {E:/FPGA/Lab_4/Quartus_prj/../Sim/tb_vga_char.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_vga_char

add wave *
view structure
view signals
run -all
