//******************** Virtual Sequence********************//

class virtual_sequence extends uvm_sequence#(ahb_transaction);
  `uvm_object_utils(virtual_sequence)
 virtual ahb_intf intf_h; 
  env_config env_cn;
  virtual_sequencer v_seqr;
  ahb_sequencer sequencer;
  reset_sequencer r_sequencer;
  ahb_sequence seq;

    
  extern function new(string name="virtual_sequence");
  extern task body(); 
endclass  

/***************** constructor************************/
function virtual_sequence::new(string name="virtual_sequence");
  super.new(name);

endfunction  

/*********************** task body**********************/
task virtual_sequence::body();
  env_cn=env_config::type_id::create("env_cn");
  $display("virtual sequence body");

if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cn))
  `uvm_fatal("virtual_sequence","getting env config unsuccessful")
  
  seq = ahb_sequence :: type_id::create("seq");

  assert($cast(v_seqr,m_sequencer))
  else begin
    `uvm_fatal("virtual sequence","casting failed")
    end 
  sequencer=v_seqr.sequencer;
  r_sequencer=v_seqr.r_sequencer;  
  $display(" After virtual sequence body");

  seq.start(sequencer);
  #10;
  seq.start(r_sequencer);  

endtask	
	


//---------------------------------------------------------------------------------//
///************************* Reset_sequence************************************************/
//------------------------------------------------------------//
class virt_reset_seq extends virtual_sequence; 
  `uvm_object_utils(virt_reset_seq)
  
  virtual_sequencer v_seqr;
  reset_sequence reset_seq;



/************** constructor*******************/
function new(string name="virt_reset_seq");
  super.new(name);
endfunction	

/****************** body**************************/
task  body();
  super.body();
  $display(" reset sequence task body");	
  reset_seq=reset_sequence::type_id::create("reset_seq");
  reset_seq.start(r_sequencer);
  $display("completed reset sequence task body");	
endtask  
endclass

//---------------------------------------------------------------------------------//
///*************************multi write_read_sequence************************************************/
//--------------------------------------------------------------------------------//
class virt_wr_rd_seq extends virtual_sequence; 
  `uvm_object_utils(virt_wr_rd_seq)
  
  virtual_sequencer v_seqr;
  wr_rd_sequence wr_rd_seq;



/************** constructor*******************/
function new(string name="virt_wr_rd_seq");
  super.new(name);
endfunction	

/****************** body**************************/
task  body();
  super.body();
  $display(" specific wr_rd sequence task body");	
  wr_rd_seq=wr_rd_sequence::type_id::create("wr_rd_seq");
  wr_rd_seq.start(sequencer);
  $display("completed wr_rd sequence task body");	
endtask  
endclass


//---------------------------------------------------------------------------------//
///************************* single write_sequence************************************************/
//------------------------------------------------------------------------------------/
class virt_wr_seq extends virtual_sequence; 
  `uvm_object_utils(virt_wr_seq)
  
  virtual_sequencer v_seqr;
  wr_sequence wr_seq;



//-************** constructor---------------------//
function new(string name="virt_wr_seq");
  super.new(name);
endfunction	

//-****************** body**************************-/
task  body();
  super.body();
  $display(" wr sequence task body");	
  wr_seq=wr_sequence::type_id::create("wr_seq");
  wr_seq.start(sequencer);
  $display("wr sequence task body completed");	
endtask  
endclass

//---------------------------------------------------------------------------------//
///************************* write_wait_sequence************************************************/
//------------------------------------------------------------------------------------/
class virt_wr_wait_seq extends virtual_sequence; 
  `uvm_object_utils(virt_wr_wait_seq)
  
  virtual_sequencer v_seqr;
  wr_wait_sequence wr_wait_seq;



//-************** constructor---------------------//
function new(string name="virt_wr_wait_seq");
  super.new(name);
endfunction	

//-****************** body**************************-/
task  body();
  super.body();
  $display(" wr sequence task body");	
  wr_wait_seq=wr_wait_sequence::type_id::create("wr_wait_seq");
  wr_wait_seq.start(sequencer);
  $display("wrsequence task body");	
endtask  
endclass

//---------------------------------------------------------------------------------//
///************************* increment_sequence************************************************/
//------------------------------------------------------------------------------------/
class virt_incr_seq extends virtual_sequence; 
  `uvm_object_utils(virt_incr_seq)
  
  virtual_sequencer v_seqr;
 incr_sequence incr_seq;



//-************** constructor---------------------//
function new(string name="virt_incr_seq");
  super.new(name);
endfunction	

//-****************** body**************************-/
task  body();
  super.body();
  $display(" increment sequence task body");	
  incr_seq=incr_sequence::type_id::create("incr_seq");
  incr_seq.start(sequencer);
  $display("increment sequence task body");	
endtask  
endclass

//---------------------------------------------------------------------------------//
///************************* transfer_size_sequence************************************************/
//------------------------------------------------------------------------------------/
class virt_size_seq extends virtual_sequence; 
  `uvm_object_utils(virt_size_seq)
  
  virtual_sequencer v_seqr;
 size_sequence size_seq;



//-************** constructor---------------------//
function new(string name="virt_size_seq");
  super.new(name);
endfunction	

//-****************** body**************************-/
task  body();
  super.body();
  $display("size sequence task body");	
  size_seq=size_sequence::type_id::create("size_seq");
  size_seq.start(sequencer);
  $display("size sequence task body");	
endtask  
endclass

//---------------------------------------------------------------------------------//
///************************* transfer_type_sequence************************************************/
//------------------------------------------------------------------------------------/
class virt_type_seq extends virtual_sequence; 
  `uvm_object_utils(virt_type_seq)
  
  virtual_sequencer v_seqr;
 type_sequence type_seq;



//-************** constructor---------------------//
function new(string name="virt_type_seq");
  super.new(name);
endfunction	

//-****************** body**************************-/
task  body();
  super.body();
  $display("type sequence task body");	
  type_seq=type_sequence::type_id::create("type_seq");
  type_seq.start(sequencer);
  $display("type sequence task body");	
endtask  
endclass


