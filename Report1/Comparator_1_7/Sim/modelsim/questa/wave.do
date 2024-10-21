onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_comparator_1bit/A
add wave -noupdate /tb_comparator_1bit/B
add wave -noupdate /tb_comparator_1bit/LED1
add wave -noupdate /tb_comparator_1bit/LED2
add wave -noupdate /tb_comparator_1bit/LED3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158660 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {64 ns} {192 ns}
