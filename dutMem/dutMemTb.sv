module dutMemTb ();
	reg clk;
	reg reset_n;
	reg sel;
	reg wr_rd;
	reg [inst_dutMem.ADDR_WIDTH-1:0] addr;
	reg [inst_dutMem.DATA_WIDTH-1:0] wdata;

	wire [inst_dutMem.DATA_WIDTH-1:0] rdata;
	wire ready;

	dutMem #(
			.ADDR_WIDTH(8),
			.DATA_WIDTH(16),
			.DEPTH(16),
			.RESET_VALUE(16'h5678)
		) inst_dutMem (
			.clk     (clk),
			.reset_n (reset_n),
			.addr    (addr),
			.sel     (sel),
			.wr_rd   (wr_rd),
			.wdata   (wdata),
			.rdata   (rdata),
			.ready   (ready)
		);

	initial begin
		clk=1;
		reset_n = 0;
		sel=0;
		wr_rd= 0;
		wdata = 0;
		addr = 0;
		#10;
		reset_n = 1;
		@(posedge clk);
		wait(ready);
		//@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 0;
		addr = 'd7;
		@(posedge clk);
		wait(ready);
		@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 1;
		addr = 'd2;
		wdata = $random;
		@(posedge clk);
		wait(ready);
		//@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 0;
		addr = 'd2;
		//@(posedge clk);
		wait(ready);
		@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 0;
		addr = 'd3;
		//@(posedge clk);
		wait(ready);
		@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 1;
		addr = 'd3;
		wdata = $random;
		@(posedge clk);
		wait(ready);
		//@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 1;
		addr = 'd4;
		wdata = $random;
		@(posedge clk);
		wait(ready);
		//@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 0;
		addr = 'd3;
		@(posedge clk);
		wait(ready);
		@(posedge clk);
		//repeat(2)@(posedge clk);
		sel = 1;
		wr_rd = 0;
		addr = 'd4;
		//repeat(2)wait(ready);
	//	@(posedge clk);
		//sel = 0;



	end

	always #5 clk = ~clk;
endmodule : dutMemTb