class test extends uvm_test;

    environment adder_env;
    env_config adder_env_config;
    virtual dut_intf vif;
    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find Interface for Test")
        end
        adder_env_config = env_config::type_id::create("adder_env_config");
        adder_env_config.has_coverage = 1;
        adder_env_config.adder_agent_config = agent_config::type_id::create("adder_env_config");
        adder_env_config.adder_agent_config.is_active = 1;
        uvm_config_db#(env_config)::set(this, "adder_env", "env_config", adder_env_config);
        uvm_config_db#(virtual dut_intf.mon)::set(this, "adder_env.adder_agent.adder_monitor", "vif", vif);
        uvm_config_db#(virtual dut_intf.drv)::set(this, "adder_env.adder_agent.adder_driver", "vif", vif);
        adder_env = environment::type_id::create("adder_env", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        adder_sequence seq = adder_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(adder_env.adder_agent.adder_sequencer);
        phase.drop_objection(this);
    endtask : run_phase

endclass : test
