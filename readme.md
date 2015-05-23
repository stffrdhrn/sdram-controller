# _SDRAM Memory Controller_

`Work in progress.` 

Theory is to get a simple controller to work on the De0 Nano

Basic features
 - Operates at 133Mhz, CAS 3, 32MB, 16-bit data
 - On reset will go into `INIT` sequnce
 - After `INIT` the controller sits in `IDLE` waiting for `REFRESH`, `READ` or `WRITE` 
 - `REFRESH` operations are spaced evenly 8192 times every 32ms
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

From tje above diafram most signals should be pretty much self explainatory. Here are some important points for now.  It will be expanded on later. 
 - `haddr` is equivelant to the concatenation of `{bank, row, column}`
 - `rd_enable` should be set to high once an address is presented on the `addr` bus and we wish to read data. 
 - `wr_enable` should be set to high once `addr` and `data` is presented on the bus
 - `busy` will go high when the read or write command is acknowledged. `busy` will go low when the write or read operation is complete.  In the case of read data should be on the bus for the next posedge.
 - **NOTE** For single reads and writes `wr_enable` and `rd_enable` should be set low once `busy` is observed.  This will protect from the controller thinking another request is needed. 

## Project Status/TODO
 - [x] Compiles
 - [x] Simulated `Init`
 - [x] Simulated `Refresh`
 - [x] Simulated `Read`
 - [x] Simulated `Write`
 - [ ] Confirmed in De0 Nano

 - Found a race condition when the host starts a read/write operation on the 
   negedge of clk.  The controller switched to read/write state before capturing
   the address.  This causes an incorrect address to be put on the bus for RAS.


## Project Setup
This project has been developed with altera quartus II. 

## License
BSD
