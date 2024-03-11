/************ RESET-AGENT ********************/

class reset_agent extends uvm_agent;

	`uvm_component_utils(reset_agent)
       virtual ahb_intf intf_h;	
       	
	 reset_sequencer r_sequencer;
	 reset_driver r_driver;
	 age_config age_cn;

//---------constructor------------------
function new(string name = "reset_agent",uvm_component parent);
	super.new(name,parent);
endfunction

//---------------------build_phase----------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	`uvm_info("RESET_AGENT",$sformatf("ENTERED_RESET_AGENT"),UVM_MEDIUM)

		if(!uvm_config_db#(age_config)::get(this,"*","age_config",age_cn))
	`uvm_fatal("AGT_CONFIG","cannot get() ag_con_h from uvm_config");
	
	r_sequencer = reset_sequencer :: type_id::create("r_sequencer",this);
	r_driver = reset_driver::type_id::create("r_driver",this);
	age_cn=age_config::type_id::create("age_cn",this);


endfunction

//----------------------connect_phase----------------------
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	r_driver.seq_item_port.connect(r_sequencer.seq_item_export);
endfunction
endclass




