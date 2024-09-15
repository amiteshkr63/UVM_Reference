class dutMem_env extends uvm_env;

	`uvm_component_utils(dutMem_env)						//factory registration

	dutMem_active_agent agentA;
	dutMem_passive_agent agentP;
	dutMem_scoreboard scoreboard;


	function new(string name = "dutMem_env", uvm_component parent = null);				//constructor 
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agentA = dutMem_active_agent::type_id::create("agentA", this);
		agentP = dutMem_passive_agent::type_id::create("agentP", this);
		scoreboard = dutMem_scoreboard::type_id::create("scoreboard", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);											//function
		super.connect_phase(phase);
		agentA.agent2all.connect(scoreboard.analysis_imp_before);
		agentP.passive_agent2all.connect(scoreboard.analysis_imp_after);
	endfunction : connect_phase


//to be moved to test
	/*task reset_phase(uvm_phase phase);												//reset
		vif.sel=0;
		vif.addr=0;
		vif.wr_rd=0;
		vif.wdata=0;
		vif.reset_n=0;
		@(posedge vif.clk);
		vif.reset_n=1;
	endtask : reset_phase*/





endclass : dutMem_env