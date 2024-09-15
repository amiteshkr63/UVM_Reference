class memory_driver#(int data_width = 16, addr_width = 8) extends uvm_driver;

    memory_seq_item #(data_width, addr_width) m_seq_item;
    virtual memory_interface #(data_width, addr_width) vif;

    `uvm_component_utils(memory_driver)

    function new(string name = "memory_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual memory_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to find virtual interface for driver")
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            m_seq_item = memory_seq_item::type_id::create("m_seq_item");
            seq_item_port.get_next_item(m_seq_item);
            m_seq_item.print();

            while(!vif.cb.ready) @(vif.cb);

            @(vif.cb);
            vif.cb.sel = 1'b1;
            vif.cb.addr = m_seq_item.addr;
            vif.cb.wdata = m_seq_item.wdata;
            vif.cb.wr_rd = m_seq_item.wr_rd;

            @(vif.cb);
            vif.cb.sel <= 1'b0;

            seq_item_port.item_done();
        end
    endtask : run_phase


    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Total Packets recieved: %0d", pkt_count), UVM_MEDIUM)
    endfunction : report_phase

endclass : memory_driver
