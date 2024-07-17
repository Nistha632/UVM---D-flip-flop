
/******* defining macro for using driver's clocking block signal ******/
`define DRIV_IF vif.driver_mp.drv_cb;

/****** defining macro for using clock signal defined in driver MODPORT *****/
`define CLK_IF vif.driver_mp.clk

class driver extends uvm_driver #(seq_item);
  
  // Creating instance of ei_seq_item_c class
  seq_item seq_h;

  // Registration driver class to Factory
  `uvm_component_utils(driver)
  
  // Creating instance of interface
  virtual fifo_interface vif;
  
  extern function new(string name = "driver",uvm_component parent = null);
    
  extern function void build_phase(uvm_phase phase);
    
  extern virtual task run_phase(uvm_phase phase);
  extern         task drive_t();

endclass:driver

/*******Methods Declaration*******/
function driver :: new(string name = "driver",uvm_component parent = null);
  super.new(name,parent);
endfunction:new

/*******Methods Declaration*******/
function void  driver :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("DRV","Inside driver",UVM_NONE)
  // Allocating memory to seq item class handle
  seq_h = seq_item :: type_id :: create("seq_h");
  // Getting interface handle using get method of config db
  if(!uvm_config_db #(virtual fifo_interface) :: get(this,"","vif",vif))
    `uvm_fatal("NO VIF IS PRESENT",{"Virtual interface must be set for:",get_full_name(),".vif"})
endfunction : build_phase

/*******Methods Declaration*******/
task driver :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever 
    begin
      // Getting item from sequencer in seq_item class handle
      seq_item_port.get_next_item(seq_h);
      `uvm_info(get_type_name(),"PACKET RECEIVED :-",UVM_NONE)
		
      // Priting the packet received from sequencer
      //seq_h.print();

      // Calling driver_t task  
      drive_t();

      @(posedge `CLK_IF);
      seq_item_port.item_done();
        seq_h.print();  
    end
endtask : run_phase

/*******Methods Declaration*******/
task driver::drive_t();
  
  // If write_en signal high, then converting write operation related signals to pin level
  if(seq_h.write_en)
    begin
      @(posedge `CLK_IF);
      vif.write_en  <= seq_h.write_en;
      vif.wdata     <= seq_h.wdata;
   end
  
  // If read_en signals high, then converting read operation releated signals to pin level
  else if (seq_h.read_en)
    begin
      vif.read_en    <= seq_h.read_en;
    end

endtask : drive_t
