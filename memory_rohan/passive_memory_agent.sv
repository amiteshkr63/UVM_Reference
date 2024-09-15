class passive_memory_agent extends uvm_agent;

    passive_memory_monitor m_memory_monitor;
    uvm_analysis_port#(memory_seq_item) ap;

    `uvm_component_utils(passive_memory_agent)

    function new(string name = "passive_memory_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_memory_monitor = passive_memory_monitor::type_id::create("m_memory_monitor", this);
        ap = new("ap", this);
    
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_memory_monitor.ap.connect(ap);
    endfunction : connect_phase

endclass : passive_memory_agent