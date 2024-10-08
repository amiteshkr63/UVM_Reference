typedef uvm_sequencer#(mem_sequence_item) mem_sequencer;
//sequencer is having one PORT, that will accept only data of type mem_sequence_item
//sequence generates a sequence item, it will be caught by sequecer and via sequencer, sequence item will be sent to driver.

class mem_agent extends uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_sequencer sequencer;
	mem_driver driver;
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
	endfunction : new

	function build_phase(uvm_phase phase);
		super.build(phase);
		sequencer = mem_sequencer::type_id::create("sequencer", this);
		driver = mem_driver::type_id::create("driver", this);
		monitor = mem_monitor::type_id::create("monitor", this);
		agent2all = new("agent2all", this);
	endfunction : build_phase

	function connect_phase(uvm_phase phase);
		super.connect(phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
		monitor.monitor2all.connect(agent2all);
	endfunction : connect_phase

endclass : mem_agent
