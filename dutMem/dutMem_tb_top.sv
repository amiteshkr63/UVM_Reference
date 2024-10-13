`include "dutMem_pkg.sv"
module dutMem_tb_top();
	import dutMem_pkg::*;
	import uvm_pkg::*;
	
	
	bit clk;

	dutMem_interface intf(clk);						//do the necessary changes


	initial begin
		intf.reset_n = 0;
		#10;
		intf.reset_n = 1;
	end

	initial begin
		uvm_config_db#(virtual dutMem_interface.MP)::set(null, "*", "vif", intf ); 
		uvm_config_db#(virtual dutMem_interface.IP)::set(null, "*", "vif_IN", intf ); 
		run_test("dutMem_test");
	end

	always #5 clk=~clk;

	dutMem #(
			.ADDR_WIDTH(8),
			.DATA_WIDTH(16),
			.DEPTH(256),
			.RESET_VALUE(16'h5678)
		) inst_dutMem (
			.clk     (clk),
			.reset_n (intf.reset_n),
			.addr    (intf.addr),
			.sel     (intf.sel),
			.wr_rd   (intf.wr_rd),
			.wdata   (intf.wdata),
			.rdata   (intf.rdata),
			.ready   (intf.ready)
		);


endmodule : dutMem_tb_top