
class sequencer extends uvm_sequencer#(seq_item);
	
/*******factory registration*******/
	`uvm_component_utils(sequencer)
	
/*******Methods Prototypes Declaration*******/
  
  function new(string name="sequencer", uvm_component parent=null);
    super.new(name, parent);
endfunction : new

  endclass : sequencer



