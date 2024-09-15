`uvm_analysis_imp_decl(_BEFORE)
`uvm_analysis_imp_decl(_AFTER)
class mem_scoreboard extends uvm_scoreboard;
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	mem_seq_itm agent_driver_monitor_seq_itm_queue[$]; 
	mem_seq_itm agent_monitor_seq_itm_queue[$]; 
	int no_of_packets, right_packets, wrong_packets;
	reg [15:0]shadow[255:0];
	uvm_analysis_imp_BEFORE #(mem_seq_itm, mem_scoreboard) before_export; 
	uvm_analysis_imp_AFTER #(mem_seq_itm, mem_scoreboard) after_export; 
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
		no_of_packets=0;
		right_packets=0; 
		wrong_packets=0;
		foreach (shadow[i]) begin
			shadow[i]=16'h5678;
		end
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    before_export=new("before_export", this);
	    after_export=new("after_export", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	endfunction : connect_phase

	//Storing WDATA and ADDR from ACTIVE agent 
	function void write_BEFORE(mem_seq_itm t);
	  agent_driver_monitor_seq_itm_queue.push_back(t);
	endfunction : write_BEFORE

	//Storing RDATA from ACTIVE agent
	function void write_AFTER(mem_seq_itm t); 
	  agent_monitor_seq_itm_queue.push_back(t);
	endfunction : write_AFTER

	virtual task run_phase(uvm_phase phase);
		mem_seq_itm drvrmon;
		mem_seq_itm mon;
		bit WR_RDbar;
		bit [7:0]ADDR;
		bit [15:0]RDATA;
		bit [15:0]WDATA;
		forever begin
			wait(agent_driver_monitor_seq_itm_queue.size()!=0 && agent_monitor_seq_itm_queue.size()!=0); 
				drvrmon=agent_driver_monitor_seq_itm_queue.pop_front();
				mon=agent_monitor_seq_itm_queue.pop_front();
				//******************************//
				/**/WR_RDbar=drvrmon.WR_RDbar;	//
				/**/ADDR=drvrmon.ADDR;			//
				/**/WDATA=drvrmon.WDATA;		//
				/**/RDATA=mon.RDATA;			//
				//******************************//
				if (WR_RDbar) begin
					shadow[ADDR]=WDATA;
					`uvm_info("Scoreboard", "Output matches correctly", UVM_MEDIUM)
					`uvm_info("Scoreboard", $sformatf("ADDR: %0d, WDATA: %0d", ADDR, WDATA), UVM_MEDIUM)
				end
				else begin
					if (RDATA==shadow[ADDR]) begin
						`uvm_info("Scoreboard", "Output matches correctly", UVM_MEDIUM)
						`uvm_info("Scoreboard", $sformatf("ADDR: %0d, RDATA: %0d", ADDR, RDATA), UVM_MEDIUM)
						right_packets++;
					end
					else begin
						`uvm_info("Scoreboard", "Output doesn't matches correctly", UVM_MEDIUM)
						`uvm_info("Scoreboard", $sformatf("Received FROM MONITOR:ADDR: %0d, RDATA: %0d", ADDR, RDATA), UVM_MEDIUM)
						`uvm_info("Scoreboard", $sformatf("Expected FROM MONITOR:ADDR: %0d, RDATA: %0d", ADDR, shadow[ADDR]), UVM_MEDIUM)
						wrong_packets++;
					end
				end
				no_of_packets++;
		end
	endtask : run_phase
endclass : mem_scoreboard