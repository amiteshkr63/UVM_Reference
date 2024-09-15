interface dut_intf (input bit clk);
    logic en_i;
    logic in1;
    logic in2;
    logic en_o;
    logic out;

    clocking drv_cb@(posedge clk);
        default input #1ns output #1ns;
        output en_i;
        output in1;
        output in2;
    endclocking

    clocking mon_cb@(posedge clk);
        default input #1ns output #1ns;
        input en_i;
        input in1;
        input in2;
        input en_o;
        input out;
    endclocking

    modport mon (clocking mon_cb, input clk);
    modport drv (clocking drv_cb, input clk);

endinterface : dut_intf
