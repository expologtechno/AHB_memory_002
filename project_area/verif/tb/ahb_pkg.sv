package pkg;
	
	import uvm_pkg::*;

	`include "uvm_macros.svh"

	`include "../agent/ahb_agent/ahb_seq_item.sv"
      
	`include "../agent/ahb_agent/age_config.sv"
	
	`include "env_config.sv"

	`include "../agent/ahb_agent/ahb_driver.sv"
	`include "../agent/ahb_agent/ahb_monitor.sv"
        `include "../agent/ahb_agent/ahb_sequencer.sv"
		`include "../agent/ahb_agent/ahb_agent.sv"
		`include "../../seqs/ahb_sequence.sv"

	//`include "reset_age_config.sv"
	`include "../agent/reset_agent/reset_sequencer.sv"
	`include "virtual_sequencer.sv"

	`include "virtual_sequence.sv"

	`include"ahb_scoreboard.sv"

	`include "../agent/reset_agent/reset_driver.sv"
	`include "../agent/reset_agent/reset_agent.sv"

	`include "ahb_env.sv"
	`include "../../test/ahb_test.sv"

//	`include "../agent/ahb_agent/ahb_coverage.sv"


endpackage
