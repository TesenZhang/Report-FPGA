onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_latch_1/in1
add wave -noupdate /tb_latch_1/in2
add wave -noupdate /tb_latch_1/in3
add wave -noupdate /tb_latch_1/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {77200 ps}
