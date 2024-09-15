class mem_environment extends uvm_env;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_scoreboard mem_scoreboard_handle;
	agent_drv_mon agent_drv_mon_handle; 
	agent_mon agent_mon_handle; 
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

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mem_scoreboard_handle = mem_scoreboard::type_id::create("mem_scoreboard_handle", this);
		agent_drv_mon_handle = agent_drv_mon::type_id::create("agent_drv_mon_handle", this);
		agent_mon_handle = agent_mon::type_id::create("agent_mon_handle", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent_drv_mon_handle.ap.connect(mem_scoreboard_handle.before_export);
		agent_mon_handle.ap.connect(mem_scoreboard_handle.after_export);
	endfunction : connect_phase

endclass : mem_environment