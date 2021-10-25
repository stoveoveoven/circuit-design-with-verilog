onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/test_success/SW[3]}
add wave -noupdate {/test_success/SW[2]}
add wave -noupdate {/test_success/SW[1]}
add wave -noupdate {/test_success/SW[0]}
add wave -noupdate {/test_success/KEY[3]}
add wave -noupdate {/test_success/KEY[0]}
add wave -noupdate /test_success/HEX0
add wave -noupdate /test_success/HEX1
add wave -noupdate /test_success/HEX2
add wave -noupdate /test_success/HEX3
add wave -noupdate /test_success/HEX4
add wave -noupdate /test_success/HEX5
add wave -noupdate /test_success/DUT/lock/clk
add wave -noupdate /test_success/DUT/lock/rst
add wave -noupdate /test_success/DUT/lock/in
add wave -noupdate /test_success/DUT/lock/out
add wave -noupdate /test_success/DUT/lock/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 195
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
WaveRestoreZoom {0 ps} {77 ps}
