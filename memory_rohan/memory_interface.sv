interface memory_interface (input bit clk);
    logic [7:0] addr;
    logic [15:0] wdata;
    logic [15:0] rdata;
    logic rst;
    logic sel;
    logic wr_rd;
    logic ready;

    clocking drv_cb@(posedge clk);
        default input #1ns output #1ns;
        output addr;
        output wdata;
        output sel;
        output wr_rd;
        input rdata;
        input ready;
    endclocking

    clocking mon_a_cb@(posedge clk);
        default input #1ns output #1ns;
        input addr;
        input wdata;
        input sel;
        input wr_rd;
        input ready;
    endclocking

    clocking mon_p_cb@(posedge clk);
        default input #1ns output #1ns;
        input addr;
        input rdata;
        input sel;
        input wr_rd;
        input ready;
    endclocking

    modport drv (clocking drv_cb, input clk, input rst);
    modport a_mon (clocking mon_a_cb, input clk, input rst);
    modport p_mon (clocking mon_p_cb, input clk, input rst);
    
endinterface : memory_interface