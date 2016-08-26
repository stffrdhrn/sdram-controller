/**
 * Test bench for double click detector module, simulates
 *  - Reset
 *  - 1-Click
 *  - 2-Click - expect 2 -click
 *  - Long-Click - expect 1-click
 *  - Multi-Click - exepect 2-click
 */
module double_click_tb();

 vlog_tb_utils vlog_tb_utils0();

 reg button_r;
 reg rst_n, clk;
 wire single, double;
    
initial 
begin
  button_r = 1'b0;
  rst_n = 1'b1;
  clk = 1'b0;
end

always
  #1 clk <= ~clk;
  
initial
begin
  #3 rst_n = 1'b0;
  #3 rst_n = 1'b1;
  
  #10 button_r = 1'b1;
  #100 button_r = 1'b0;
  
  
  #3 rst_n = 1'b0;
  #3 rst_n = 1'b1;

  #10 button_r = 1'b1;
  #4 button_r = 1'b0;
  #5 button_r = 1'b1;
  #3 button_r = 1'b0;
  
  #100 $finish;
    
end
  
double_click #(.WAIT_WIDTH(4)) double_clicki (
  .button(button_r), .single(single), .double(double),  
  .clk(clk), .rst_n(rst_n)
);

endmodule
