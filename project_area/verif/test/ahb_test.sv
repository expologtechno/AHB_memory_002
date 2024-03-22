/************  TEST ********************/

class test extends uvm_test;
	`uvm_component_utils(test)

	//virtual ahb_intf intf_h;
	ahb_env env;
	env_config env_cn;
	age_config age_cn;
	//ahb_sequence seq;
	//virtual_sequence v_seq;
	 
extern function new(string name="test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass


//------------------CONSTRUCTOR----------------------

function test:: new(string name="test",uvm_component parent);
	super.new(name,parent);
endfunction


//------------BUILD PHASE------------
function void test:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("TEST",$sformatf("ENTERED TEST"),UVM_MEDIUM)

	env=ahb_env::type_id::create("env",this);
	env_cn=env_config::type_id::create("env_config",this);
	age_cn=age_config::type_id::create("age_cn",this);
//	seq = ahb_sequence :: type_id::create("seq",this);
       // v_seq = virtual_sequence :: type_id::create("v_seq",this);

	
	if(!uvm_config_db #(virtual ahb_intf)::get(this,"*","ahb_intf",age_cn.intf_h))
		`uvm_fatal("VIRTUAL_INTF","in ahb_test");

		env_cn.age_cn=age_cn;
		uvm_config_db #(env_config)::set(null,"*","env_config",env_cn);

endfunction


//-------------------end_of_elaboration---------------------------
 function void test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction



//----------------------------------------------------------//
/*****************************TEST CASE 1 - RESET test **********************/
//-------------------------------------------------------//

class reset_test extends test;

	`uvm_component_utils(reset_test)

virt_reset_seq v_reset_seq;
virtual_sequencer v_sequencer;


extern function new(string name="reset_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function reset_test::new(string name="reset_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void reset_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task reset_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

  phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
  v_reset_seq.start(env.v_seqr);
  #100;
  phase.drop_objection(this);

endtask







///***********************************************************************
//                                    TEST CASE 2 - multiple write read test
//***********************************************************************

class wr_rd_test extends test;

	`uvm_component_utils(wr_rd_test)

virt_reset_seq v_reset_seq;
virt_wr_rd_seq v_wr_rd_seq;
virtual_sequencer v_sequencer;


extern function new(string name="wr_rd_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function wr_rd_test::new(string name="wr_rd_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void wr_rd_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task wr_rd_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
  v_reset_seq.start(env.v_seqr);
  //#100;
  phase.drop_objection(this);

  
  phase.raise_objection(this);
  v_wr_rd_seq=virt_wr_rd_seq::type_id::create("v_wr_rd_seq");
  v_wr_rd_seq.start(env.v_seqr);
  #100;
  phase.drop_objection(this);

   phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
  v_reset_seq.start(env.v_seqr);
  //#100;
  phase.drop_objection(this);

  
  phase.raise_objection(this);
  v_wr_rd_seq=virt_wr_rd_seq::type_id::create("v_wr_rd_seq");
  v_wr_rd_seq.start(env.v_seqr);
  #100;
  phase.drop_objection(this);


endtask

///***********************************************************************
//                                    TEST CASE 3 -  write test
//***********************************************************************
class wr_test extends test;

	`uvm_component_utils(wr_test)

virt_reset_seq v_reset_seq;
virt_wr_seq v_wr_seq;
virtual_sequencer v_sequencer;


extern function new(string name="wr_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function wr_test::new(string name="wr_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void wr_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task wr_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
  v_reset_seq.start(env.v_seqr);
  //#100;
  phase.drop_objection(this);

  
  phase.raise_objection(this);
  v_wr_seq=virt_wr_seq::type_id::create("v_wr_seq");
  v_wr_seq.start(env.v_seqr);
  #100;
  phase.drop_objection(this);

endtask




///***********************************************************************
//                                    TEST CASE 4 - write with wait test
//***********************************************************************

class wr_wait_test extends test;

	`uvm_component_utils(wr_wait_test)

virt_reset_seq v_reset_seq;
virt_wr_wait_seq v_wr_wait_seq;
virtual_sequencer v_sequencer;


extern function new(string name="wr_wait_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function wr_wait_test::new(string name="wr_wait_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void wr_wait_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task wr_wait_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");

 //fork
   v_reset_seq.start(env.v_seqr);
  //#100;
  phase.drop_objection(this);

  
 phase.raise_objection(this);
   v_wr_wait_seq=virt_wr_wait_seq::type_id::create("v_wr_wait_seq");
 
   v_wr_wait_seq.start(env.v_seqr);
#200;
  //join
  phase.drop_objection(this);

endtask

///***********************************************************************
//                                    TEST CASE 5 -increment test
//***********************************************************************

class incr_test extends test;

	`uvm_component_utils(incr_test)

virt_reset_seq v_reset_seq;
virt_incr_seq v_incr_seq;
virtual_sequencer v_sequencer;


extern function new(string name="incr_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function incr_test::new(string name="incr_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void incr_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task incr_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
   v_reset_seq.start(env.v_seqr);
phase.drop_objection(this);

  
 phase.raise_objection(this);
   v_incr_seq=virt_incr_seq::type_id::create("v_incr_seq");
   v_incr_seq.start(env.v_seqr);
  phase.drop_objection(this);

endtask


///***********************************************************************
//                                    TEST CASE 6 - transfer size test
//***********************************************************************

class size_test extends test;

	`uvm_component_utils(size_test)

virt_reset_seq v_reset_seq;
virt_size_seq v_size_seq;
virtual_sequencer v_sequencer;


extern function new(string name="size_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function size_test::new(string name="size_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void size_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task size_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
   v_reset_seq.start(env.v_seqr);
phase.drop_objection(this);

  
 phase.raise_objection(this);
   v_size_seq=virt_size_seq::type_id::create("v_size_seq");
   v_size_seq.start(env.v_seqr);
  phase.drop_objection(this);

endtask


///***********************************************************************
//                                    TEST CASE 7 - transfer type test
//***********************************************************************

class type_test extends test;

	`uvm_component_utils(type_test)

virt_reset_seq v_reset_seq;
virt_type_seq v_type_seq;
virtual_sequencer v_sequencer;


extern function new(string name="type_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass  

//*********** constructor****************

function type_test::new(string name="type_test", uvm_component parent);
  super.new(name,parent);
endfunction	


//************** build phase*************

function void type_test:: build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction 

//*********** run phase****************


task type_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
`uvm_info("TEST","RUN_PHASE",UVM_MEDIUM)

 phase.raise_objection(this);
  v_reset_seq=virt_reset_seq::type_id::create("v_reset_seq");
   v_reset_seq.start(env.v_seqr);
phase.drop_objection(this);

  
 phase.raise_objection(this);
   v_type_seq=virt_type_seq::type_id::create("v_type_seq");
   v_type_seq.start(env.v_seqr);
   #50;
  phase.drop_objection(this);

endtask

