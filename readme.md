# _SDRAM Memory Controller_

`Work in progress.` 

Theory is to get a simple controller to work on the De0 Nano

Basic features
 - Operates at 133Mhz, CAS 3, 32MB, 16-bit data
 - on reset will go into `INIT` sequnce
 - The controller sits in `IDLE` waiting for `REFRESH`, `READ` or `WRITE` 
 - `REFRESH` operations are spaced evenly every aprox 400 cycles
 - `READ` is always single read with auto precharge
 - `WRITE` is always single write with auto precharge

```

 Host Interface          SDRAM Interface

   /-----------------------------\
   |      sdram_controller       |
==> haddr                    addr ==>
==> data_input          bank_addr ==>
<== data_output              data <=>
   |                 clock_enable -->
<-- busy                     cs_n -->
--> rd_enable               ras_n -->
--> wr_enable               cas_n -->
   |                         we_n -->
--> rst_n           data_mask_low -->
--> clk            data_mask_high -->
   \-----------------------------/

```

From above most signals should be pretty much self explainatory. Ill list some important points here for now.  It will be expanded on later. 
 - `haddr` is equivelant to `{bank, row, column}`
 - `rd_enable` should be set to high once an address is presented on the `addr` bus and we which to read data. 
 - `wr_enable` should be set to high once `addr` and `data` is presented on the bus
 - `busy` will go high when the read or write command is acknowledged. `busy` will go low when the write or read operation is complete.  In the case of read data should be on the bus for the next posedge.
 - **NOTE** For single reads and writes `wr_enable` and `rd_enable` should be set low once `busy` is observed.  This will protect from the controller thinking another request is needed. 

## Project Status/TODO
 - [x] Compiles
 - [ ] simulated
 - [ ] confirmed in De0 Nano

## Project Setup
This project has been developed with quartus II. 

## License
BSD
