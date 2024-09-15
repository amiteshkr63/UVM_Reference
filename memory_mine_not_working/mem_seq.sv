class mem_seq extends uvm_sequence#(mem_seq_itm);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_seq_itm mem_seq_itm_handle;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(mem_seq)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "mem_seq"/*, uvm_component parent=null*/);		///////////////////uvm_component parent=null---->NOT GOING TO BE USED
		super.new(name/*, parent*/);
	endfunction : new

	task body();
		repeat(25) begin
			mem_seq_itm_handle = mem_seq_itm::type_id::create("mem_seq_itm_handle"); 
			start_item(mem_seq_itm_handle);
                assert(mem_seq_itm_handle.randomize());
/*                assert(mem_seq_itm_handle.randomize() with {ADDR inside {[100:200]};})
                assert(mem_seq_itm_handle.randomize() with {WDATA inside {[1:10]};})
                assert(mem_seq_itm_handle.randomize() with {WR_RDbar inside {[0:1]};})
*/			finish_item(mem_seq_itm_handle);
		end 	
	endtask : body

endclass : mem_seq