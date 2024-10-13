module dutMem #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 16, DEPTH = 256, RESET_VALUE= 16'h5678) (clk, reset_n, addr, sel, wr_rd, wdata, rdata, ready);
	//input signals
	input clk;
	input reset_n;
	input sel;
	input wr_rd;
	input [ADDR_WIDTH-1:0] addr;
	input [DATA_WIDTH-1:0] wdata;

	//output signals
	output reg [DATA_WIDTH-1:0] rdata;
	output reg ready; 

	reg [DATA_WIDTH-1:0] temp_rdata;								//temp register for read data

	reg [DATA_WIDTH-1:0] my_mem [DEPTH-1:0];						//memory
	reg temp_ready;													//temp_ready is used to set a flag whenever ready goes from 1 to 0.
																	//tem_ready holds last value of ready

	reg ready_comp;													//flag, this is set whenever ready goes from 1 to 0
																	//ready_comp flag is used to set ready high again on next clock after it goes low.

	assign ready_comp = ~ready & temp_ready;						//checks whenever ready goes low

	always_ff @(posedge clk or negedge reset_n) begin
		if(~reset_n) begin
			ready <= 'd1;											//ready high at reset
			temp_ready <= ready;									
		end else begin
			temp_ready <= ready;

			if (sel & ready & !wr_rd) begin
				ready <= 'd0;										//ready is low when there is read command
			end
			if (sel & ready_comp) begin
				ready <= 'd1;										//whenver there ready goes low the next clock this makes it high
			end
		end
	end

	always_ff @(posedge clk or negedge reset_n) begin
		if(~reset_n) begin
			rdata <= 'dz;
			temp_rdata <= 'dz;
			for (int i = 0; i < DEPTH; i++) begin
				my_mem[i] <= RESET_VALUE;
			end
		end else begin
			case ({sel, ready, wr_rd})
				3'b111: begin										//write command
					my_mem[addr] <= wdata;							//write data assigned to address
					temp_rdata <= 'dz;						
				end
				3'b110: begin										//read command
					temp_rdata <= my_mem[addr];						//data from address assinged to internal register
				end
				default: begin 
					temp_rdata <= 'dz;	
				end
			endcase
			rdata <= temp_rdata;									//temp reg for read data assigned to read data output
		end
	end
endmodule : dutMem