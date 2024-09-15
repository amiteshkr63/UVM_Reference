interface memory_interface #(parameter data_width = 16, parameter addr_width = 8) (input bit clk);
    logic [addr_width-1:0] addr;
    logic [data_width-1:0] wdata;
    logic [data_width-1:0] rdata;
    logic rst;
    logic sel;
    logic wr_rd;
    logic ready;

    `ifdef POSEDGE_CLK
        clocking cb@(posedge clk);
    `else
        clocking cb@(negedge clk);
        default input #1ns output #1ns;
        output addr;
        output wdata;
        output sel;
        output wr_rd;
        input rdata;
        input ready;
    endclocking
    
endinterface : memory_interface