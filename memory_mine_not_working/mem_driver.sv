class mem_driver extends uvm_driver#(mem_seq_itm);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual mem_interface.driver_mp driver_intf_handle;		//field
	mem_seq_itm mem_seq_itm_handle;	
/*	mem_seq mem_seq_handle;*/
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
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual mem_interface.driver_mp)::get(this, "", "drvrvif",driver_intf_handle )) begin
			`uvm_fatal(get_type_name(), "Driver Interface not found");
		end
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
					
		forever begin
			mem_seq_itm_handle=mem_seq_itm::type_id::create("mem_seq_itm_handle");
			seq_item_port.get_next_item(mem_seq_itm_handle);
			@(driver_intf_handle.driver_cb);
			mem_seq_itm_handle.print();
			driver_intf_handle.driver_cb.SEL<=1;
			driver_intf_handle.driver_cb.WR_RDbar<=mem_seq_itm_handle.WR_RDbar;
			driver_intf_handle.driver_cb.ADDR<=mem_seq_itm_handle.ADDR;
			driver_intf_handle.driver_cb.WDATA<=mem_seq_itm_handle.WDATA;
			repeat(mem_seq_itm_handle.delay) @(driver_intf_handle.driver_cb);
			seq_item_port.item_done();

		end
	endtask : run_phase
endclass : mem_driver