module memory_tb;
    import memory_pkg::*;
    import uvm_pkg::*;
    bit clk;

    memory_interface intf(clk);

    memory #(
        .addr_width (8),
        .data_width (16),
        .depth      (256),
        .reset_value('h5678)
    ) uut (
        .clk     (clk),
        .rst     (intf.rst),
        .address (intf.addr),
        .wdata   (intf.wdata),
        .sel     (intf.sel),
        .wr_rd   (intf.wr_rd),
        .rdata   (intf.rdata),
        .ready   (intf.ready)
    );

    initial begin
        fork
            begin
                clk = 1'b0;
                forever #5 clk = ~clk;
            end
            begin
                intf.rst = 1'b0;
                repeat(4) @(posedge clk);
                intf.rst = 1'b1;
            end
            begin
                uvm_config_db#(virtual memory_interface)::set(null, "uvm_test_top", "vif", intf);
                run_test("memory_test");
            end
        join
    end

endmodule
