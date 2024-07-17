
`define DATA_WIDTH 8

interface fifo_interface(input bit clk, input bit rst);
  
  /*******Properties Declaration*******/

  logic [`DATA_WIDTH-1:0] wdata;  // Data to be written to the FIFO
  logic [`DATA_WIDTH-1:0] rdata;  // Data read from the FIFO

  logic write_en;  // Write enable signal
  logic read_en;  // Read enable signal

  logic empty;  // Empty status of the FIFO
  logic amst_full;  // Almost full status of the FIFO
  logic amst_empty;  // Almost empty status of the FIFO
  logic full;  // Full status of the FIFO
  logic error;  // Error status of the FIFO

clocking drv_cb@(posedge clk);  // Clocking block for the driver interface
  output write_en;
  output read_en;
  input amst_full;
  input amst_empty;
  input error;
    
  output wdata;
  input rdata;
  input full;
  input empty;
endclocking : drv_cb

clocking mon_cb @(posedge clk);  // Clocking block for the monitor interface
  input write_en;
  input read_en;
  input amst_full;
  input amst_empty;

  input error;

  input wdata;
  input rdata;
  input full;    
  input empty;
endclocking : mon_cb

modport driver_mp(clocking drv_cb, input clk, rst);  // Modport for the driver interface

modport monitor_mp(clocking mon_cb, input clk, rst);  // Modport for the monitor interface

endinterface : fifo_interface
