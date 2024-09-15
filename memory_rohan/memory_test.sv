class memory_test extends uvm_test;

    memory_environment m_memory_environment;
    virtual memory_interface vif;
    `uvm_component_utils(memory_test)

    function new(string name = "memory_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual memory_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find Interface for Test")
        end

        uvm_config_db#(virtual memory_interface.a_mon)::set(this, "m_memory_environment.m_active_memory_agent.m_memory_monitor", "vif", vif);
        uvm_config_db#(virtual memory_interface.p_mon)::set(this, "m_memory_environment.m_passive_memory_agent.m_memory_monitor", "vif", vif);
        uvm_config_db#(virtual memory_interface.drv)::set(this, "m_memory_environment.m_active_memory_agent.m_memory_driver", "vif", vif);
        m_memory_environment = memory_environment::type_id::create("m_memory_environment", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        memory_sequence seq = memory_sequence::type_id::create("seq");
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100ns);
        seq.start(m_memory_environment.m_active_memory_agent.m_memory_sequencer);
        phase.drop_objection(this);
    endtask : run_phase

endclass : memory_test
