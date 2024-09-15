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
    output [data_width-1:0] rdata,
    output ready
);
    integer i;
    reg [addr_width-1:0] address_reg;
    reg temp_ready;
    reg [data_width-1:0] rdata_reg;
    reg [data_width-1:0] mem [depth-1:0];

    assign rdata = rdata_reg;
    assign ready = temp_ready;

    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            for (i = 0; i < depth; i=i+1) begin
                mem[i] <= reset_value;
            end
            temp_ready <= 1'b1;
            rdata_reg <= reset_value;
            address_reg <= 'h0;
        end else begin
            if (sel & ready) begin
                if (wr_rd) begin
                    mem[address] <= wdata;
                    temp_ready <= 1'b1;
                end else begin
                    rdata_reg <= mem[address_reg];
                    if(address_reg == address) begin
                        temp_ready <= 1'b1;
                    end else begin
                        temp_ready <= 1'b0;
                    end
                    address_reg <= address;
                end
            end else begin
                temp_ready <= 1'b1;
                rdata_reg <= mem[address_reg];
            end
        end
    end
endmodule
