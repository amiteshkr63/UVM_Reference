class dutMem_monitorP extends uvm_monitor;
	
	virtual dutMem_interface.IP vif;

	dutMem_sequence_item myMem_seq_item;

	`uvm_component_utils(dutMem_monitorP)

	uvm_analysis_port#(dutMem_sequence_item) monitorP2all;

	function new(string name = "dutMem_monitorP", uvm_component parent = null);			//constructor
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);											//build phase
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dutMem_interface.IP)::get(this, "", "vif_IN", vif )) begin
			`uvm_error(get_type_name(), "handle of interface unavailable")
		end
		monitorP2all = new("monitor2all", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);											//run phase
		logic [`DATA_WIDTH-1:0] mon_rdata;
		bit check;
		check = 0;
		forever begin
			if(vif.reset_n) begin
				@(posedge vif.clk);														
				if(~vif.cb_mon.wr_rd) begin
					myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");
					//if (check) begin
						@(posedge vif.clk);
					//end
					wait(vif.cb_mon.ready);																//waiting for next clock after read signal
					mon_rdata = vif.cb_mon.rdata;											
					myMem_seq_item.data_assign(mon_rdata);											//the output rdata is assigned to the sequence item
					$display($time, "Passive Monitor: Read data");
					myMem_seq_item.print();															//the received data is displayed
					monitorP2all.write(myMem_seq_item);												//writing to analysis port
					check = 0;
				end else check = 1;
			end else begin
				@(posedge vif.clk);
			end

		end
	endtask : run_phase 

endclass : dutMem_monitorP