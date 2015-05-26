/* Input is a button 
 * Detect if the button is double clicked or single clicked in 
 * a time interval. Outputs are maintained until reset. 
 */

module double_click (
  button, 

  single, double,  

  clk, rst_n,
);

input  button;
output single, double;

input click, rst_n;

reg single_r, double_r;

assign single = single_r;
assign double = double_r;

reg btn_now, btn_last;

wire btn_down = btn_now & ~btn_last;
wire btn_up =  ~btn_now &  btn_last;

reg [2:0] click_cnt;
reg [19:0] dbl_click_cnt;

always @ (negedge clk)
 if (~rst_n) 
  { btn_last, btn_now } <= 2'b00;
 else
  { btn_last, btn_now } <= { btn_now, button };

always @ (posedge clk) 
 if (~rst_n)
  begin
  click_cnt <= 3'd0;
  dbl_click_cnt <= 20'd0;
  single_r <= 1'b0;
  double_r <= 1'b0;
  end
 else
   if (~single_r & ~double_r) 
     begin
     if (dbl_click_cnt == 20'hfffff) 
      if (click_cnt == 3'd0)
        { single_r, double_r } <= {single_r, double_r};
      else if (click_cnt == 3'd1)
        { single_r, double_r } <= 2'b10;
      else
        { single_r, double_r } <= 2'b01;
     else
      { single_r, double_r } <= {single_r, double_r};
      
     if (btn_down)
       click_cnt <= click_cnt + 1'b1;
     else
       click_cnt <= click_cnt;

     dbl_click_cnt <= dbl_click_cnt + 1'b1;
     end

endmodule
