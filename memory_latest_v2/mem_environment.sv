class mem_environment extends uvm_env;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_agent agent;//test start method name
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
			$display("DEBUG::ENV-Created");

	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = mem_agent::type_id::create("agent", this);
		scoreboard = mem_scoreboard::type_id::create("scoreboard", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.agent2all.connect(scoreboard.ap_sb_import);
			$display("DEBUG::SCO connected to AGENT via ENV");

	endfunction : connect_phase

endclass : mem_environment