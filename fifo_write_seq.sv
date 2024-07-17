
class write_seq extends uvm_sequence #(seq_item);
    int uid=1;
  // Factory registration
  `uvm_object_utils(write_seq)
  
  seq_item req;

/*******Methods Prototype Declaration*******/

    extern function new(string name="write_seq");

    extern virtual task body();

endclass : write_seq
	
/*******Methods Declaration*******/

function write_seq :: new(string name="write_seq");
  super.new(name);
endfunction : new


task write_seq :: body();
  `uvm_info(get_type_name(), $sformatf("******** Generate Write REQ ********"), UVM_LOW)
  req = seq_item :: type_id :: create("req");  // Create a new sequence item
    repeat(10) begin
        $display("========================================");
        $display("========================================");
        $display("uid for write sequence = %0d",uid++);
        $display("========================================");
        $display("========================================");
        `uvm_do_with(req, {req.write_en == 1;})
    end
endtask : body
