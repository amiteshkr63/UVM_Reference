module memory(clk, SEL, WDATA, WR_RDbar, RST_n, ADDR, READY, RDATA);
	
	//Parameters
	parameter ADDR_WIDTH=8, DATA_WIDTH=16, DEPTH=256, DEFAULT_VAL=16'h5678;
	
	//Input and Output Pins
	input clk, SEL, WR_RDbar, RST_n;
	input [ADDR_WIDTH-1:0]ADDR;
	input [DATA_WIDTH-1:0]WDATA;
	output reg READY;
	output reg [DATA_WIDTH-1:0]RDATA;

	//MEMORY
	reg [DATA_WIDTH-1:0]mem[DEPTH-1:0];
	
	//Internal Flags
	reg [ADDR_WIDTH-1:0]prev_addr;
	//reg read_en_flag;

	reg temp_WR_RDbar;
	
	//Initialization of Memory
	/*initial begin
		foreach(mem[i]) begin
			mem[i]=DEFAULT_VAL;
		end
	end*/

	//Writing to Memory
	always_ff@(posedge clk) begin	: write_to_memory
		if (!RST_n) begin
			foreach(mem[i]) begin
				mem[i]=DEFAULT_VAL;
			end
		end
		else if (WR_RDbar) begin
			mem[ADDR]=WDATA;
		end
	end 	: write_to_memory

	//Registring ADDRESS when READ
	always_ff @(posedge clk or negedge RST_n) begin	:	registring_addr_when_read
		if(!RST_n) begin
			prev_addr <= 0;
		end else begin
			 if (!WR_RDbar) begin
			 	prev_addr<=ADDR;
			 end
			 else begin
			 	prev_addr<=prev_addr;
			 end
		end
	end : registring_addr_when_read

	//Registring WR_RDbar
	always_ff @(posedge clk or negedge RST_n) begin
		if(!RST_n) begin
			temp_WR_RDbar <= 0;
		end else begin
			temp_WR_RDbar <= WR_RDbar;
		end
	end
	//Reading from Memory
	always_ff@(posedge clk or negedge RST_n) begin	: read_from_memory
		if (!RST_n) begin
			{READY, RDATA}={1'b1, 16'b0};
		end
		else if (SEL) begin
			if (WR_RDbar) begin
				{READY, RDATA}={1'b1, mem[prev_addr]};
			end
			else begin
				{READY, RDATA}={(((!WR_RDbar)&(WR_RDbar==temp_WR_RDbar))&(prev_addr==ADDR)), mem[prev_addr]};
			end
		end
		else begin
			{READY, RDATA}={1'b0, 16'b0};
		end
	end : read_from_memory

/*	
	//Detecting Read assertion from WRITE operation and ADDRESS change when READ 
	always_ff@(posedge CLK) begin	:	detecting_read_assertion_from_WRITE_operation_and_ADDRESS_change_when_READ
		if (!RST_n) begin
			read_en_flag=0;
		end
		else if(SEL) begin
			if (WR_RDbar) begin
				read_en_flag=0;
			end
			else begin
				if(ADDR==prev_addr) begin
					read_en_flag=1;
				end
				else begin
					read_en_flag=0;
				end
			end
		end
	end : detecting_read_assertion_from_WRITE_operation_and_ADDRESS_change_when_READ
*/

endmodule : memory

/*
Design: Memory
Inputs: clk, rst, [addr_width-1:0]address, scl, wr_rd, [data_width-1:0]wdata
Outputs: [data_width-1:0]rdata, ready
Parameters: addr_width = 8, data_width = 16, depth = 256, reset_value = DEFAULT_VAL
Active Low Reset
if (wr_rd == 1) ====> Write
if(wr_rd == 0) ===> Read
if(scl == ready == 1) ===>Valid operation
if(reset) data = {(data_width/16){DEFAULT_VAL}}
if(reset) ready = 1
if(Read) ready = 0 ...for 1 clock
*/