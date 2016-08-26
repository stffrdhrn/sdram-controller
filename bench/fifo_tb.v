/**
 * Test bentch for fifo's
 *  1. fifo fast write read slow
 *  2. fifo write flow read fast
 *  3. fifo slight difference between clocks
 */
module fifo_tb();

 vlog_tb_utils vlog_tb_utils0();
 
 reg rst_n, clka, clkb, rd, wr;
 reg [3:0] datain;
 
 wire [3:0] dataout_slow;
 wire [3:0] dataout_fast;
 wire full_fast, empty_slow, full_slow, empty_fast;
    
initial 
begin
  rd = 0;
  wr = 0;
  datain = 4'b0000;
  rst_n = 1'b1;
  clka = 1'b0;
  clkb = 1'b0;
end

always
  #1 clka <= ~clka;
  
always
  #13 clkb <= ~clkb;
  
initial
begin
  #3 rst_n = 1'b0;
  #3 rst_n = 1'b1;
  
  
  #5 datain = 4'b0110;
  wr = 1'b1;
  #2 wr = 1'b0;
  #5 datain = 4'b0000;
  
  #80 rd = 1'b1;
  #26 rd = 1'b0;
 
  #100 $finish;
 
end
  
fifo #(.BUS_WIDTH(4)) fifo_f2si (
  .wr_data (datain), 
  .rd_data (dataout_slow),
  .wr_clk  (clka), 
  .rd_clk  (clkb),
  .wr      (wr), 
  .rd      (rd),
  .full    (full_fast), 
  .empty_n (empty_slow),
  .rst_n   (rst_n)
);

fifo #(.BUS_WIDTH(4)) fifo_s2fi (
  .wr_data (datain), 
  .rd_data (dataout_fast),
  .wr_clk  (clkb),
  .rd_clk  (clka),
  .wr      (wr),
  .rd      (rd),
  .full    (full_slow),
  .empty_n (empty_fast),
  .rst_n   (rst_n)
);
  
endmodule
