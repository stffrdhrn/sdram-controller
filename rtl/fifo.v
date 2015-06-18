/*
 * This is a 2 clock fifo used for transferring data between
 * clock domains. 
 * 
 * I assume here that the output (read) clock is >5X slower than the
 * input (write) clock.
 *
 * Also, the fifo is just 1 word deep. 
 */
module fifo (
  datain, dataout,
  clkin, clkout,
  wr, rd,
  full, empty_n,
  rst_n
);

parameter BUS_WIDTH = 16;

input [BUS_WIDTH-1:0]  datain;
input                  clkin;
input                  clkout;
input                  wr;
input                  rd;
input                  rst_n;

output [BUS_WIDTH-1:0] dataout; 
output                 full;      // Low-Means in side can write
output                 empty_n;   // High-Means out side can read


reg [BUS_WIDTH-1:0]    datain_r;
reg [BUS_WIDTH-1:0]    dataout;
reg                    empty_n;

reg                    rd_syn1, rd_syn2;     // Always need 2 synchro flops 
reg                    full_syn1, full_syn2;

reg                    full_r;
wire                   full_nxt;

assign full_nxt = wr | full_r;

// When data is read the read signal will be
// high for a long time. We dont want to get writes
// during this time so consider the queue still 
// full. 
assign full = rd_syn2 | full_r;  // <<<<<< READ is Clock Domain Cross 

always @ (posedge clkout)
  if (~rst_n)
    begin
    dataout <= {BUS_WIDTH{1'b0}};
    empty_n <= 1'b0;
    {full_syn2, full_syn1} <= 2'b00;
    end
  else
    begin
      {full_syn2, full_syn1} <= {full_syn1, full_r};
    
    if (full_syn2)
      begin
      empty_n <= 1'b1;
      dataout <= datain_r;
      end
    else 
      begin
      empty_n <= 1'b0;
      dataout <= dataout;
      end
      
    end
    
always @ (posedge clkin)
 if (~rst_n)
   begin
   full_r <= 1'b0;
   {rd_syn2, rd_syn1} <= 2'b00;
   end
 else
   begin
     {rd_syn2, rd_syn1} <= {rd_syn1, rd};
     
     if (rd_syn2)
       full_r <= 1'b0;
     else
       full_r <= full_nxt;
       
     if (wr)
       datain_r <= datain;
     else 
       datain_r <= datain_r;
   end


endmodule