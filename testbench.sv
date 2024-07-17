import uvm_pkg :: *;
`include "uvm_macros.svh"

`include "interface.sv"
`include "dut.sv"
`include "seq_item.sv"
`include "write_seq.sv"
`include "read_seq.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "ref_model.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "base_test.sv"
`include "write_test.sv"
`include "read_test.sv"
`include "write_read_test.sv"
`include "read_write_test.sv"

module top();
  
  bit clk, rst;
  
  fifo_interface pif( .clk(clk), .rst(rst) );
  
  sync_fifo #(.DATA_WIDTH(8), .DEPTH(16)) dut(
    .clk(pif.clk),
    .rst(pif.rst),
    .write_en(pif.write_en),
    .read_en(pif.read_en),
    .wdata(pif.wdata),
    .rdata(pif.rdata),
    .full(pif.full),
    .empty(pif.empty),
    .error(pif.error),
    .amst_full(pif.amst_full),
    .amst_empty(pif.amst_empty)
  );
  
  initial
    begin
      clk = 0;
      forever #5 clk = ~clk ;
    end
  initial
    begin
      rst = 1;
      #3;
      rst = 0;
      #1000 $finish;
    end
  
  initial
    begin
      uvm_config_db#( virtual fifo_interface )::set(null, "*", "vif", pif );
    end
  
  initial
    begin
      run_test("base_test");
    end
  
endmodule : top 
