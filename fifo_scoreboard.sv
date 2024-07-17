class scoreboard extends uvm_scoreboard;

/*******Factory registeration of scoreboard******/
  `uvm_component_utils(scoreboard)

/*******Properties Declaration*******/
  
  // Creating tlm ports
  uvm_analysis_imp #(seq_item, scoreboard) analysis_imp;
  uvm_blocking_put_imp #(seq_item, scoreboard) imp_port;

  // Creating 2 seq_items for expected and actual
  seq_item expect_seq_h;
  seq_item actual_seq_h;

/*******Methods Prototypes Declaration*******/
  
  extern function new( string name, uvm_component parent );
    
  extern function void build_phase( uvm_phase phase );

  extern task put( seq_item seq_h );

  extern task write( seq_item seq_h );

endclass : scoreboard

/*******Methods Declaration*******/

  function scoreboard::new( string name, uvm_component parent );
  // Passing the object name and parent component type to parent
  super.new( name, parent );
endfunction : new

function void scoreboard::build_phase( uvm_phase phase );
  // Passing the phase instance to parent
  super.build_phase( phase );
  `uvm_info( " Scoreboard ", " Build phase ", UVM_NONE );

  // Building the tlm ports
  analysis_imp = new( "analysis_imp", this );
  imp_port     = new( "imp_port"    , this );
  actual_seq_h = seq_item::type_id::create("actual_seq_h"); 
  expect_seq_h = seq_item::type_id::create("expect_seq_h"); 
endfunction : build_phase

task scoreboard::put( seq_item seq_h );
  if ( seq_h.read_en )
    begin
      this.expect_seq_h = seq_h;
      `uvm_info( " Scoreboard ", " Scoreboard got the read transaction from reference_model ", UVM_NONE )
      `uvm_info( " Scoreboard ", $sformatf( "\n%s", seq_h.sprint() ), UVM_NONE )
    end
  
  if ( seq_h.write_en )
    begin
      // Printing the wdata got from the reference_model
      `uvm_info( " Scoreboard ", " Scoreboard got the write transaction from reference_model ", UVM_NONE )
      `uvm_info( " Scoreboard ", $sformatf( " Written wdata : %0d ", seq_h.wdata ), UVM_NONE );
    end
endtask : put

task scoreboard::write( seq_item seq_h );
  this.actual_seq_h = seq_h;
  
  `uvm_info( " Scoreboard ", " Scoreboard got the transaction from monitor ", UVM_NONE )
  `uvm_info( " Scoreboard ", $sformatf( "\n%s", seq_h.sprint() ), UVM_NONE )
  
  // Matching the expected ( from reference_model ) and actual outputs ( from monitor )
  if ( actual_seq_h.compare( expect_seq_h ) )
    begin
      `uvm_info( " Scoreboard ", " Expected and actual packets match ", UVM_NONE )
    end
  
  if ( actual_seq_h.rdata == expect_seq_h.rdata )
    begin
      `uvm_info( " Scoreboard ", $sformatf( " Read data match : Expected rdata = %0d | Actual rdata = %0d ", expect_seq_h.rdata, actual_seq_h.rdata ), UVM_NONE )
    end
  
  else
    begin
      `uvm_info( " Scoreboard ", $sformatf( " Read data mismatch : Expected rdata = %0d | Actual rdata = %0d ", expect_seq_h.rdata, actual_seq_h.rdata ), UVM_NONE )
    end
endtask : write
