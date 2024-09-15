class memory_monitor#(int data_width = 16, addr_width = 8) extends uvm_monitor;

    memory_seq_item #(data_width, addr_width) m_seq_item;
    virtual memory_interface #(data_width, addr_width) vif;
    uvm_analysis_port#(m_seq_item) ap;

    `uvm_component_utils(memory_monitor)

    function new(string name = "memory_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual memory_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find virtual interface for monitor")
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(vif.cb);
            if(sel & ready) begin
                m_seq_item = memory_seq_item::type_id::create("m_seq_item");
                @(vif.cb);
                m_seq_item.addr = vif.cb.addr;
                m_seq_item.wdata = vif.cb.wdata;
                m_seq_item.wr_rd = vif.cb.wr_rd;
                m_seq_item.rdata = vif.cb.rdata;
                ap.write(m_seq_item);
            end
        end
    endtask : run_phase

endclass : memory_monitor
