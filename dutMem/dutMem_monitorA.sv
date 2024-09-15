class dutMem_monitorA extends uvm_monitor;
	
	virtual dutMem_interface.IP vif;

	dutMem_sequence_item myMem_seq_item;

	`uvm_component_utils(dutMem_monitorA)

	uvm_analysis_port#(dutMem_sequence_item) monitor2all;

	function new(string name = "dutMem_monitorA", uvm_component parent = null);			//constructor
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);											//build phase
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dutMem_interface.IP)::get(this, "", "vif_IN", vif )) begin
			`uvm_error(get_type_name(), "handle of interface unavailable")
		end
		monitor2all = new("monitor2all", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);											//run phase
		forever begin
			if(vif.reset_n) begin	
				@(posedge vif.clk);														
				if(vif.cb_mon.wr_rd) begin
					myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");
					myMem_seq_item.addr = vif.cb_mon.addr;
					myMem_seq_item.wdata = vif.cb_mon.wdata;
					myMem_seq_item.wr_rd = 'd1;
					$display($time, "Active Monitor: Write Pack");
					myMem_seq_item.print();
					monitor2all.write(myMem_seq_item);
				end else begin
					myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");
					myMem_seq_item.addr = vif.cb_mon.addr;
					myMem_seq_item.wr_rd = 'd0;
					$display($time, "Active Monitor: Read Pack");
					myMem_seq_item.print();
					monitor2all.write(myMem_seq_item);
				end
			end else begin
				@(posedge vif.clk);
			end
				@(posedge vif.clk); 
		end
	endtask : run_phase 

endclass : dutMem_monitorA