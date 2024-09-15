class scoreboard extends uvm_scoreboard;

    seq_item adder_seq_item;
    seq_item tr_queue[$];
    int correct_matches, mis_matches, no_of_pkts;
    uvm_analysis_imp#(seq_item, scoreboard) ap;

    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent=null);
        super.new(name, parent);
        correct_matches = 0;
        mis_matches = 0;
        no_of_pkts = 0;
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual function void write(seq_item pkt);
        int in1, in2, out;
        tr_queue.push_front(pkt);
        if (tr_queue.size() >= 5) begin
            in1 = 0;
            in2 = 0;
            out = 0;
            
            adder_seq_item = tr_queue.pop_back();
            in1 = adder_seq_item.in1;
            in2 = adder_seq_item.in2;
            assert(adder_seq_item.en_i) else `uvm_error(get_type_name(), "First Packet enable in not set")

            adder_seq_item = tr_queue.pop_back();
            in1 = adder_seq_item.in1*2 + in1;
            in2 = adder_seq_item.in2*2 + in2;

            adder_seq_item = tr_queue.pop_back();
            out = adder_seq_item.out*4;
            assert(adder_seq_item.en_o) else `uvm_error(get_type_name(), "Third Packet enable out not set")

            repeat(2) begin
                adder_seq_item = tr_queue.pop_back();
                out = adder_seq_item.out*4 + (out >> 1);
            end

            if (in1 + in2 == out) begin
                correct_matches++;
                `uvm_info("Scoreboard", "Output matches correctly", UVM_HIGH)
                `uvm_info("Scoreboard", $sformatf("Input1 : %0d, Input2 : %0d, Recieved Output : %0d", in1, in2, out), UVM_HIGH)
            end else begin
                mis_matches++;
                `uvm_error("Scoreboard", "Output does not match correctly")
                `uvm_info("Scoreboard", $sformatf("Input1 : %0d, Input2 : %0d ,Expected Output : %0d, Recieved Output : %0d", in1, in2, in1+in2, out), UVM_HIGH)
            end
            no_of_pkts++;
        end
    endfunction : write


    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("%0d Packets recieved", no_of_pkts), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("%0d Packets matched correctly", correct_matches), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("%0d Packets matched incorrectly", mis_matches), UVM_MEDIUM)
    endfunction : report_phase

endclass : scoreboard
