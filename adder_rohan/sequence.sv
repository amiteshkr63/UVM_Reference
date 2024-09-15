class adder_sequence extends uvm_sequence#(seq_item);

    seq_item adder_seq_item;
    `uvm_object_utils(adder_sequence)

    function new(string name = "adder_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        adder_seq_item = seq_item::type_id::create("adder_seq_item");
        start_item(adder_seq_item);
            assert(adder_seq_item.randomize() with {en_i == 1'b0;}) else
                `uvm_error(get_type_name(), "Randomization Error for seq item 1");
        finish_item(adder_seq_item);
        repeat(10) begin
            adder_seq_item = seq_item::type_id::create("adder_seq_item");
            start_item(adder_seq_item);
                assert(adder_seq_item.randomize() with {en_i == 1'b1;}) else
                    `uvm_error(get_type_name(), "Randomization Error for seq item 1");
            finish_item(adder_seq_item);

            repeat(4) begin
                adder_seq_item = seq_item::type_id::create("adder_seq_item");
                start_item(adder_seq_item);
                    assert(adder_seq_item.randomize() with {en_i == 1'b0;}) else
                        `uvm_error(get_type_name(), "Randomization Error for seq item 2");
                finish_item(adder_seq_item);
            end
        end
    endtask : body

endclass
