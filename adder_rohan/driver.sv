class driver extends uvm_driver#(seq_item);

    virtual dut_intf.drv vif;
    seq_item adder_seq_item;
    bit count;
    int packets;

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent=null);
        super.new(name, parent);
        count = 0;
        if(!$value$plusargs("packets=%0d",packets)) begin                 //While running, vsim +packets={no_of_packets} {*.sv}
            packets=10;
        end
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_intf.drv)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find interface for driver")
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        repeat(packets) begin
            adder_seq_item = seq_item::type_id::create("adder_seq_item");

            seq_item_port.get_next_item(adder_seq_item);
            // adder_seq_item.print();

            @(vif.drv_cb);
            vif.drv_cb.en_i <= adder_seq_item.en_i;
            vif.drv_cb.in1 <= adder_seq_item.in1;
            vif.drv_cb.in2 <= adder_seq_item.in2;

            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : driver
