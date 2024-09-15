class passive_memory_monitor extends uvm_monitor;

    memory_seq_item m_seq_item;
    virtual memory_interface.p_mon vif;
    uvm_analysis_port#(memory_seq_item) ap;
    `uvm_component_utils(passive_memory_monitor)

    function new(string name = "passive_memory_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual memory_interface.p_mon)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find virtual interface for monitor")
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(vif.mon_p_cb);
            if(vif.mon_p_cb.sel & ~vif.mon_p_cb.wr_rd) begin
                m_seq_item = memory_seq_item::type_id::create("m_seq_item");
                @(vif.mon_p_cb);
                m_seq_item.addr = vif.mon_p_cb.addr;
                @(vif.mon_p_cb);
                m_seq_item.rdata = vif.mon_p_cb.rdata;
                ap.write(m_seq_item);
            end
        end
    endtask : run_phase

endclass : passive_memory_monitor
