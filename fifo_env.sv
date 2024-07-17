class env extends uvm_env;
  
  // Factory registration
  `uvm_component_utils(env)
  
/*******Properties Declaration*******/
  
  // Creating a handle of agent, reference_model
  // scoreboard and coverage
  agent         agent_h;
  ref_model ref_h;
  scoreboard      scb_h;

/*******Methods Prototypes Declaration*******/

  extern function new( string name, uvm_component parent );

  extern function void build_phase( uvm_phase phase );

  extern function void connect_phase( uvm_phase phase );

endclass : env


/*******Methods Declaration*******/

function env::new( string name, uvm_component parent );
  // Passing the object name and parent component type to parent
  super.new( name, parent );
endfunction : new

function void env::build_phase( uvm_phase phase );
  // Passing the phase instance to parent
  super.build_phase( phase );
  `uvm_info( " Environment ", " Build phase ", UVM_NONE )
  
  // Building 4 components
  // agent, reference_model, scoreboard and coverage
  agent_h = agent           :: type_id :: create( "agent_h", this );
  ref_h   = ref_model :: type_id :: create( "ref_h",   this );
  scb_h   = scoreboard      :: type_id :: create( "scb_h",   this );

  // Setting the agent ( ACTIVE ) configuration
  uvm_config_db #( int ) :: set ( this, "uvm_test_top.env_h.agent_h", "is_active", UVM_ACTIVE );
endfunction : build_phase

function void env::connect_phase( uvm_phase phase );
  // Passing the phase insatance to parent
  super.connect_phase( phase );
  `uvm_info( " Environment ", " Connect phase ", UVM_NONE )
  
  // Connecting the agent with reference_model, scoreboard and coverage
  agent_h.analysis_export.connect( ref_h.analysis_imp );
  agent_h.analysis_export.connect( scb_h.analysis_imp );
  ref_h.put_port.connect(scb_h.imp_port);
endfunction : connect_phase
