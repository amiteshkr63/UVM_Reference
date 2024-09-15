interface mem_interface (input bit clk/*, input bit RST_n*/);
	
	logic RST_n;
	logic SEL;
	logic WR_RDbar;
	logic [7:0]ADDR;
	logic [15:0]WDATA;
	logic READY;
	logic [15:0]RDATA;

	clocking monitor_cb @(posedge clk);
		default input #1ns output #1ns;
		input READY;
		input RDATA;
		input SEL;
		input WR_RDbar;
		input ADDR;
		input WDATA;
	endclocking
	
	clocking driver_cb @(posedge clk);
		default input #1ns output #1ns;		//input 1ns->give stimulus to dut prior to posedge of clk and output vice-versa		//purpose clock skew handle
		output SEL;
		output WR_RDbar;
		output ADDR;
		output WDATA;
		/*input READY;*/
	endclocking
	modport monitor_mp (input clk, clocking monitor_cb);
	modport driver_mp (input clk, output RST_n, clocking driver_cb);
								//=============//
						//RST_n should be in output modport
endinterface

/*
An Interface is a way to encapsulate signals into a block.
All related signals are grouped together to form an interface block
so that the same interface can be re-used for
other projects. Also it becomes easier to connect with the DUT and other verification components.

WHY ARE SIGNALS IN INTERFACE IS LOGIC?
======================================
->Logic is a data type that lets you drive signals via 
assign statements and procedural block.
->Signals connected to "DUT" should support 4-states so that
X-Z can be caught. If these signals are "bit" type then, we
are only giving 0 and 1, we would have missed X/Z value

CLOCK and RESET i want to give from TOP_TB. Thats why i also
dont have to declare these inputs (i.e.,clk, reset)
*/