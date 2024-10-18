class mem_sequence_item extends uvm_sequence_item;
	rand bit wr_rdn;
	rand bit [3:0]addr;
	rand bit [7:0]in_data;
	bit [7:0]out_data;

	`uvm_object_utils_begin(mem_sequence_item)
		`uvm_field_int(wr_rdn, UVM_DEFAULT)
		`uvm_field_int(addr, UVM_DEFAULT)
		`uvm_field_int(in_data, UVM_DEFAULT)
		`uvm_field_int(out_data, UVM_DEFAULT)
	`uvm_object_utils_end

	function new(string name = "mem_sequence_item");
		super.new(name);
			$display("DEBUG::SEQUENCE_ITEM-Created");
	endfunction : new

endclass : mem_sequence_item