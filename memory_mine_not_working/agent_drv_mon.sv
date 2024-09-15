typedef uvm_sequencer#(mem_seq_itm) sequencer;
class agent_drv_mon extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_driver mem_driver_handle;
	mem_driver_monitor mem_driver_monitor_handle;
	sequencer mem_sequencer;
	uvm_analysis_port#(mem_seq_itm) ap;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(agent_drv_mon)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "agent_drv_mon", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	//Build Phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	    mem_driver_handle = mem_driver::type_id::create("mem_driver_handle", this);
	    mem_sequencer = sequencer::type_id::create("mem_sequencer", this);
	    mem_driver_monitor_handle = mem_driver_monitor::type_id::create("mem_driver_monitor_handle", this);
	    ap = new("ap", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mem_driver_monitor_handle.ap.connect(ap);
		mem_driver_handle.seq_item_port.connect(mem_sequencer.seq_item_export);
	endfunction : connect_phase
endclass : agent_drv_mon