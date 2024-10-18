module dut (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input wr_rdn,
	input [3:0]addr,
	input [7:0]in_data,
	output reg [7:0]out_data
);
reg [7:0]mem[3:0];

always_ff @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		for (int i = 0; i < 'd15; i++) begin
			mem[i] <= 'd0;
		end
		out_data <= 'd0;
	end else begin
		if (wr_rdn) begin
			mem[addr] <= in_data;
			out_data <= 'd0;
		end
		else begin
			out_data <= mem[addr];
		end
	end
end

endmodule : dut