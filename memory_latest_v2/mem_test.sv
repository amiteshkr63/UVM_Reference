class mem_test extends uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_environment environment;//test start method name

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_test)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		environment = mem_environment::type_id::create("environment", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

//Objective:: To run the sequence, we have to create a object for sequence,
//Run phase is a Time consuming Phase and its running parallely for all the components. Once the run phase is completed your test is done
//In order to have synchronization in run phase of all components i.e.,Driver, Monitor, etc
//For sync in Run_Phase we have to use "OBJECTIONS"  
	virtual task run_phase(uvm_phase phase);
		mem_sequence my_seq;
		phase.raise_objection(this);//Blocking
		$display("DEBUG::Run in test");
			my_seq = mem_sequence::type_id::create("my_seq", this);
		$display("DEBUG::Run in test Sequence Object Created");
			my_seq.randomize(); //does the randomization of sequence class if something declared as rand in sequence class
		$display("DEBUG::Run in test Sequence Randomization Request Done");
			my_seq.print();
			//my_seq.total_pkts=10;
			#5; my_seq.start(environment.agent.sequencer);
			//Calling a sequence to start or run on the sequencer and it will be establishing the handshake mechanism between driver and sequencer 
		$display("DEBUG::Run in test Sequencer Started");
			//body task of sequence is called from here.
			phase.phase_done.set_drain_time(this, 35);
		phase.drop_objection(this);//Blocking
	endtask : run_phase

endclass : mem_test