/* De0 Nano interface for testing sdram controller 
 * Handles interpreting buttons and switches 
 * to talk to the sdram controller.
 */

module dnano_interface (
  /* Human Interface */
  button, dip, leds,

  /* Controller Interface */
  haddr, data_input, data_output, busy, rd_enable, wr_enable, 

  /* basics */
  rst_n, clk

);

parameter HADDR_WIDTH = 24;
 
input        button;
input  [3:0] dip;
output [7:0] leds;

output [HADDR_WIDTH-1:0]   haddr;
output [15:0]              data_input;
input  [15:0]              data_output;
input                      busy;
output                     rd_enable;
output                     wr_enable;

input                      rst_n;
input                      clk;

wire  [15:0] data_input;
wire  [15:0] data_output;
reg   [20:0] led_cnt;
wire  [7:0]  leds;

reg   rd_enable_r, wr_enable_r;
reg   [19:0] dbl_click_cnt;
reg   [2:0] click_cnt;

// expand the dip data from 4 to 16 bits
assign data_input = {dip, dip, ~dip, ~dip};
// toggle leds between sdram msb and lsb
assign leds = led_cnt[20] ? data_output[15:8] : data_output[7:0]; 

// handle led counter should just loop every half second
always @ (posedge clk) 
 if (~rst_n) 
  led_cnt <= 21'd0;
 else
  led_cnt <= led_cnt + 1'b1;

// handle button and read/write
//  single-click write
//  double-click read
// writes always generate a new sdram address
always @ (posedge clk)
 if (~rst_n)
   begin
   rd_enable_r <= 1'b0;
   wr_enable_r <= 1'b0;
   dbl_click_cnt <= 20'd0;
   click_cnt <= 3'b000;
   end
 else
   begin
   if (button | click_cnt) // something was clicked
     if (dcl_click_cnt[20]) 
       if (click_cnt == 3'b001)
         wr_enable_r <= 1'b1;
       else
         rd_enable_r <= 1'b1;
       dbl_click_cnt <= 20'd0;
     else 
       begin
         dbl_click_cnt <= dbl_click_cnt + 1'b1;
         rd_enable_r <= 1'b0;
         wr_enable_r <= 1'b0;
       end
   
   if (button)
     click_cnt <= click_cnt + 1'b1;
   else 
    // working on capturing single button press... this doesnt work 
   end

double_click double_clicki (
  .button(button), .single(wr_enable), .double(rd_enable),  .clk(clk), .rst_n(dbl_clck_rst_n)
);



endmodule
