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


 
module sdram_controller (
    /* HOST INTERFACE */
    haddr,
    data_input,
    data_output,
    busy,
    rd_enable,
    wr_enable,
    rst_n,
    clk,

    /* SDRAM SIDE */
    addr,   // 13 
    bank_addr,  // 4 banks
    data,
    clock_enable,
    cs_n,
    ras_n,
    cas_n,
    we_n,
    data_mask_low, // DQML
    data_mask_high // DQMH
);

/* Internal Parameters */
parameter ROW_WIDTH = 13;
parameter COL_WIDTH = 9;
parameter BANK_WIDTH = 2;

localparam SDRADDR_WIDTH = ROW_WIDTH > COL_WIDTH ? ROW_WIDTH : COL_WIDTH;
localparam HADDR_WIDTH = ROW_WIDTH + COL_WIDTH + BANK_WIDTH;
 
parameter CLK_FREQUENCY = 133; // Mhz
parameter REFRESH_COUNT = 8192;
parameter REFRESH_TIME =  32;  // ms

// clk / refresh =  clk / sec 
//                , sec / refbatch 
//                , ref / refbatch
localparam CYCLES_BETWEEN_REFRESH = ( ( CLK_FREQUENCY * 1000000 * REFRESH_TIME ) / 1000 ) / REFRESH_COUNT;

// STATES - HIGH LEVEL
localparam IDLE = 2'b00;
localparam INIT = 2'b01;
localparam REF =  2'b10;
 
// Commands             CCRCWBBA
//                      ESSSE100
localparam CMD_PALL = 8'b10010001;
localparam CMD_REF  = 8'b10001000;
localparam CMD_NOP  = 8'b10111000;
localparam CMD_MRS  = 8'b10000000;

/* Interface Definition */
/* HOST INTERFACE */
input  [HADDR_WIDTH-1:0]   haddr;
input  [15:0]              data_input;
output [15:0]              data_output;
output                     busy;
input                      rd_enable;
input                      wr_enable;
input                      rst_n;
input                      clk;

/* SDRAM SIDE */
output [SDRADDR_WIDTH-1:0] addr;
output [BANK_WIDTH-1:0]    bank_addr;
inout  [15:0]              data;
output                     clock_enable;
output                     cs_n;
output                     ras_n;
output                     cas_n;
output                     we_n;
output                     data_mask_low;
output                     data_mask_high;

/* Internal Wiring */
reg [7:0] command;

assign clock_enable = command[7];
assign cs_n         = command[6];
assign ras_n        = command[5];
assign cas_n        = command[4];
assign we_n         = command[3];
assign bank_addr[1] = command[2];
assign bank_addr[0] = command[1];
assign addr[10]     = command[0];

always @ (posedge clk)
  if (~rst_n)
    command <= CMD_NOP;
  else 
    command <= command;

endmodule
