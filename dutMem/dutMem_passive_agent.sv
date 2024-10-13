class dutMem_passive_agent extends uvm_agent;


	dutMem_monitorP monitorP;				//monitor handle
	uvm_analysis_port#(dutMem_sequence_item) passive_agent2all;

	`uvm_component_utils(dutMem_passive_agent)

	function new(string name = "dutMem_passive_agent", uvm_component parent = null);				//constructor 
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitorP = dutMem_monitorP::type_id::create("monitorP", this);
		passive_agent2all = new("agent2all", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		monitorP.monitorP2all.connect(passive_agent2all);				//connecting to analysis port of monitor, monitor outside----make changes.
	endfunction : connect_phase
	
endclass : dutMem_passive_agent