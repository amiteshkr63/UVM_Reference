class mem_seq_itm extends uvm_sequence_item;
	rand bit [7:0]ADDR;
	rand bit [15:0]WDATA;
	rand bit WR_RDbar;
	rand int delay;
	bit [15:0]RDATA;
	bit READY;

	`uvm_object_utils_begin(mem_seq_itm)
		`uvm_field_int(ADDR, UVM_DEFAULT)
		`uvm_field_int(WDATA, UVM_DEFAULT)
		`uvm_field_int(RDATA, UVM_DEFAULT)
		`uvm_field_int(WR_RDbar, UVM_DEFAULT)
		`uvm_field_int(delay, UVM_DEFAULT)
		`uvm_field_int(READY, UVM_DEFAULT)
	`uvm_object_utils_end

	function new(string name = "mem_seq_itm");
		super.new(name);
	endfunction : new

endclass : mem_seq_itm