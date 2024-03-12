/************  AGENT ********************/

class ahb_agent extends uvm_agent;

	`uvm_component_utils(ahb_agent)
       virtual ahb_intf intf_h;	
	 ahb_sequencer sequencer;
	 ahb_driver driver;
	 age_config age_cn;
	 ahb_monitor monitor;

//---------constructor------------------
function new(string name = "ahb_agent",uvm_component parent);
	super.new(name,parent);
endfunction

//---------------------build_phase----------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	`uvm_info("AHB_AGENT",$sformatf("ENTERED AGENT"),UVM_MEDIUM)

		if(!uvm_config_db#(age_config)::get(this,"*","age_config",age_cn))
	`uvm_fatal("MASTER_AGT_CONFIG","cannot get() ag_con_h from uvm_config");

	sequencer = ahb_sequencer::type_id::create("sequencer",this);
	driver = ahb_driver::type_id::create("driver",this);
	monitor = ahb_monitor::type_id::create("monitor",this);
	
	age_cn=age_config::type_id::create("age_cn",this);


endfunction

//----------------------connect_phase----------------------
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction
endclass



	

