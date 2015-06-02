/* Input is a button 
 * Detect if the button is double clicked or single clicked in 
 * a time interval. Outputs are maintained until reset. 
 */

module double_click (
  button, 

  single, double,  

  clk, rst_n
);

parameter WAIT_WIDTH = 19;

input  button;
output single, double;
input clk, rst_n;

reg btn_now, btn_last, collect;

reg [2:0] click_cnt;
reg [WAIT_WIDTH-1:0] dbl_click_cnt;

// if we are done counting and we have 1 click its single, else double
assign single = (!dbl_click_cnt & (click_cnt == 3'b001)) ? 1'b1 : 1'b0;
assign double = (!dbl_click_cnt & (click_cnt != 3'b001)) ? 1'b1 : 1'b0;

// detect button down vs button up
wire btn_down = btn_now & ~btn_last;
//wire btn_up =  ~btn_now &  btn_last;
always @ (negedge clk)
 if (~rst_n) 
  { btn_last, btn_now } <= 2'b00;
 else
  { btn_last, btn_now } <= { btn_now, button };

// start down counter and count clicks
always @ (posedge clk) 
 if (~rst_n)
  begin
  click_cnt <= 3'd0;
  dbl_click_cnt <= {WAIT_WIDTH{1'b1}};
  collect <= 1'b0;
  end
 else
  begin
  if (collect & (dbl_click_cnt != {WAIT_WIDTH{1'b0}})) 
    dbl_click_cnt <= dbl_click_cnt - 1'b1;
  else
    dbl_click_cnt <= dbl_click_cnt;
    
  if (btn_down)
    begin
    collect <= 1'b1;
    click_cnt <= click_cnt + 1'b1;
    end
  else
    begin
    collect <= collect;
    click_cnt <= click_cnt;
    end  
  end

endmodule
