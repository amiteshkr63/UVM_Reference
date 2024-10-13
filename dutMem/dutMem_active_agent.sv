typedef uvm_sequencer#(dutMem_sequence_item) dutMem_sequencer;
class dutMem_active_agent extends uvm_agent;

	dutMem_driver driver;				//driver handle
	dutMem_sequencer sequencer;			//sequencer handle
	dutMem_monitorA monitorA;				//monitor handle
	uvm_analysis_port#(dutMem_sequence_item) agent2all;

	`uvm_component_utils(dutMem_active_agent)

	function new(string name = "dutMem_agent", uvm_component parent = null);				//constructor 
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		driver = dutMem_driver::type_id::create("driver", this);
		sequencer = dutMem_sequencer::type_id::create("sequencer", this);
		monitorA = dutMem_monitorA::type_id::create("monitorA", this);
		agent2all = new("agent2all", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);   					//this required to connect to the sequencer
		monitorA.monitor2all.connect(agent2all);												//connecting to analysis port of monitor, monitor outside----make changes.
	endfunction : connect_phase
	
endclass : dutMem_active_agent