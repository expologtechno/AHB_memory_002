//======================= TRANSACTION =====================================/
class ahb_transaction extends uvm_sequence_item;

`uvm_object_utils(ahb_transaction)

	rand 	bit[15:0] addr[10];
	rand 	bit[31:0] wdata[10];
	rand	bit write;
	rand	bit ready;
	rand 	bit[2:0] burst;	
	rand 	bit[3:0] prot;
	rand 	bit[2:0] size;
	rand 	bit[1:0] trans_type;
       	rand	bit[2:0] trans_length;

		bit readyout;
		bit resp;
		bit selx ;
		bit mastlock;
		bit[31:0] rdata[10];

		bit [31:0] resp_wdata[10];
		bit [31:0] resp_rdata[10];
		

//--------------------------constructor--------------------------------	
function new(string name="ahb_transaction");
super.new(name);
endfunction

	
endclass

