//////////////////////////////////////////////////////////////////////
//
// toplevel for dram controller de0 nano board
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
    input [3:0]   gpio1_i    /* DIPs */
);

wire clk100m;
wire clk1m;

assign sdram_clk_pad_o = clk100m;

// PLLs
pll_100m pll_100mi (
    .inclk0      (sys_clk_pad_i),
    .c0          (clk100m)
);

pll_1m pll_1mi (
    .inclk0      (sys_clk_pad_i),
    .c0          (clk1m)
);

// Cross Clock FIFOs
/* Address 24-bit and 16-bit Data transfers from in:1m out:100m */

/* 1 mhz side wires */
wire [39:0] wr_fifo;
wire wr_enable;      /* wr_enable ] <-> [ wr : wr_enable to push fifo */
wire wr_full;        /* wr_full   ] <-> [ full : signal that we are full */
/* 100mhz side wires */
wire [39:0] wro_fifo;
wire ctrl_busy;       /* rd ] <-> [ busy : pop fifo when ctrl not busy */
wire ctrl_wr_enable;  /* .empty_n-wr_enable : signal ctrl data is ready */

fifo #(.BUS_WIDTH(40)) wr_fifoi (
    .wr_clk        (clk1m),
    .rd_clk        (clk100m),
    .wr_data       (wr_fifo),
    .rd_data       (wro_fifo),
    .rd            (ctrl_busy),
    .wr            (wr_enable),
    .full          (wr_full),
    .empty_n       (ctrl_wr_enable),
    .rst_n         (rst_n_pad_i)
);

/* Address 24-bit transfers from in:1m out:100m */
/* 1 mhz side wires */
wire        rd_enable;  /*  rd_enable -wr : rd_enable to push rd addr to fifo */
wire        rdaddr_full;/* rdaddr_full-full : signal we cannot read more */

/* 100mhz side wires */
wire [23:0] rdao_fifo;
wire ctrl_rd_enable;     /* empty_n - rd_enable: signal ctrl addr ready */

fifo #(.BUS_WIDTH(24)) rdaddr_fifoi (
    .wr_clk        (clk1m),
    .rd_clk        (clk100m),
    .wr_data       (wr_fifo[39:16]),
    .rd_data       (rdao_fifo),
    .rd            (ctrl_busy),
    .wr            (rd_enable),
    .full          (rdaddr_full),
    .empty_n       (ctrl_rd_enable),
    .rst_n         (rst_n_pad_i)
);

/* 100mhz side wires */
wire [15:0] rddo_fifo;
wire ctrl_rd_ready;     /* wr - rd_ready - push data from dram to fifo */

/* 1mhz side wires */
wire [15:0] rddata_fifo;
wire        rd_ready;   /* rd_ready-empty_n- signal interface data ready */
wire        rd_ack;     /* rd_ack - rd     - pop fifo after data read */

/* Incoming 16-bit data transfers from in:100m out:1m */
fifo #(.BUS_WIDTH(16)) rddata_fifoi (
    .wr_clk        (clk100m),
    .rd_clk        (clk1m),
    .wr_data       (rddo_fifo),
    .rd_data       (rddata_fifo),
    .rd            (rd_ack),
    .wr            (ctrl_rd_ready),
    .full          (),
    .empty_n       (rd_ready),
    .rst_n         (rst_n_pad_i)
);


/* SDRAM */


sdram_controller sdram_controlleri (
    /* HOST INTERFACE */
    .wr_addr       (wro_fifo[39:16]),
    .wr_data       (wro_fifo[15:0]),
    .wr_enable     (ctrl_wr_enable), 

    .rd_addr       (rdao_fifo), 
    .rd_data       (rddo_fifo),
    .rd_ready      (ctrl_rd_ready),
    .rd_enable     (ctrl_rd_enable),
    
    .busy          (ctrl_busy),
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
    .data_mask_high(sdram_dqm_pad_o[1])
);

wire        busy;

assign busy = wr_full | rdaddr_full;

dnano_interface #(.HADDR_WIDTH(24)) dnano_interfacei (
  /* Human Interface */
    .button_n     (btn_n_pad_i), 
    .dip          (gpio1_i),
    .leds         (gpio0_io),

  /* Controller Interface */
    .haddr        (wr_fifo[39:16]),// RW-FIFO- data1
    .busy         (busy),          // RW-FIFO- full
  
    .wr_enable    (wr_enable),     // WR-FIFO- write
    .wr_data      (wr_fifo[15:00]),// WR-FIFO- data2
  
    .rd_enable    (rd_enable),     // RO-FIFO- write
  
    .rd_data      (rddata_fifo),   // RI-FIFO- data
    .rd_rdy       (rd_ready),      // RI-FIFO-~empty
    .rd_ack       (rd_ack),        // RI-FIFO- read

  /* basics */
    .rst_n        (rst_n_pad_i), 
    .clk          (clk1m)

);

endmodule // toplevel
