`uvm_analysis_imp_decl(_active)
`uvm_analysis_imp_decl(_passive)
class memory_scoreboard extends uvm_scoreboard;

    memory_seq_item m_seq_item;
    bit [15:0] mem [255:0];
    int correct_matches, mis_matches, no_of_pkts;
    uvm_analysis_imp_active#(memory_seq_item, memory_scoreboard) active_ap;
    uvm_analysis_imp_passive#(memory_seq_item, memory_scoreboard) passive_ap;
    `uvm_component_utils(memory_scoreboard)

    function new(string name = "memory_scoreboard", uvm_component parent=null);
        super.new(name, parent);
        correct_matches = 0;
        mis_matches = 0;
        no_of_pkts = 0;
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        active_ap = new("active_ap", this);
        passive_ap = new("passive_ap", this);
        foreach (mem[i]) begin
            mem[i] = 16'h5678;
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual function void write_active(memory_seq_item pkt);
        if (pkt.wr_rd == MEM_WRITE) begin
            mem[pkt.addr] = pkt.wdata;
            `uvm_info(get_type_name(), $sformatf("Valid Write done at %0d, Data = %0d", pkt.addr, pkt.wdata), UVM_MEDIUM)
            correct_matches++;
        end
        no_of_pkts++;
    endfunction : write_active

    virtual function void write_passive(memory_seq_item pkt);
            if (pkt.rdata == mem[pkt.addr]) begin
                `uvm_info(get_type_name(), "Output matches correctly", UVM_MEDIUM)
                `uvm_info(get_type_name(), $sformatf("Valid Read at %0d, Data = %0d", pkt.addr, pkt.rdata), UVM_MEDIUM)
                correct_matches++;
            end else begin
                `uvm_error(get_type_name(), "Output does not match correctly")
                `uvm_info(get_type_name(), $sformatf("Invalid Read at %0d, Expected Data = %0d, Recieved Data = %0d", pkt.addr, mem[pkt.addr], pkt.rdata), UVM_MEDIUM)
                mis_matches++;
            end
    endfunction : write_passive

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("%0d Packets recieved", no_of_pkts), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("%0d Packets matched correctly", correct_matches), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("%0d Packets matched incorrectly", mis_matches), UVM_MEDIUM)
    endfunction : report_phase

endclass : memory_scoreboard
