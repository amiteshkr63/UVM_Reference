class active_memory_monitor extends uvm_monitor;

    memory_seq_item m_seq_item;
    virtual memory_interface.a_mon vif;
    uvm_analysis_port#(memory_seq_item) ap;

    `uvm_component_param_utils(active_memory_monitor)

    function new(string name = "active_memory_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual memory_interface.a_mon)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find virtual interface for monitor")
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            m_seq_item = memory_seq_item::type_id::create("m_seq_item");
            @(vif.mon_a_cb);
            if(vif.mon_a_cb.sel & vif.mon_a_cb.ready) begin
                m_seq_item.addr = vif.mon_a_cb.addr;
                m_seq_item.wdata = vif.mon_a_cb.wdata;
                m_seq_item.wr_rd = vif.mon_a_cb.wr_rd;
                ap.write(m_seq_item);
            end
        end
    endtask : run_phase

endclass : active_memory_monitor
