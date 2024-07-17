/******* defining macro for using driver's clocking block signal ******/
`define MON_IF vif.monitor_mp.mon_cb
`define CLK_IF vif.monitor_mp.clk

class monitor extends uvm_monitor;
  
/*******Factory Registrasion*******/
  `uvm_component_utils(monitor)
 
/*******Port Declaration*******/
  uvm_analysis_port#(seq_item) a_port;

/*******Creating Handle of Seq_item Class*******/
  seq_item seq_h;
 
/*******Declaring Virtual Interface *******/
  virtual fifo_interface vif;

  extern function new(string str = "mon_h", uvm_component parent);

  extern virtual function void build_phase(uvm_phase phase);
 
  extern virtual task run_phase(uvm_phase phase); 

  extern task to_pkt();

endclass : monitor

/*******Methods Declaration*******/
function monitor :: new(string str = "mon_h", uvm_component parent);
  super.new(str,parent);
endfunction : new

/*******Methods Declaration*******/
function void monitor :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  a_port = new("a_port",this); 
  `uvm_info("monitor", "monitor build phase", UVM_NONE)
  // Getting interface handle using get method of config db
  if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
    `uvm_fatal("FATAL","monitor_uvm_config_db::get failed")
endfunction : build_phase

/*******Methods Declaration*******/
task monitor ::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("monitor", "monitor run phase", UVM_NONE)
  // Allocating memory to seq item class handle
  seq_h = seq_item::type_id::create("seq_h");
  forever
    begin
      @(`CLK_IF);	
      //writing into fifo if condition is satisfied
      if(`MON_IF.write_en == 1 || `MON_IF.read_en == 1)
        begin
          to_pkt();
          `uvm_info("MONITOR","Packet Received From Interface",UVM_NONE)
          seq_h.print();
          a_port.write(seq_h);
        end
    end
endtask : run_phase 

task monitor::to_pkt();
  seq_h.wdata     = `MON_IF.wdata;
  seq_h.write_en  = `MON_IF.write_en;
  seq_h.read_en   = `MON_IF.read_en;
  seq_h.full      = `MON_IF.full;
  seq_h.amst_full = `MON_IF.amst_full;
  seq_h.rdata     = `MON_IF.rdata;
  seq_h.empty     = `MON_IF.empty;
  seq_h.amst_empty= `MON_IF.amst_empty;
endtask : to_pkt
