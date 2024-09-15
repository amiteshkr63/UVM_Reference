typedef uvm_sequencer#(memory_seq_item#(data_width, addr_width)) memory_sequencer;

class memory_agent#(int data_width, addr_width) extends uvm_agent;

    memory_driver#(data_width, addr_width) m_memory_driver;
    memory_monitor#(data_width, addr_width) m_memory_monitor;
    memory_sequencer m_memory_sequencer;
    uvm_analysis_port#(memory_seq_item) ap;

    `uvm_component_utils(memory_agent)

    function new(string name = "memory_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_memory_monitor = monitor::type_id::create("m_memory_monitor", this);
        m_memory_driver = driver::type_id::create("m_memory_driver", this);
        m_memory_sequencer = sequencer::type_id::create("m_memory_sequencer", this);

    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_memory_monitor.ap.connect(ap);
        m_memory_driver.seq_item_port.connect(m_memory_sequencer.seq_item_export); 
    endfunction : connect_phase

endclass : memory_agent
