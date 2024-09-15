typedef enum {MEM_READ, MEM_WRITE} WR_RD;
class memory_seq_item #(int data_width = 16, addr_width=8) extends uvm_sequence_item;

    rand bit [data_width-1:0] wdata;
    rand bit [addr_width-1:0] addr;
    rand WR_RD wr_rd;
    bit [data_width-1:0] rdata;

    `uvm_object_utils_begin(memory_seq_item)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_enum(WR_RD, wr_rd, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "memory_seq_item", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : memory_seq_item
