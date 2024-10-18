class mem_scoreboard extends uvm_scoreboard;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
	mem_sequence_item seq_item_queue[$];
	uvm_analysis_imp#(mem_sequence_item, mem_scoreboard)ap_sb_import;
	logic [7:0]shadow_mem[3:0];
	int rd_request=0;
	int rd_addr=0;
	int total_pkts=0;
	int correct=0;
	int incorrect=0;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(mem_scoreboard)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_scoreboard", uvm_component parent=null);
		super.new(name, parent);
		$display("DEBUG::SCOREBOARD-Created");
		for (int i = 0; i < 15; i++) begin
			shadow_mem[i]='d0;
		end
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap_sb_import = new("ap_sb_import", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	function void write(mem_sequence_item seq_item);
		seq_item_queue.push_back(seq_item);
			$display("Write Scoreboard queue_size=%d",seq_item_queue.size());
	endfunction : write

	task run_phase(uvm_phase phase);
		mem_sequence_item my_seq_item;
		forever begin
			// $display("Run Scoreboard queue_size=%d",seq_item_queue.size());
			if (seq_item_queue.size()>0) begin
				total_pkts++;
				my_seq_item = seq_item_queue.pop_front();
				my_seq_item.print();

				if (rd_request) begin
					rd_request = 0;
					if (shadow_mem[rd_addr] == my_seq_item.out_data) begin
						`uvm_info(get_type_name(), "DATA MATCHED", UVM_LOW)
						correct++;
					end
					else begin
						`uvm_error(get_type_name(), "DATA MISMATCHED")
						incorrect++;
					end
				end

				if (my_seq_item.wr_rdn == 'd1) begin
					shadow_mem[my_seq_item.addr] = my_seq_item.in_data;
				end
				else begin
					rd_request = 1;
					rd_addr = my_seq_item.addr;
				end
			end
		end
	endtask : run_phase

	// virtual function void report_phase(uvm_phase phase);
	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("TOTAL_PKTS::%0d", total_pkts), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("TOTAL DATA MATCHED::%0d", correct), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("TOTAL DATA MISMATCHED::%0d", incorrect), UVM_LOW)
	endfunction : report_phase

endclass : mem_scoreboard