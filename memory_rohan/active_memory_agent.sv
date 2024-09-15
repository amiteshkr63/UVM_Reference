typedef uvm_sequencer#(memory_seq_item) memory_sequencer;

class active_memory_agent extends uvm_agent;

    memory_driver m_memory_driver;
    active_memory_monitor m_memory_monitor;
    memory_sequencer m_memory_sequencer;
    uvm_analysis_port#(memory_seq_item) ap;

    `uvm_component_utils(active_memory_agent)

    function new(string name = "active_memory_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_memory_monitor = active_memory_monitor::type_id::create("m_memory_monitor", this);
        m_memory_driver = memory_driver::type_id::create("m_memory_driver", this);
        m_memory_sequencer = memory_sequencer::type_id::create("m_memory_sequencer", this);
        ap = new("ap", this);

    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_memory_monitor.ap.connect(ap);
        m_memory_driver.seq_item_port.connect(m_memory_sequencer.seq_item_export); 
    endfunction : connect_phase

endclass : active_memory_agent
