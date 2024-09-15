module dut (
    input clk,
    input in1,
    input in2,
    input en_i,
    output out,
    output en_o
);

    parameter IDLE = 2'd0, LOAD_2ND_BIT = 2'd1, DRIVE_OUTPUT = 2'd2;

    reg [1:0] in1_reg;
    reg [1:0] in2_reg;
    reg [2:0] sum_reg;

    reg [1:0] pst=2'b0, nst;
    reg [1:0] count;

    reg out_reg;
    reg en_o_reg;

    assign out = out_reg;
    assign en_o = en_o_reg;

    always@(posedge clk) begin
        pst <= nst;

        if (pst == DRIVE_OUTPUT) begin
            count <= count+1;
        end else begin
            count <= 0;
        end
    end

    always @(*) begin
        case (pst)
            IDLE        :   begin
                                if(en_i) begin
                                    nst = LOAD_2ND_BIT;
                                end else begin
                                    nst = IDLE;
                                end
                            end
            LOAD_2ND_BIT:   nst = DRIVE_OUTPUT;
            DRIVE_OUTPUT:   begin
                                if(count == 2'd2) begin
                                    nst = IDLE;
                                end else begin
                                    nst = DRIVE_OUTPUT;
                                end
                            end
        endcase
    end

    always @(*) begin
        case (pst)
            IDLE        :   begin
                                out_reg = 1'b0;
                                en_o_reg = 1'b0;
                                if(en_i) begin
                                    in1_reg[0] = in1;
                                    in2_reg[0] = in2;
                                end
                            end
            LOAD_2ND_BIT:   begin
                                in1_reg[1] = in1;
                                in2_reg[1] = in2;
                                sum_reg = in1_reg + in2_reg;
                            end
            DRIVE_OUTPUT:   begin
                                if(count == 2'd0) begin
                                    en_o_reg = 1'b1;
                                end else begin
                                    en_o_reg = 1'b0;
                                end
                                out_reg = sum_reg[count];
                            end
        endcase
    end

endmodule
