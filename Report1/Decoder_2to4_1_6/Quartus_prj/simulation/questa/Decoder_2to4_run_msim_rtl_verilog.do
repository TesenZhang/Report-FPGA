transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/FPGA/Lab_1_6/Decoder_2to4/RTL {E:/FPGA/Lab_1_6/Decoder_2to4/RTL/Decoder_2to4.v}

