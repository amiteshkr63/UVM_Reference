interface dutMem_interface #(parameter ADDR_WIDTH= 8, DATA_WIDTH = 16) (input bit clk);
	//inputs
	logic reset_n;
	logic sel;
	logic wr_rd;
	logic [ADDR_WIDTH-1:0] addr;
	logic [DATA_WIDTH-1:0] wdata;

	//outputs
	logic [DATA_WIDTH-1:0] rdata;
	logic ready;

	clocking cb@(posedge clk);
		default input #1 output #1;
		//inputs
		output sel;
		output wr_rd;
		output addr;
		output wdata;
		//outputs
		input rdata;
		input ready;
	endclocking

	clocking cb_mon@(posedge clk);
		default input #1 output #1;
		//inputs
		input sel;
		input wr_rd;
		input addr;
		input wdata;
		//outputs
		input rdata;
		input ready;
	endclocking

	modport MP (clocking cb, input clk, input reset_n);		//modport
	modport IP (clocking cb_mon, input clk, input reset_n);		//modport

endinterface : dutMem_interface