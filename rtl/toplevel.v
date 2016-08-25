//////////////////////////////////////////////////////////////////////
//
// ORPSoC top for de0_nano board
//
// Instantiates modules, depending on ORPSoC defines file
//
// Copyright (C) 2013 Stefan Kristiansson
//  <stefan.kristiansson@saunalahti.fi
//
// Based on de1 board by
// Franck Jullien, franck.jullien@gmail.com
// Which probably was based on the or1200-generic board by
// Olof Kindgren, which in turn was based on orpsocv2 boards by
// Julius Baxter.
//
//////////////////////////////////////////////////////////////////////
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any
// later version.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.opencores.org/lgpl.shtml
//
//////////////////////////////////////////////////////////////////////

module toplevel (
    input         sys_clk_pad_i,
    input         rst_n_pad_i,
    input         btn_n_pad_i,

    output [1:0]  sdram_ba_pad_o,
    output [12:0] sdram_a_pad_o,
    output        sdram_cs_n_pad_o,
    output        sdram_ras_pad_o,
    output        sdram_cas_pad_o,
    output        sdram_we_pad_o,
    inout  [15:0] sdram_dq_pad_io,
    output [1:0]  sdram_dqm_pad_o,
    output        sdram_cke_pad_o,
    output        sdram_clk_pad_o,

    inout [7:0]   gpio0_io,  /* LEDs */
    input [3:0]   gpio1_i,   /* DIPs */
);

wire clk100m;
wire clk1m;

assign sdram_clk_pad_o = clk100m;

// PLLs
pll_100m pll_100mi (
    .inclk0      (sys_clk_pad_i),
    .c0          (clk100m),
);

pll_1m pll_1mi (
    .inclk0      (sys_clk_pad_i),
    .c0          (clk1m),
);

// Cross Clock FIFOs
/* Address and Data transfers from in:1m out:100m */
fifo wr_fifoi #(.BUS_WIDTH(40)) (
    .clkin         (clk1m),
    .clkout        (clk100m),
    .datain        (),
    .dataout       (),
    .rd            (),
    .wr            (),
    .full          (),
    .empty_n       (),
    .rst_n         ()
);

/* Address transfers from in:1m out:100m */
fifo rdaddr_fifoi #(.BUS_WIDTH(24)) (
    .clkin         (clk1m),
    .clkout        (clk100m),
    .datain        (),
    .dataout       (),
    .rd            (),
    .wr            (),
    .full          (),
    .empty_n       (),
    .rst_n         ()
);

/* Incoming data transfers from in:100m out:1m */
fifo rddata_fifoi #(.BUS_WIDTH(16)) (
    .clkin         (clk100m),
    .clkout        (clk1m),
    .datain        (),
    .dataout       (),
    .rd            (),
    .wr            (),
    .full          (),
    .empty_n       (),
    .rst_n         ()
);


/* SDRAM */

sdram_controller sdram_controlleri (
    /* HOST INTERFACE */
    .wr_addr       (),
    .wr_data       (),
    .wr_enable     (), 

    .rd_addr       (), 
    .rd_data       (),
    .rd_ready      (),
    .rd_enable     (),
    
    .busy          (),
    .rst_n         (rst_n_pad_i),
    .clk           (clk100m),

    /* SDRAM SIDE */
    .addr          (sdram_a_pad_o),
    .bank_addr     (sdram_ba_pad_o),
    .data          (sdram_dq_pad_io),
    .clock_enable  (sdram_cke_pad_o),
    .cs_n          (sdram_cs_n_pad_o),
    .ras_n         (sdram_ras_pad_o),
    .cas_n         (sdram_cas_pad_o),
    .we_n          (sdram_we_pad_o),
    .data_mask_low (sdram_dqm_pad_o[0]),
    .data_mask_high(sdram_dqm_pad_o[1]),
);

dnano_interface dnano_interfacei (
  /* Human Interface */
    .button_n     (), 
    .dip          (),
    .leds         (),

  /* Controller Interface */
    .haddr        (),     // RW-FIFO- data1
    .busy         (),     // RW-FIFO- full
  
    .wr_enable    (),     // WR-FIFO- write
    .wr_data      (),     // WR-FIFO- data2
  
    .rd_enable    (),     // RO-FIFO- write
  
    .rd_data      (),     // RI-FIFO- data
    .rd_rdy       (),     // RI-FIFO-~empty
    .rd_ack       (),     // RI-FIFO- read

  /* basics */
    .rst_n        (rst_n_pad_i), 
    .clk          (clk1m)

);



endmodule // toplevel
