class mem_out_monitor extends uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual mem_interface.monitor_mp monitor_intf_handle;

	mem_seq_itm mem_seq_itm_handle;
	uvm_analysis_port#(mem_seq_itm) ap;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_out_monitor)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_out_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual mem_interface.monitor_mp)::get(this, "", "monvif", monitor_intf_handle )) begin
			`uvm_fatal(get_type_name(), "Driver Interface not found");
		end
	    ap = new("ap", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		forever begin
			mem_seq_itm_handle=mem_seq_itm::type_id::create("mem_seq_itm_handle");
			wait(monitor_intf_handle.monitor_cb.READY & monitor_intf_handle.monitor_cb.SEL);
			@(monitor_intf_handle.monitor_cb);
			mem_seq_itm_handle.RDATA=monitor_intf_handle.monitor_cb.RDATA;
			mem_seq_itm_handle.READY=monitor_intf_handle.monitor_cb.READY;
			`uvm_info("Driver_monitor", $sformatf("READY: %0d, RDATA: %0d", mem_seq_itm_handle.READY, mem_seq_itm_handle.RDATA), UVM_MEDIUM)
			ap.write(mem_seq_itm_handle);	
		end
	endtask : run_phase
endclass : mem_out_monitor