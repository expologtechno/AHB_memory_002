/************  ENVIRONMENT ********************/


class ahb_env extends uvm_env;

	`uvm_component_utils(ahb_env)
	
	
	ahb_agent age;
	ahb_scoreboard scoreboard;
	reset_agent r_agent;
	//ahb_sequencer sequencer;
	virtual_sequencer v_seqr;
	//reset_sequencer r_sequencer;
	//reset_age_config r_age_cn;
	age_config age_cn;
	env_config env_cn;

	
extern function new(string name="ahb_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern function void report();	
endclass

//------------------CONSTRUCTOR---------------------

function ahb_env::new(string name="ahb_env",uvm_component parent);
	super.new(name,parent);
endfunction

//---------------------BUILD PHASE--------------------

function void ahb_env::build_phase(uvm_phase phase);
	super.build_phase(phase);

	`uvm_info("ENV",$sformatf("ENTERED ENV"),UVM_MEDIUM)

	env_cn=env_config::type_id::create("env_config",this);
	if(!uvm_config_db #(env_config)::get(this,"*","env_config",env_cn))
		begin
			`uvm_fatal("ENV_CONFIG","CANNOT GET CONGIF FROM UVM_CONFIG");

		end

	age=ahb_agent::type_id::create("age",this);
	scoreboard = ahb_scoreboard ::type_id::create("scoreboard",this);
	r_agent = reset_agent::type_id::create("r_agent",this);
	age_cn=age_config::type_id::create("age_cn",this);
	v_seqr=virtual_sequencer::type_id::create("v_seqr",this);
	
//set interface to agent		
	uvm_config_db#(age_config)::set(this,"*","age_config",env_cn.age_cn);
		
endfunction


//-----------------------------connect_phase------------------------
function void ahb_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	v_seqr.sequencer=age.sequencer;
	v_seqr.r_sequencer=r_agent.r_sequencer;

	age.monitor.analysis_port.connect(scoreboard.analysis_fifo.analysis_export);
	
endfunction


//*********************************Report for checking error************************************************

function void ahb_env::report();
uvm_report_server reportserver=uvm_report_server::get_server();
$display("***************************************************************************************************************************************************************");
$display("--------------------------------------------------------------------test_summary-------------------------------------------------------------------------------");
$display("***************************************************************************************************************************************************************");

//report_header();
//report_summarize();
$display("****************************************************************************************************************************************************************");

$display("--------final test status--------");
if(reportserver.get_severity_count(UVM_FATAL)==0 && reportserver.get_severity_count(UVM_ERROR)==0)
begin
$display("============================================================================================================");
$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TEST PASSED~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
$display("============================================================================================================");
end
else
begin
$display("============================================================================================================");
$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TEST FAILED~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
$display("============================================================================================================");
end
endfunction
