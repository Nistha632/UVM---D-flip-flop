
class ref_model #( parameter data_width = 8, fifo_depth = 16 ) extends uvm_component;

  // Factory registration
  `uvm_component_utils(ref_model)
/*******Properties Declaration*******/
  
  // Creating tlm ports instances
  uvm_analysis_imp      #( seq_item, ref_model ) analysis_imp;
  uvm_blocking_put_port #( seq_item, ref_model )     put_port;

  // Creating fifo
  // width of 8 and depth of 16
  // Using bounded queue
  bit [data_width-1 : 0] fifo [$ : fifo_depth-1]; 

  // Creating a queue of transaction packets
  seq_item seq_queue_h [$];

  // Creating a handle of seq_item
  seq_item seq_h;

/*******Methods Prototypes Declaration*******/

  extern function new( string name, uvm_component parent );

  extern function void build_phase( uvm_phase phase );

  extern task run_phase( uvm_phase phase ); 

  extern function void write( seq_item seq_h );

endclass : ref_model

/*******Methods Declaration*******/

function ref_model::new( string name, uvm_component parent );
  // Passing the object name to parent 
  super.new( name, parent );
endfunction : new

function void ref_model::build_phase( uvm_phase phase );
  // Passing phase instance to parent
  super.build_phase( phase );
  `uvm_info( " Reference_model ", " Build phase ", UVM_NONE )

  // Building tlm ports
  analysis_imp = new( "analysis_imp", this );
  put_port     = new( "put_port"    , this );
endfunction : build_phase

task ref_model::run_phase( uvm_phase phase );
  `uvm_info( " Reference_model ", " Run phase ", UVM_NONE )
  forever
    begin
      // Waiting till the packet has been received
      // after that popping that seq_item from queue
      wait( seq_queue_h.size() > 0 );
      seq_h = seq_queue_h.pop_front();
      
      // If write transaction will be initiated then for 
      // the same writing data in fifo
      if ( seq_h.write_en )
        begin
          // If fifo is not full then wdata will be written in fifo
          if ( fifo.size() < fifo_depth )
            begin
              fifo.push_back( seq_h.wdata );
              
              // If fifo size is 15 then almost full flag will be high
              if ( fifo.size() == ( fifo_depth - 1 ) )
                begin
                  seq_h.full       = 0;
                  seq_h.amst_full  = 1;
                  seq_h.empty      = 0;
                  seq_h.amst_empty = 0;
                  seq_h.error      = 0;
                end
            end
          
          // If fifo is full then wdata will not be written in fifo
          // and full and error flag will be high
          else if ( fifo.size() == fifo_depth )
            begin
              seq_h.full       = 1;
              seq_h.amst_full  = 0;
              seq_h.empty      = 0;
              seq_h.amst_empty = 0;
              seq_h.error      = 1;
            end
          
          // Sending the write transaction packet to scoreboard
          put_port.put( seq_h );
        end
      
      // If read transaction will be initiated then for 
      // the same reading data from fifo
      if ( seq_h.read_en )
        begin
          // If fifo is not empty then data will be read from fifo
          if ( fifo.size() > 0 )
            begin
              seq_h.rdata = fifo.pop_front();
              
              // If the fifo size is 1 then almost_empty flag will be high
              if ( fifo.size() == 1 )
                begin
                  seq_h.full       = 0;
                  seq_h.amst_full  = 0;
                  seq_h.empty      = 0;
                  seq_h.amst_empty = 1;
                  seq_h.error      = 0;
                end
            end
          
          // If the fifo is empty then empty and error flag will be high
          else if ( fifo.size() == 0 )
            begin
              seq_h.full       = 0;
              seq_h.amst_full  = 0;
              seq_h.empty      = 1;
              seq_h.amst_empty = 0;
              seq_h.error      = 1;
            end
          
          // Sending the read transaction packet to scoreboard
          put_port.put( seq_h );
        end
    end
endtask : run_phase

function void ref_model::write( seq_item seq_h );
  `uvm_info( " Reference_model ", " ref_model got the transaction ", UVM_NONE )
  //`uvm_info( " Reference_model ", $sformatf( "\n%s", seq_h.sprint() ), UVM_NONE )
  seq_queue_h.push_back( seq_h );
endfunction : write
