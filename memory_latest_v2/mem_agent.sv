typedef uvm_sequencer#(mem_sequence_item) mem_sequencer;
//sequencer is having one PORT, that will accept only data of type mem_sequence_item
//sequence generates a sequence item, it will be caught by sequencer and via sequencer, sequence item will be sent to driver.

class mem_agent extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_driver driver;
	mem_sequencer sequencer;//test start method name
	mem_monitor monitor;
	uvm_analysis_port#(mem_sequence_item) agent2all;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_agent", uvm_component parent=null);
		super.new(name, parent);
		$display("DEBUG::AGENT-Created");
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sequencer = mem_sequencer::type_id::create("sequencer", this);
		driver = mem_driver::type_id::create("driver", this);
		monitor = mem_monitor::type_id::create("monitor", this);
		agent2all = new("agent2all", this);
		$display("DEBUG::SEQUENCER-Created");
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
		monitor.monitor2all.connect(agent2all);
		$display("DEBUG::DRIVER and MONITOR ports are connected to AGENT");
	endfunction : connect_phase

endclass : mem_agent
