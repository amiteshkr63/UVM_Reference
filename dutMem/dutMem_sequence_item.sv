class dutMem_sequence_item extends uvm_sequence_item;
	rand bit sel;
	rand bit wr_rd;
	rand bit [`ADDR_WIDTH-1:0] addr;
	rand bit [`DATA_WIDTH-1:0] wdata;

								//if high sel will be driven low.

	bit [`DATA_WIDTH-1:0] rdata;

	`uvm_object_utils_begin(dutMem_sequence_item)
		`uvm_field_int(sel, UVM_DEFAULT)
		`uvm_field_int(wr_rd, UVM_DEFAULT)
		`uvm_field_int(addr, UVM_DEFAULT)
		`uvm_field_int(wdata, UVM_DEFAULT)
		`uvm_field_int(rdata, UVM_DEFAULT)
	`uvm_object_utils_end

	function new(string name = "dutMem_sequence_item");
		super.new(name);
	endfunction : new

	virtual function void data_assign(ref logic [`DATA_WIDTH-1:0] mon_rdata);
		this.rdata = mon_rdata; 			
	endfunction : data_assign


endclass : dutMem_sequence_item