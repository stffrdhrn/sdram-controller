/* De0 Nano interface for testing sdram controller 
 * Handles interpreting buttons and switches 
 * to talk to the sdram controller.
 */

module dnano_interface (
  /* Human Interface */
  button_n, dip, leds,

  /* Controller Interface */
  haddr,     // RW-FIFO- data1
  busy,      // RW-FIFO- full
  
  wr_enable, // WR-FIFO- write
  wr_data,   // WR-FIFO- data2
  
  rd_enable,  //RO-FIFO- write
  
  rd_data,    //RI-FIFO- data
  rd_rdy,    // RI-FIFO-~empty
  rd_ack,    // RI-FIFO- read

  /* basics */
  rst_n, clk

);

parameter HADDR_WIDTH = 24;

// @ 1mhz    19bit (512K) is about 1/2 second
// @ 100mhz  26bit (64M)  is about 1/2 second
localparam DOUBlE_CLICK_WAIT = 19;
localparam LED_BLINK = 20;
 
input        button_n;
input  [3:0] dip;
output [7:0] leds;

output [HADDR_WIDTH-1:0]   haddr;
output [15:0]              wr_data;
input  [15:0]              rd_data;
input                      busy;
output                     rd_enable;
input                      rd_rdy;
output                     rd_ack;
output                     wr_enable;

input                      rst_n;
input                      clk;

wire  [15:0]              wr_data;
reg   [15:0]              rd_data_r;
reg   [LED_BLINK-1:0]     led_cnt;
wire  [7:0]               leds;
wire                      wr_enable;
reg                       rd_ack_r;

wire  dbl_clck_rst_n;

// When to reset the double click output
// we want to reset after we know the sdram is busy
// busy | rst_n
//  0      0     - reset is on  (be-low )
//  0      1     - reset is off (be high)
//  1      0     - busy + reset (be-low)
//  1      1     - busy  is on  (be-low)
assign dbl_clck_rst_n = rst_n & ~busy;

// expand the dip data from 4 to 16 bits
assign wr_data = {dip, dip, ~dip, ~dip};
// toggle leds between sdram msb and lsb
assign leds = led_cnt[LED_BLINK-1] ? rd_data_r[15:8] : rd_data_r[7:0]; 

assign haddr  = {(HADDR_WIDTH/4){dip}};
assign rd_ack = rd_ack_r;

// handle led counter should just loop every half second
always @ (posedge clk) 
 if (~rst_n) 
  led_cnt <= {LED_BLINK{1'b0}};
 else
  led_cnt <= led_cnt + 1'b1;
   

always @ (posedge clk)
 if (~rst_n)
   begin
   rd_data_r <= 16'b0;
   rd_ack_r <= 1'b0;
   end
 else
   begin   
   rd_ack_r <= rd_rdy;
   
   if (rd_rdy)
     rd_data_r <= rd_data;
   else 
     rd_data_r <= rd_data_r;
   end
   
double_click #(.WAIT_WIDTH(DOUBlE_CLICK_WAIT)) double_clicki (
  .button  (~button_n),
  .single  (wr_enable),
  .double  (rd_enable),  
  .clk     (clk),
  .rst_n   (dbl_clck_rst_n)
);

endmodule
