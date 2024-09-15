module top;
	import mem_pkg::*;
	import uvm_pkg::*;
	bit clk;
	bit RST_n;
	mem_interface intf_inst(clk);
memory inst_memory (
			.clk      (clk),
			.SEL      (intf_inst.SEL),
			.WDATA    (intf_inst.WDATA),
			.WR_RDbar (intf_inst.WR_RDbar),
			.RST_n    (RST_n),
			.ADDR     (intf_inst.ADDR),
			.READY    (intf_inst.READY),
			.RDATA    (intf_inst.RDATA)
		);

	initial begin
        uvm_config_db#(virtual mem_interface.driver_mp)::set(null, "*", "drvrvif", intf_inst);
        															//Field   Value
        //All field named with "vif" are going to be connected.
		
		uvm_config_db#(virtual mem_interface.monitor_mp)::set(null, "*", "monvif", intf_inst);
	end

	initial begin
		run_test("mem_test");
	end
	
	initial begin
		forever #5 clk = ~clk;
	end

	initial begin
		RST_n=0;
		#20 RST_n=1;
	end

endmodule : top