class dutMem_sequence extends uvm_sequence#(dutMem_sequence_item);
	rand bit sel_test;	
	int no_of_pkts;


	dutMem_sequence_item myMem_seq_item;

	`uvm_object_utils(dutMem_sequence)

	function new(string name = "dutMem_sequence");
		super.new(name);
		if (!$value$plusargs("no_of_pkts=%d",no_of_pkts)) begin
			no_of_pkts = 5;
		end
	endfunction : new

	virtual task body();
		repeat(no_of_pkts) begin
			myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");

			start_item(myMem_seq_item);	
				if (sel_test) begin
					assert(myMem_seq_item.randomize() with {sel == 0;});
				end	else begin
					assert(myMem_seq_item.randomize() with {sel == 1;});
				end
			finish_item(myMem_seq_item);	
		end
	endtask : body

endclass : dutMem_sequence

class dutMem_sequence_kaddr extends dutMem_sequence;
	`uvm_object_utils(dutMem_sequence_kaddr)

	bit [`ADDR_WIDTH-1:0] written_addr [];
	virtual task body();
		myMem_seq_item = dutMem_sequence_item::type_id::create("myMem_seq_item");
		start_item(myMem_seq_item);
			assert(myMem_seq_item.randomize() with {if (~wr_rd) addr inside written_addr;  solve wr_rd before addr;});
			if(myMem_seq_item.wr_rd) begin
				written_addr = new[written_addr.size()+1](written_addr);
				written_addr[written_addr.size()-1]= myMem_seq_item.addr;
			end
		finish_item(myMem_seq_item);
	endtask : body
	
endclass : dutMem_sequence_kaddr

