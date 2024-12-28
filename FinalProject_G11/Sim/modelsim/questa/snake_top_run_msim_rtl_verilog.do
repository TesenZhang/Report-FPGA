transcript on
if ![file isdirectory snake_top_iputf_libs] {
	file mkdir snake_top_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "E:/FPGA/FinalProject_1/Quartus_prj/pll_sim/pll.vo"

vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/top_seg_595.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/seg_dynamic.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/seg_595_dynamic.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/hc595_ctrl.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/data_gen.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/RTL {E:/FPGA/FinalProject_1/RTL/bcd_8421.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/key_debounce.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/VGA_control.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/snake.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/apple_generate.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/game_ctrl_unit.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/score_ctrl.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/snake_top.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj/pll {E:/FPGA/FinalProject_1/Quartus_prj/pll/pll.v}
vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj/db {E:/FPGA/FinalProject_1/Quartus_prj/db/pll_altpll.v}

vlog -vlog01compat -work work +incdir+E:/FPGA/FinalProject_1/Quartus_prj {E:/FPGA/FinalProject_1/Quartus_prj/snake_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  snake_top_tb

add wave *
view structure
view signals
run -all
