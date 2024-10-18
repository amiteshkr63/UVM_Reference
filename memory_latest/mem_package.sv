// `define UVM_HDL_NO_DPI
`include "uvm_pkg.sv"
package mem_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "mem_sequence_item.sv"
	`include "mem_sequence.sv"
	`include "mem_driver.sv"	
	`include "mem_monitor.sv"
	`include "mem_scoreboard.sv"
	`include "mem_agent.sv"
	`include "mem_environment.sv"
	`include "mem_test.sv"	
endpackage : mem_pkg