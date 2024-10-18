/*`ifdef UVM_NO_DPI
 	`define UVM_HDL_NO_DPI
 	`define UVM_REGEX_NO_DPI
 	`define UVM_CMDLINE_NO_DPI
`endif*/

`include "mem_package.sv"
module mem_top_tb;
	import mem_pkg::*;
	import uvm_pkg::*;
	
	bit clk;

	mem_intf intf(clk);
	
	dut inst_dut
		(
			.clk      (clk),
			.rst_n    (intf.rst_n),
			.wr_rdn   (intf.wr_rdn),
			.addr     (intf.addr),
			.in_data  (intf.in_data),
			.out_data (intf.out_data)
		);


	initial begin
		fork
			begin
				clk = 0;
				forever #5 clk = ~clk;
			end
			begin
				intf.rst_n = 0;
/*				@(posedge clk);
				@(posedge clk);
				@(negedge clk);*/
				#10;
				intf.rst_n = 1;
			end
		join
	end

	initial begin
		uvm_config_db#(virtual mem_intf.DRV)::set(null, "*", "dinf", intf);
		uvm_config_db#(virtual mem_intf.MON)::set(null, "*", "minf", intf);
		run_test("mem_test");
	end

endmodule : mem_top_tb