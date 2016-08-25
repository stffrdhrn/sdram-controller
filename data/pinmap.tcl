#
# Clock / Reset
#
set_location_assignment PIN_J15 -to rst_n_pad_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n_pad_i
set_location_assignment PIN_E1 -to btn_n_pad_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to btn_n_pad_i
set_location_assignment PIN_R8 -to sys_clk_pad_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sys_clk_pad_i

#
# UART0: RX <-> GPIO_2[0] (Pin 5, bottom header)
#        TX <-> GPIO_2[1] (Pin 6, bottom header)
#
set_location_assignment PIN_A14 -to uart0_srx_pad_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_srx_pad_i
set_location_assignment PIN_B16 -to uart0_stx_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart0_stx_pad_o

#
# I2C0: Connected to the EEPROM and Accelerometer
#
set_location_assignment PIN_F2 -to i2c0_scl_io
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c0_scl_io
set_location_assignment PIN_F1 -to i2c0_sda_io
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c0_sda_io

#
# Accelerometer specific lines
#
set_location_assignment PIN_M2 -to accelerometer_irq_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to accelerometer_irq_i
set_location_assignment PIN_G5 -to accelerometer_cs_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to accelerometer_cs_o

#
# I2C1: sda <-> GPIO_2[6] (Pin 11, bottom header)
#       scl <-> GPIO_2[7] (Pin 12, bottom header)
#
set_location_assignment PIN_D15 -to i2c1_sda_io
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c1_sda_io
set_location_assignment PIN_D14 -to i2c1_scl_io
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c1_scl_io

#
# SPI0: Connected to the EPCS
#
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_location_assignment PIN_C1 -to spi0_mosi_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi0_mosi_o
set_location_assignment PIN_H2 -to spi0_miso_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi0_miso_i
set_location_assignment PIN_H1 -to spi0_sck_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi0_sck_o
set_location_assignment PIN_D2 -to spi0_ss_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi0_ss_o

#
# SPI1: Connected to the AD converter
#
set_location_assignment PIN_B10 -to spi1_mosi_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi1_mosi_o
set_location_assignment PIN_A9 -to spi1_miso_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi1_miso_i
set_location_assignment PIN_B14 -to spi1_sck_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi1_sck_o
set_location_assignment PIN_A10 -to spi1_ss_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi1_ss_o

#
# SPI2: MOSI <-> GPIO_2[2] (Pin  7, bottom header)
#       MISO <-> GPIO_2[3] (Pin  8, bottom header)
#       SCK  <-> GPIO_2[4] (Pin  9, bottom header)
#       SS   <-> GPIO_2[5] (Pin 10, bottom header)
#
set_location_assignment PIN_C14 -to spi2_mosi_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi2_mosi_o
set_location_assignment PIN_C16 -to spi2_miso_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi2_miso_i
set_location_assignment PIN_C15 -to spi2_sck_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi2_sck_o
set_location_assignment PIN_D16 -to spi2_ss_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi2_ss_o

#
# SDRAM
#
set_location_assignment PIN_P2 -to sdram_a_pad_o[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[0]
set_location_assignment PIN_N5 -to sdram_a_pad_o[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[1]
set_location_assignment PIN_N6 -to sdram_a_pad_o[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[2]
set_location_assignment PIN_M8 -to sdram_a_pad_o[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[3]
set_location_assignment PIN_P8 -to sdram_a_pad_o[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[4]
set_location_assignment PIN_T7 -to sdram_a_pad_o[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[5]
set_location_assignment PIN_N8 -to sdram_a_pad_o[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[6]
set_location_assignment PIN_T6 -to sdram_a_pad_o[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[7]
set_location_assignment PIN_R1 -to sdram_a_pad_o[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[8]
set_location_assignment PIN_P1 -to sdram_a_pad_o[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[9]
set_location_assignment PIN_N2 -to sdram_a_pad_o[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[10]
set_location_assignment PIN_N1 -to sdram_a_pad_o[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[11]
set_location_assignment PIN_L4 -to sdram_a_pad_o[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_a_pad_o[12]

set_location_assignment PIN_G2 -to sdram_dq_pad_io[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[0]
set_location_assignment PIN_G1 -to sdram_dq_pad_io[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[1]
set_location_assignment PIN_L8 -to sdram_dq_pad_io[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[2]
set_location_assignment PIN_K5 -to sdram_dq_pad_io[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[3]
set_location_assignment PIN_K2 -to sdram_dq_pad_io[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[4]
set_location_assignment PIN_J2 -to sdram_dq_pad_io[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[5]
set_location_assignment PIN_J1 -to sdram_dq_pad_io[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[6]
set_location_assignment PIN_R7 -to sdram_dq_pad_io[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[7]
set_location_assignment PIN_T4 -to sdram_dq_pad_io[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[8]
set_location_assignment PIN_T2 -to sdram_dq_pad_io[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[9]
set_location_assignment PIN_T3 -to sdram_dq_pad_io[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[10]
set_location_assignment PIN_R3 -to sdram_dq_pad_io[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[11]
set_location_assignment PIN_R5 -to sdram_dq_pad_io[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[12]
set_location_assignment PIN_P3 -to sdram_dq_pad_io[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[13]
set_location_assignment PIN_N3 -to sdram_dq_pad_io[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[14]
set_location_assignment PIN_K1 -to sdram_dq_pad_io[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dq_pad_io[15]

set_location_assignment PIN_R6 -to sdram_dqm_pad_o[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dqm_pad_o[0]
set_location_assignment PIN_T5 -to sdram_dqm_pad_o[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_dqm_pad_o[1]

set_location_assignment PIN_M7 -to sdram_ba_pad_o[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_ba_pad_o[0]
set_location_assignment PIN_M6 -to sdram_ba_pad_o[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_ba_pad_o[1]

set_location_assignment PIN_L1 -to sdram_cas_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_cas_pad_o

set_location_assignment PIN_L7 -to sdram_cke_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_cke_pad_o

set_location_assignment PIN_P6 -to sdram_cs_n_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_cs_n_pad_o

set_location_assignment PIN_L2 -to sdram_ras_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_ras_pad_o

set_location_assignment PIN_C2 -to sdram_we_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_we_pad_o

set_location_assignment PIN_R4 -to sdram_clk_pad_o
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sdram_clk_pad_o

#
# GPIO0 (LEDs)
#
set_location_assignment PIN_A15 -to gpio0_io[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[0]
set_location_assignment PIN_A13 -to gpio0_io[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[1]
set_location_assignment PIN_B13 -to gpio0_io[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[2]
set_location_assignment PIN_A11 -to gpio0_io[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[3]
set_location_assignment PIN_D1 -to gpio0_io[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[4]
set_location_assignment PIN_F3 -to gpio0_io[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[5]
set_location_assignment PIN_B1 -to gpio0_io[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[6]
set_location_assignment PIN_L3 -to gpio0_io[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio0_io[7]

#============================================================
# GPIO1 (Switches)
#============================================================
set_location_assignment PIN_M1  -to gpio1_i[0]
set_location_assignment PIN_T8  -to gpio1_i[1]
set_location_assignment PIN_B9  -to gpio1_i[2]
set_location_assignment PIN_M15 -to gpio1_i[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio1_i[*]
