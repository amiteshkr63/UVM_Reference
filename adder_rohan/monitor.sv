class monitor extends uvm_monitor;

    uvm_analysis_port#(seq_item) ap;
    virtual dut_intf.mon vif;
    seq_item adder_seq_item;
    int pkt_count;

    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent=null);
        super.new(name, parent);
        pkt_count = 0;
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_intf.mon)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find interface for monitor")
        end
        ap = new("ap", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(vif.mon_cb);
            if(vif.mon_cb.en_i) begin
                repeat(5) begin
                    adder_seq_item = seq_item::type_id::create("adder_seq_item");

                    adder_seq_item.en_i = vif.mon_cb.en_i;
                    adder_seq_item.in1  = vif.mon_cb.in1;
                    adder_seq_item.in2  = vif.mon_cb.in2;
                    adder_seq_item.out  = vif.mon_cb.out;
                    adder_seq_item.en_o = vif.mon_cb.en_o;
                    // adder_seq_item.print();
                    ap.write(adder_seq_item);
                    @(vif.mon_cb);
                end
                pkt_count ++;
            end
        end
    endtask : run_phase

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("%0d Packets recieved", pkt_count), UVM_MEDIUM)
    endfunction : report_phase

endclass : monitor
