class mem_monitor extends uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual mem_intf.MON minf;
	mem_sequence_item my_seq_item;
	uvm_analysis_port#(mem_sequence_item) monitor2all;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_monitor)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	//Phases::Purpose to Synchronize Components of UVM. Phses used in components not in objects.
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual mem_intf.MON)::get(this, "", "minf", minf)) //The UVM configuration database accessed by the class uvm_config_db is a great way to pass different objects between multiple testbench components.
			`uvm_error(get_type_name(), "handle for monitor interface unavailable")
			monitor2all = new("monitor2all", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		forever begin
			if (minf.rst_n) begin
				@(posedge minf.clk);
				my_seq_item=mem_sequence_item::type_id::create("my_seq_item");
				my_seq_item.wr_rdn = minf.mon_cb.wr_rdn;
				my_seq_item.addr = minf.mon_cb.addr;
				my_seq_item.in_data = minf.mon_cb.in_data;
				my_seq_item.out_data = minf.mon_cb.out_data;
				my_seq_item.print();
				monitor2all.write(my_seq_item); //Writing sequence item into analysis port//Write function will be declared where this analysis port has to be connected
			end
			else begin
				@(posedge minf.clk);
			end
		end
	endtask : run_phase

endclass : mem_monitor