`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)
class dutMem_scoreboard extends uvm_scoreboard;
	int correct;
	`uvm_component_utils(dutMem_scoreboard)								//factory registration
	dutMem_sequence_item read_addr_queue[$];						//queue to store driven data
	dutMem_sequence_item read_data_queue[$];

	uvm_analysis_imp_before#(dutMem_sequence_item, dutMem_scoreboard) analysis_imp_before; 
	uvm_analysis_imp_after#(dutMem_sequence_item, dutMem_scoreboard) analysis_imp_after;	

	reg [`DATA_WIDTH-1:0] shadow_mem [`DEPTH-1:0];	

	function new(string name = "dutMem_scoreboard", uvm_component parent = null );
		super.new(name, parent);
		for (int i = 0; i < `DEPTH; i++) begin
			shadow_mem[i] = `RESET_VALUE;
		end
		correct =0;
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysis_imp_before = new("analysis_imp_before", this);
		analysis_imp_after = new("analysis_imp_after", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);											//function
		super.connect_phase(phase);
	endfunction : connect_phase

	function void write_before(dutMem_sequence_item myMem_seq_item);
		if (myMem_seq_item.wr_rd) begin
			shadow_mem[myMem_seq_item.addr] = myMem_seq_item.wdata;
		end else begin
			read_addr_queue.push_back(myMem_seq_item);
		end
	endfunction : write_before


	function void write_after(dutMem_sequence_item myMem_seq_item);
			read_data_queue.push_back(myMem_seq_item);
	endfunction : write_after

	task run_phase(uvm_phase phase);
		dutMem_sequence_item addr_item;
		dutMem_sequence_item data_item;
		logic [`DATA_WIDTH-1:0] expected_data;
		forever begin
			wait((read_addr_queue.size() > 0) && (read_data_queue.size() >0));				//waiting for the queses to have some data
			if((read_addr_queue.size() > 0) && (read_data_queue.size() >0)) begin			//if the queses have data
				data_item = read_data_queue.pop_front();										//poping an item from each queue
				addr_item = read_addr_queue.pop_front();
				expected_data = shadow_mem[addr_item.addr];										//transforming the data from the data queue
				if(expected_data == data_item.rdata) begin													//comparing data from sum queue and reference model
					data_item.print();
					addr_item.print();
					`uvm_info (get_type_name(), "Operation Correct", UVM_LOW)
					correct++;
				end else begin
					data_item.print();
					addr_item.print();
					`uvm_error (get_type_name(), "Operation Incorrect")			///////////////change to uvm_error
				end
			end
		end
	endtask : run_phase

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),$sformatf("Total correct results: %0d",correct), UVM_MEDIUM)
	endfunction : report_phase

endclass : dutMem_scoreboard