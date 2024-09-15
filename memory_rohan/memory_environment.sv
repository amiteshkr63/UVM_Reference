class memory_environment extends uvm_env;

    active_memory_agent m_active_memory_agent;
    passive_memory_agent m_passive_memory_agent;
    memory_scoreboard m_memory_scoreboard;

    `uvm_component_utils(memory_environment)

    function new(string name = "environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_active_memory_agent = active_memory_agent::type_id::create("m_active_memory_agent", this);
        m_passive_memory_agent = passive_memory_agent::type_id::create("m_passive_memory_agent", this);
        m_memory_scoreboard = memory_scoreboard::type_id::create("m_memory_scoreboard", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_active_memory_agent.ap.connect(m_memory_scoreboard.active_ap);
        m_passive_memory_agent.ap.connect(m_memory_scoreboard.passive_ap);
    endfunction : connect_phase

endclass : memory_environment
