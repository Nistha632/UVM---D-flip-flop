class read_seq extends uvm_sequence #(seq_item);
    int uid=1; 
  // Factory registration
  `uvm_object_utils(read_seq)
  
  seq_item req;

/*******Methods Prototype Declaration*******/

    extern function new(string name="read_seq");

    extern virtual task body();

endclass : read_seq
	
/*******Methods Declaration*******/

function read_seq :: new(string name="read_seq");
  super.new(name);
endfunction : new


task read_seq:: body();
  `uvm_info(get_type_name(), $sformatf("******** Generate Read REQs ********"), UVM_LOW)
  req = seq_item :: type_id::create("req");  // Create a new sequence item
 repeat(10) begin
        $display("========================================");
        $display("========================================");
        $display("uid for read sequence = %0d",uid++);
        $display("========================================");
        $display("========================================");
     `uvm_do_with(req, {req.read_en == 1;})
 end
endtask : body
