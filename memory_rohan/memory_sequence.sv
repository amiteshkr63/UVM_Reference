class memory_sequence extends uvm_sequence#(memory_seq_item);

    memory_seq_item m_seq_item;
    int packets;

    `uvm_object_utils(memory_sequence)

    function new(string name = "memory_sequence");
        super.new(name);
        if (!$value$plusargs("packets=%0d",packets)) begin
            packets = 10;
        end
    endfunction : new

    task body();
        repeat(packets) begin
            m_seq_item = memory_seq_item::type_id::create("m_seq_item");
            start_item(m_seq_item);
                assert(m_seq_item.randomize() with {transmit_delay inside {[1:10]};});
            finish_item(m_seq_item);
        end
    endtask : body

endclass : memory_sequence
