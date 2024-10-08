class mem_environment extends uvm_env;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_agent agent;
	mem_scoreboard scoreboard;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_environment)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_environment", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	function connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.agent2all(scoreboard.ap_sb_imp);
	endfunction : connect_phase

endclass : mem_environment