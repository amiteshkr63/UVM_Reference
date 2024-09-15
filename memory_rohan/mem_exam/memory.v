module memory #(
    parameter addr_width = 8,
    parameter data_width = 16,
    parameter depth = 256,
    parameter reset_value = 'h5678
    ) (
    input clk,
    input rst,
    input [addr_width-1:0] address,
    input [data_width-1:0] wdata,
    input sel,
    input wr_rd,
    output reg [data_width-1:0] rdata,
    output reg ready
);
    integer i;
    reg [addr_width-1:0] address_reg;
    reg temp_ready;
    reg [data_width-1:0] mem [depth-1:0];

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            for (i = 0; i < depth; i=i+1) begin
                mem[i] <= reset_value;
            end
            ready <= 1'b1;
            rdata <= reset_value;
            address_reg <= 'h0;
        end else begin
            if (sel & ready) begin
                if (wr_rd) begin
                    mem[address] <= wdata;
                    temp_ready <= 1'b1;
                end else begin
                    rdata <= mem[address_reg];
                    if(address_reg == address) begin
                        ready <= 1'b1;
                    end else begin
                        ready <= 1'b0;
                        temp_ready <= 1'b1;
                    end
                    address_reg <= address;
                end
            end else begin
                ready <= temp_ready;
                rdata <= mem[address_reg];
            end
        end
    end
endmodule
