typedef uvm_sequencer#(seq_item) sequencer;

class agent extends uvm_agent;

    driver adder_driver;
    monitor adder_monitor;
    sequencer adder_sequencer;
    uvm_analysis_port#(seq_item) ap;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        adder_monitor = monitor::type_id::create("adder_monitor", this);

        adder_driver = driver::type_id::create("adder_driver", this);
        adder_sequencer = sequencer::type_id::create("adder_sequencer", this);

        ap = new("ap", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        adder_monitor.ap.connect(ap);

        adder_driver.seq_item_port.connect(adder_sequencer.seq_item_export); 
    endfunction : connect_phase

endclass : agent
