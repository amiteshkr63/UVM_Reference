class mem_test extends uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_environment mem_environment_handle;
/*	
	virtual mem_interface.driver_mp drvrvif; //Value
	virtual mem_interface.monitor_mp monvif; //Value
*/
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	//Build phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mem_environment_handle=mem_environment::type_id::create("mem_environment_handle", this);

/*        uvm_config_db#(virtual mem_interface.driver_mp)::set(this, "*", "drvrvif", drvrvif);
        								//Field   Value
        //All field named with "vif" are going to be connected.
		
		uvm_config_db#(virtual mem_interface.monitor_mp)::get(this, "", "monvif", monvif);*/

	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		mem_seq mem_seq_handle;
		mem_seq_handle=mem_seq::type_id::create("mem_seq_handle");
		phase.raise_objection(this);
			mem_seq_handle.randomize();
			mem_seq_handle.start(mem_environment_handle.agent_drv_mon_handle.mem_sequencer);
		phase.drop_objection(this);
	endtask : run_phase

endclass : mem_test