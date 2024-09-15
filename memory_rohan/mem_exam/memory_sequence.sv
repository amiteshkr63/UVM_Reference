class memory_sequence#(data_width, addr_width) extends uvm_sequence;

    memory_seq_item#(data_width, addr_width) m_seq_item;

    `uvm_component_utils(memory_sequence)

    function new(string name = "memory_sequence", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    function void body();
        repeat(10) begin
            start_item(m_seq_item);
                assert(m_seq_item.randomize());
            finish_item(m_seq_item);
        end
    endfunction : body

endclass : memory_sequence
