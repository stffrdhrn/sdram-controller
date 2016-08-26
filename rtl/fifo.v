/*
 * This is a 2 clock fifo used for transferring data between
 * clock domains. 
 * 
 * I assume here that the output (read) clock is >5X slower than the
 * input (write) clock.
 *
 * Also, the fifo is just 1 word deep. 
 *
 * Changes
 *  - 2015-07-03   issue when writing from low speed clock, empty_n goes
 *                 high and stays high.  The reader side will see and read, but
 *                 after complete empty_n is still high.  It will continue
 *                 to read until empty_n is lowered based on the write side
 *                 clock.
 *                 The empty_n should go low once the reader reads.
 *
 */
module fifo (
  // Write side
  wr_clk,
  wr_data, 
  wr,
  full,   // means don't write any more
  
  // Read side
  rd_data,
  rd_clk,
  rd,
  empty_n, // also means we can read
  
  rst_n
);

parameter BUS_WIDTH = 16;

input [BUS_WIDTH-1:0]  wr_data;
input                  wr_clk;
input                  wr;
output                 full;      // Low-Means in side can write

output [BUS_WIDTH-1:0] rd_data; 
input                  rd_clk;
input                  rd;
output                 empty_n;   // High-Means out side can read

input                  rst_n;

reg [BUS_WIDTH-1:0]    wr_data_r;
reg [BUS_WIDTH-1:0]    rd_data;

/* 
 * these reg sets span accross 2 clock domtains
 *   CLK WR                    | CLK RD
 *  [wr_r] ------------------> | -> [wr_syn1] -> [wr_syn2] -\
 *  <- [wr_ack2] <- [wr_ack1]  | ---------------------------/
 *    ^^^^^^^^^^               |  
 *  Set wr_r when we get a wr  |  increment counter when we get
 *  Clr wr when we get wr_ack2 |  wr_syn2, and syncronize data
 * 
 */
reg                    wr_r, wr_syn1, wr_syn2, wr_ack1, wr_ack2;
reg                    rd_r, rd_syn1, rd_syn2, rd_ack1, rd_ack2;
reg                    wr_fifo_cnt;
reg                    rd_fifo_cnt;

assign full = wr_fifo_cnt == 1'b1;
assign empty_n = rd_fifo_cnt == 1'b1;

always @ (posedge rd_clk)
  if (~rst_n)
    begin
       rd_fifo_cnt <= 1'b0;
       {rd_ack2, rd_ack1} <= 2'b00; 
       {wr_syn2, wr_syn1} <= 2'b00; 
    end
  else
    begin
      
      {rd_ack2, rd_ack1} <= {rd_ack1, rd_syn2}; 
      {wr_syn2, wr_syn1} <= {wr_syn1, wr_r}; 
      
      if (rd)
        rd_r <= 1'b1;
      else if (rd_ack2)
        rd_r <= 1'b0;
      
      if (rd)
        rd_fifo_cnt <= 1'b0;
      if ({wr_syn2, wr_syn1} == 2'b01) // if we want to just do increment 1 time, we can check posedge
        rd_fifo_cnt <= 1'b1;
      
      if (wr_syn2)
        rd_data <= wr_data_r;
    end
    
always @ (posedge wr_clk)
 if (~rst_n)
   begin
      wr_fifo_cnt <= 1'b0;
      {rd_syn2, rd_syn1} <= 2'b00;
      {wr_ack2, wr_ack1} <= 2'b00;
   end
 else
   begin
     {wr_ack2, wr_ack1} <= {wr_ack1, wr_syn2};   
     {rd_syn2, rd_syn1} <= {rd_syn1, rd_r};
   
     if (wr)
       wr_r <= 1'b1;
     if (wr_ack2)
       wr_r <= 1'b0;
       
     if (wr)
       wr_fifo_cnt <= 1'b1;
     if ({rd_syn2, rd_syn1} == 2'b01)
       wr_fifo_cnt <= 1'b0;
       
     // register write data on write
     if (wr)
       wr_data_r <= wr_data;

   end


endmodule