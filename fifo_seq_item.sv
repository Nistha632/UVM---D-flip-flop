class seq_item #( parameter int data_width = 8 ) extends uvm_sequence_item;
  
  //data and Control signals
  rand bit write_en;
  rand bit read_en;
  rand bit [ data_width-1 : 0 ] wdata;
  bit [ data_width-1 : 0 ] rdata;
  bit error;
  bit full;         
  bit amst_full;
  bit empty;
  bit amst_empty;
  int id;
  static int count; 
  
  //Register all properties using field macros
  `uvm_object_utils( seq_item )
  
  // extern new constructor
  extern function new( string name = "seq_item" );
    
    // do_print method
    extern function void do_print(uvm_printer printer);
      
      // constraint
      extern constraint wr_rd_c;
      
endclass : seq_item

/******* Method Body Declaration *******/

function seq_item::new( string name );
  // Passing object name to super.new
  super.new( name );
  id = count++;

endfunction : new
									   
function void seq_item::do_print(uvm_printer printer);
  printer.print_field_int("write_en"    , write_en  , $bits(write_en)    , UVM_DEC);
  printer.print_field_int("read_en"     , read_en   , $bits(read_en)     , UVM_DEC);
  printer.print_field_int("wdata"       , wdata     , $bits(wdata)       , UVM_DEC);
  printer.print_field_int("rdata"       , rdata     , $bits(rdata)       , UVM_DEC);
  printer.print_field_int("full"        , full      , $bits(full)        , UVM_DEC);
  printer.print_field_int("amst_full"   , amst_full , $bits(amst_full)   , UVM_DEC);
  printer.print_field_int("empty"       , empty     , $bits(empty)       , UVM_DEC);
  printer.print_field_int("amst_empty"  , amst_empty, $bits(amst_empty)  , UVM_DEC);
  printer.print_field_int("error"       , error     , $bits(error)       , UVM_BIN);
  printer.print_field_int("count"       , count     , $bits(count)       , UVM_DEC);
  printer.print_field_int("id"          , id        , $bits(id)          , UVM_DEC);
endfunction

constraint seq_item::wr_rd_c { write_en != read_en; };


