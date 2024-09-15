class environment extends uvm_env;

    agent adder_agent;
    scoreboard adder_scoreboard;

    `uvm_component_utils(environment)

    function new(string name = "environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        adder_agent = agent::type_id::create("adder_agent", this);
        adder_scoreboard = scoreboard::type_id::create("adder_scoreboard", this);

    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        adder_agent.ap.connect(adder_scoreboard.ap);
    endfunction : connect_phase

endclass : environment
