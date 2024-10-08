interface mem_intf (input bit clk);
	logic rst_n;
	logic wr_rdn;
	logic [3:0]addr;
	logic [7:0]in_data;
	logic [7:0]out_data;

	clocking drv_cb@(posedge clk);
		default input #1 output #1;
		//Input to DUT
		output wr_rdn;
		output addr;
		output in_data;
		//Output to DUT
		input out_data;
	endclocking

	clocking mon_cb@(posedge clk);
		default input #1 output #1;
		//Input to DUT
		input wr_rdn;
		input addr;
		input in_data;
		//Output to DUT
		input out_data;
	endclocking

	modport DRV (clocking drv_cb, input clk, input rst_n);
	modport MON (clocking mon_cb, input clk, input rst_n);

endinterface : mem_intf