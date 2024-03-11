//************** Virtual Sequencer *********//


class virtual_sequencer extends  uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)
    
    env_config env_cn; 
    ahb_sequencer sequencer; 
    reset_sequencer r_sequencer;

    extern function new(string name="virtual_sequencer", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
endclass


/***************** constructor**************************/
function virtual_sequencer::new(string name="virtual_sequencer", uvm_component parent);
  super.new(name,parent);
endfunction  

/******************** build phase******************/

function void virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
   env_cn=env_config::type_id::create("env_cn",this);
   sequencer =ahb_sequencer::type_id::create("sequencer",this);
   r_sequencer = reset_sequencer :: type_id :: create("r_sequencer",this);

  if(!uvm_config_db#(env_config)::get(this,"*","env_config",env_cn))
    `uvm_fatal("virt_sequencer","getting env config unsuccessful")
  	  
endfunction    

