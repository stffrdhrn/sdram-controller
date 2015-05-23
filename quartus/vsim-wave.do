onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /init_tb/haddr
add wave -noupdate /init_tb/data_input
add wave -noupdate /init_tb/data_output
add wave -noupdate /init_tb/busy
add wave -noupdate /init_tb/rd_enable
add wave -noupdate /init_tb/wr_enable
add wave -noupdate /init_tb/rst_n
add wave -noupdate /init_tb/clk
add wave -noupdate -radix hexadecimal /init_tb/addr
add wave -noupdate /init_tb/bank_addr
add wave -noupdate /init_tb/data
add wave -noupdate /init_tb/clock_enable
add wave -noupdate /init_tb/cs_n
add wave -noupdate /init_tb/ras_n
add wave -noupdate /init_tb/cas_n
add wave -noupdate /init_tb/we_n
add wave -noupdate /init_tb/data_mask_low
add wave -noupdate /init_tb/data_mask_high
add wave -noupdate /init_tb/sdram_controlleri/data_input_r
add wave -noupdate /init_tb/sdram_controlleri/data_output_r
add wave -noupdate -radix unsigned /init_tb/sdram_controlleri/state_cnt
add wave -noupdate -radix unsigned /init_tb/sdram_controlleri/refresh_cnt
add wave -noupdate /init_tb/sdram_controlleri/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {270 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
configure wave -valuecolwidth 132
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
WaveRestoreZoom {0 ps} {110 ps}
