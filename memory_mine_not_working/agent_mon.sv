class agent_mon extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_out_monitor mem_out_monitor_handle;
	uvm_analysis_port#(mem_seq_itm) ap;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(agent_mon)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "agent_mon", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	//Build Phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	    mem_out_monitor_handle = mem_out_monitor::type_id::create("mem_out_monitor_handle", this);
	    ap = new("ap", this);
	endfunction : build_phase

	//Build Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mem_out_monitor_handle.ap.connect(ap);
	endfunction : connect_phase
endclass : agent_mon