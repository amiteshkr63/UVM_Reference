class mem_sequence extends uvm_sequence#(mem_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
	int total_pkts;
	//rand int oprtn_type; 
	mem_sequence_item my_seq_item;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(mem_sequence)
	//Segmentation error because sequence registered in uvm as component and in new method passing another component as "uvm_component parent=null"

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_sequence");
		super.new(name);
		total_pkts = 10;
		$display("DEBUG::SEQUENCE-Created");
		$display("total_pkts=%0d", total_pkts);
	endfunction : new

	virtual task body();
			$display("DEBUG::Inside Sequence Body SEQUENCE total_pkts=%0d", total_pkts);
		repeat(total_pkts) begin
			my_seq_item = mem_sequence_item::type_id::create("my_seq_item");
			$display("DEBUG::SEQUENCE->SequenceItem Object Created");
			//uvm_sequence_base Methods
			//https://vlsiverify.com/uvm/uvm_sequence_base-methods/#:~:text=The%20start_item(req)%20method%20internally,UVM%20Tutorials
			//The randomized sequence items can be driven to the driver using pre-defined methods call present in the uvm_sequence_base class.
			//There are two approaches with a set of uvm_sequence_base methods by which sequence can send sequence items and retrieve response from the driver (if applicable).
			//Method-1
		   //==========
/*			wait_for_grant();
			assert(my_seq_item.randomize());
			send_request(my_seq_item);
			wait_for_item_done();*/
			//Method-2
			//=========
			start_item(my_seq_item);
			$display("DEBUG::SEQUENCE->SequenceItem Started");
				assert(my_seq_item.randomize());
			$display("DEBUG::SEQUENCE->SequenceItem Randomized");
			finish_item(my_seq_item);
		end
	endtask : body


endclass : mem_sequence