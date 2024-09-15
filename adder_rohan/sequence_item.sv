class seq_item extends uvm_sequence_item;
    rand bit en_i;
    rand bit in1;
    rand bit in2;
    bit out;
    bit en_o;

    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(en_i, UVM_ALL_ON)
        `uvm_field_int(in1 , UVM_ALL_ON)
        `uvm_field_int(in2 , UVM_ALL_ON)
        `uvm_field_int(out , UVM_ALL_ON)
        `uvm_field_int(en_o, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "seq_item");
        super.new(name);
    endfunction : new

endclass : seq_item
