/**
 * simple controller for ISSI IS42S16160G-7 SDRAM found in De0 Nano
 *  16Mbit x 16 data bit bus (32 megabytes)
 *  Default options
 *    100Mhz
 *    CAS 2
 *
 *  Very simple host interface
 *     * No burst support
 *     * haddr - address for reading and wriging 16 bits of data
 *     * data_input - data for writing, latched in when wr_enable is highz0
 *     * data_output - data for reading, comes available sometime *few clocks* after rd_enable and address is presented on bus
 *     * rst_n - start init ram process
 *     * rd_enable - read enable, on clk posedge haddr will be latched in, after *few clocks* data will be available on the data_output port
 *     * wr_enable - write enable, on clk posedge haddr and data_input will be latched in, after *few clocks* data will be written to sdram
 *
 * Theory
 *  This simple host interface expects you to know the timing and know
 *  how long to wait for init, write operations and read operations
 */
 
parameter ROW_WIDTH = 13;
parameter COL_WIDTH = 9;
parameter BANK_WIDTH = 2;

parameter ADDR_WIDTH = ROW_WIDTH + COL_WIDTH + BANK_WIDTH;
 
module dram_controller (
    /* HOST INTERFACE */
    input  [23:0] haddr,
    input  [15:0] data_input,
    output [15:0] data_output,
    input  rd_enable,
    input  wr_enable,
    input  rst_n,
    input  clk,

    /* SDRAM SIDE */
    output [12:0] row_addr,   // 13 
    output [8:0]  col_addr,   // +9 = 22-bit address = 4mbit
    output [1:0]  bank_addr,  // 4 banks
    inout  [15:0] data,
    output        clock_enable,
    output        cs_n,
    output        ras_n,
    output        cas_n,
    output        we_n,
    output        data_mask_low, // DQML
    output        data_mask_high // DQMH
);

wire row_addr;
wire column_addr;
reg command;

assign row_addr = addr;
assign column_addr = addr[8:0];

endmodule