class dutMem_driver extends uvm_driver#(dutMem_sequence_item);
	
	virtual dutMem_interface.MP vif;

	dutMem_sequence_item myMem_seq_item;

	`uvm_component_utils(dutMem_driver)

	function new(string name = "dutMem_driver", uvm_component parent = null);
			super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dutMem_interface.MP)::get(this, "", "vif", vif )) begin
			`uvm_error(get_type_name(), "handle of interface unavailable")
		end
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		reg rdCheck=0;
		forever begin
			@(posedge vif.clk);
			if(vif.reset_n) begin
				myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");
				seq_item_port.get_next_item(myMem_seq_item);
				myMem_seq_item.print();

				if(myMem_seq_item.wr_rd) begin						//if write command then
					wait(vif.cb.ready);								//waiting for ready to be high
					if (rdCheck) begin								//if last txn was read, wait for next clock
						@(posedge vif.clk);
					end
					vif.cb.sel <= myMem_seq_item.sel;
					vif.cb.wr_rd <= myMem_seq_item.wr_rd;
					vif.cb.addr <= myMem_seq_item.addr;
					vif.cb.wdata <= myMem_seq_item.wdata;
					rdCheck = ~myMem_seq_item.wr_rd;				//setting rdCheck high only if read txn
				end else begin  									//if read command then
					wait(vif.cb.ready);								//waiting for ready to be high
					if (rdCheck) begin								//if last txn was read, wait for next clock
						@(posedge vif.clk);
					end
					vif.cb.sel <= myMem_seq_item.sel;		
					vif.cb.wr_rd <= myMem_seq_item.wr_rd;
					vif.cb.addr <= myMem_seq_item.addr;
					vif.cb.wdata <= 'dz;
					rdCheck = ~myMem_seq_item.wr_rd;
				end
				seq_item_port.item_done();
			end
		end
	endtask
endclass : dutMem_driver

