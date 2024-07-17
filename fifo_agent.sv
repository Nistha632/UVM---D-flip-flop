class agent extends uvm_agent;

  // Factory registration
  `uvm_component_utils(agent)
/*******Properties Declaration*******/
  
  // Creating a handle of sequencer, driver and monitor
  sequencer seqr_h;
  driver     drv_h;
  monitor    mon_h;

  // Creating a tlm port handle
  uvm_analysis_export #(seq_item) analysis_export;

/*******Methods Prototypes Declaration*******/

  extern function new( string name, uvm_component parent );

  extern function void build_phase( uvm_phase phase );

  extern function void connect_phase( uvm_phase phase );

endclass : agent

/*******Methods Declaration*******/

function agent::new( string name, uvm_component parent );
  // Passing the object name and parent component type to parent
  super.new( name, parent );
endfunction : new

function void agent::build_phase( uvm_phase phase );
  // Passing the phase instance to parent
  super.build_phase( phase );
  `uvm_info( " Agent ", " Build phase ", UVM_NONE )
    
  // Building the sequencer, driver and monitor
  seqr_h = sequencer :: type_id :: create( "seqr_h", this );
  drv_h  = driver    :: type_id :: create( "drv_h",  this );
  mon_h  = monitor   :: type_id :: create( "mon_h",  this );

  // Building the tlm port
  analysis_export = new( "analysis_export", this );
endfunction : build_phase

function void agent::connect_phase( uvm_phase phase );
  // Passing the phase instance to parent
  super.connect_phase( phase );
  `uvm_info( " Agent ", " Connect phase ", UVM_NONE )
    
  // Connecting sequencer with driver and
  // monitor analysis port to agent export
  drv_h.seq_item_port.connect( seqr_h.seq_item_export );
  mon_h.a_port.connect( analysis_export );
endfunction : connect_phase
