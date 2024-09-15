`include "uvm_pkg.sv"
package dutMem_pkg;
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	`include "dutMem_defines.svh"
	`include "dutMem_sequence_item.sv"
	`include "dutMem_sequence.sv"
	`include "dutMem_driver.sv"
	`include "dutMem_monitorA.sv"
	`include "dutMem_monitorP.sv"
	`include "dutMem_scoreboard.sv"
	`include "dutMem_active_agent.sv"
	`include "dutMem_passive_agent.sv"
	`include "dutMem_env.sv"
	`include "dutMem_test.sv"
	
endpackage : dutMem_pkg
