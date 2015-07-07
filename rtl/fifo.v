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
reg                    empty_n;

reg                    full_syn1, full_syn2;     // Always need 2 synchro flops 
reg                    empty_n_syn1, empty_n_syn2;

reg                    rd_r;
reg                    wr_r;
reg                    full;
wire                   full_nxt;
wire                   empty_n_nxt;


assign full_nxt = (wr | wr_r) | (full & empty_n_syn2);

assign empty_n_nxt = ~rd & ~rd_r & full_syn2;

always @ (posedge rd_clk)
  if (~rst_n)
    begin
    empty_n <= 1'b0;
    {full_syn2, full_syn1} <= 2'b00;
    end
  else
    begin
      {full_syn2, full_syn1} <= {full_syn1, full};
      
      // store that we got a read until we get and ack
      // from the write side
      rd_r <= rd | (full_syn2 & rd_r);
      
      // if wr is much faster than read side we
      // will miss the wr_syn
      
      if (full_syn2)
        rd_data <= wr_data_r;
        
      empty_n <= empty_n_nxt;
      
    end
    
always @ (posedge wr_clk)
 if (~rst_n)
   begin
   wr_r <= 1'b0;
   full <= 1'b0;
   {empty_n_syn2, empty_n_syn1} <= 2'b00;
   end
 else
   begin
     {empty_n_syn2, empty_n_syn1} <= {empty_n_syn1, empty_n};
     
     // store that we got a wr until we get the ack from
     // the read side
     wr_r <= wr | (~empty_n_syn2 & wr_r);
     
     // If wr clock is really slow the rd will not be observerd
     // We also store rd 
     full <= full_nxt;
       
     // register write data on write
     if (wr)
       wr_data_r <= wr_data;

   end


endmodule