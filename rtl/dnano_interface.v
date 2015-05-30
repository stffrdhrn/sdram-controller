/* De0 Nano interface for testing sdram controller 
 * Handles interpreting buttons and switches 
 * to talk to the sdram controller.
 */

module dnano_interface (
  /* Human Interface */
  button_n, dip, leds,

  /* Controller Interface */
  haddr, data_input, data_output, busy, rd_enable, wr_enable, 

  /* basics */
  rst_n, clk

);

parameter HADDR_WIDTH = 24;

// @ 1mhz 19bit is about 1/2 second
localparam DOUBlE_CLICK_WAIT = 19;
 
input        button_n;
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

reg   [HADDR_WIDTH-1:0]   haddr;
wire  [15:0]              data_input;
reg   [15:0]              data_output_r;
reg   [20:0]              led_cnt;
wire  [7:0]               leds;
wire                      wr_enable;

wire  dbl_clck_rst_n;
reg   [19:0] dbl_click_cnt;
reg   [2:0] click_cnt;


// When to reset the double click output
// busy | rst_n
//  0      0     - reset is on  (be-low )
//  0      1     - reset is off (be high)
//  1      0     - busy + reset (be-low)
//  1      1     - busy  is on  (be-low)
assign dbl_clck_rst_n = rst_n & ~busy;

// expand the dip data from 4 to 16 bits
assign data_input = {dip, dip, ~dip, ~dip};
// toggle leds between sdram msb and lsb
assign leds = led_cnt[20] ? data_output_r[15:8] : data_output_r[7:0]; 

// handle led counter should just loop every half second
always @ (posedge clk) 
 if (~rst_n) 
  led_cnt <= 21'd0;
 else
  led_cnt <= led_cnt + 1'b1;
   
// when busy goes down, we need to read data on the next clk
//  - busy_sr   - shift register to determine busy neg edge
//  - read      - register to remember that we were reading
//  - data_read - signal saying data should be on the bus (busy done + read)
reg [1:0] busy_sr;
reg       read;
wire data_ready = (read & (busy_sr == 2'b10));

always @ (posedge clk)
 if (~rst_n)
   begin
   busy_sr <= 2'b00;
   read <= 1'b0;
   data_output_r <= 16'b0;
   haddr <= {(HADDR_WIDTH/4){dip}};
   end
 else
   begin
   haddr <= haddr;
   if (rd_enable)
     read <= 1'b1;
   else if (data_ready)
     read <= 1'b0;
   else
     read <= read;
     
   busy_sr <= {busy_sr[0], busy};
   
   if (data_ready)
     data_output_r <= data_output;
   else 
     data_output_r <= data_output_r;
     
   end
   
double_click #(.WAIT_WIDTH(DOUBlE_CLICK_WAIT)) double_clicki (
  .button(~button_n), .single(wr_enable), .double(rd_enable),  .clk(clk), .rst_n(dbl_clck_rst_n)
);



endmodule
