`include "uvm_pkg.sv"
package mem_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "mem_seq_itm.sv"
	`include "mem_seq.sv"
	`include "mem_driver.sv"
	`include "mem_out_monitor.sv"
	`include "mem_driver_monitor.sv"
	`include "agent_drv_mon.sv"
	`include "agent_mon.sv"
	`include "mem_scoreboard.sv"
	`include "mem_environment.sv"
	`include "mem_test.sv"
endpackage : mem_pkg