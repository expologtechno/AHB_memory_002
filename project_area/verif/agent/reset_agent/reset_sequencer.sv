/************ RESET-SEQUENCER ********************/

class reset_sequencer extends uvm_sequencer#(ahb_transaction);
`uvm_component_utils(reset_sequencer)

	ahb_transaction trans;
	
//---------------------constructor----------------------------		
function new(string name="reset_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction


endclass
