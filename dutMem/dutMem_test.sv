class dutMem_test extends uvm_test;
	`uvm_component_utils(dutMem_test)

	dutMem_env env;

	function new(string name = "dutMem_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = dutMem_env::type_id::create("env", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		dutMem_sequence seq;
		phase.raise_objection(this);
			seq = dutMem_sequence::type_id::create("seq");
			assert(seq.randomize() with {sel_test == 0;});		 						//does the randomization part only in sequence class
			seq.start(env.agentA.sequencer);					//creates the handshake mechanism btwn driver and sequencer
			phase.phase_done.set_drain_time(this, 35);
		phase.drop_objection(this);						//run_phase ends here
	endtask : run_phase
endclass : dutMem_test