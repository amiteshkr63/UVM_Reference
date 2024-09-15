class mem_driver_monitor extends uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual mem_interface.monitor_mp driver_monitor_intf_handle;
	
	//virtual mem_interface.driver_mp driver_intf_handle;

	mem_seq_itm mem_seq_itm_handle;
	uvm_analysis_port#(mem_seq_itm) ap;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_driver_monitor)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_driver_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual mem_interface.monitor_mp)::get(this, "", "monvif",driver_monitor_intf_handle )) begin
			`uvm_fatal(get_type_name(), "Driver Interface not found");
		end
		ap=new("ap", this);
	endfunction : build_phase

	//Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	//Run Phase
	virtual task run_phase(uvm_phase phase);
		forever begin
			mem_seq_itm_handle=mem_seq_itm::type_id::create("mem_seq_itm_handle");
			wait(driver_monitor_intf_handle.monitor_cb.READY & driver_monitor_intf_handle.monitor_cb.SEL);
			@(driver_monitor_intf_handle.monitor_cb);
			mem_seq_itm_handle.WR_RDbar=driver_monitor_intf_handle.monitor_cb.WR_RDbar;
			@(driver_monitor_intf_handle.monitor_cb);		//Giving enough time if read is asserted 
			mem_seq_itm_handle.ADDR=driver_monitor_intf_handle.monitor_cb.ADDR;
			@(driver_monitor_intf_handle.monitor_cb);		//Giving enough time if while in read address changed 
			if (driver_monitor_intf_handle.monitor_cb.WR_RDbar) begin
				mem_seq_itm_handle.WDATA=driver_monitor_intf_handle.monitor_cb.WDATA;
			end
			`uvm_info("Driver_monitor", $sformatf("WR_RDbar: %0d, ADDR: %0d, WDATA: %0d", mem_seq_itm_handle.WR_RDbar, mem_seq_itm_handle.ADDR, mem_seq_itm_handle.WDATA), UVM_MEDIUM)
			ap.write(mem_seq_itm_handle);
		end
	endtask : run_phase
endclass : mem_driver_monitor