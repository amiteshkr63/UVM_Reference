module top;
    import adder_pkg::*;
    import uvm_pkg::*;

    bit clk;

    dut_intf intf(clk);

    dut uut (
        .clk  (clk),
        .in1  (intf.in1),
        .in2  (intf.in2),
        .en_i (intf.en_i),
        .out  (intf.out),
        .en_o (intf.en_o)
    );

    initial forever #5 clk = ~clk;

    initial begin
        uvm_config_db#(virtual dut_intf)::set(null, "uvm_test_top", "vif", intf);
        run_test("test");
    end

endmodule : top