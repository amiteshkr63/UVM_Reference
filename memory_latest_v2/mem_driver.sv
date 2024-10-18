class mem_driver extends uvm_driver#(mem_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual mem_intf.DRV dinf;
	mem_sequence_item my_seq_item;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_driver)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_driver", uvm_component parent=null);
		super.new(name, parent);
			$display("DEBUG::DRIVER-Created");

	endfunction : new

	//Phases::Purpose to Synchronize Components of UVM. Phses used in components not in objects.
	//Build Phase::Top Down. Build Big things, then build small things within
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual mem_intf.DRV)::get(this, "", "dinf", dinf)) //The UVM configuration database accessed by the class uvm_config_db is a great way to pass different objects between multiple testbench components.
			`uvm_error(get_type_name(), "handle for driver interface unavailable")
	endfunction : build_phase

	//Connect Phase::Bottom Up. Connect small things to Up, as soon as getting some information regarding small things 
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	//Run Phase::Parallel Operation
	virtual task run_phase(uvm_phase phase);
		forever begin
			@(posedge dinf.clk);
			if (dinf.rst_n) begin
				my_seq_item=mem_sequence_item::type_id::create("my_seq_item");
				seq_item_port.get_next_item(my_seq_item);                     //Getting sequence item from sequencer OUT port(tunnel) which is connected to driver IN PORT i.e., sequence sends the data to IN PORT of sequencer when finish_item called after finishing the start_item call.
				my_seq_item.print();
				dinf.drv_cb.wr_rdn <= my_seq_item.wr_rdn;
				dinf.drv_cb.addr <= my_seq_item.addr;
				dinf.drv_cb.in_data <= my_seq_item.in_data;
				my_seq_item.out_data <= dinf.drv_cb.out_data;
				seq_item_port.item_done();
			end
		end
	endtask : run_phase

endclass : mem_driver