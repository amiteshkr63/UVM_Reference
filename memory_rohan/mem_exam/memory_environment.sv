class memory_environment#(int data_width, addr_width) extends uvm_env;

    memory_agent#(data_width, addr_width) adder_agent;

    `uvm_component_utils(environment)

    function new(string name = "environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        adder_agent = agent::type_id::create("m_agent", this);    
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

endclass : memory_environment
