typedef enum {MEM_READ, MEM_WRITE} WR_RD;
class memory_seq_item extends uvm_sequence_item;

    rand bit [15:0] wdata;
    rand bit [7:0] addr;
    rand WR_RD wr_rd;
    rand int transmit_delay;
    bit [15:0] rdata;
    bit [7:0] written_addr[$];

    `uvm_object_utils_begin(memory_seq_item)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_enum(WR_RD, wr_rd, UVM_ALL_ON)
        `uvm_field_int(transmit_delay, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_object_utils_end

    function new(string name = "memory_seq_item");
        super.new(name);
    endfunction : new

endclass : memory_seq_item
