/*****************SEQUENCE***********************/

class ahb_sequence extends uvm_sequence;
	`uvm_object_utils(ahb_sequence)
	
	ahb_transaction trans;
	age_config age_cn;

//----------------------constructor-------------------------------
function new(string name ="ahb_sequence");
	super.new(name);
endfunction


endclass

/******************RESET Sequence *****************/
 
class reset_sequence extends ahb_sequence;
	`uvm_object_utils(reset_sequence)

//----------------------constructor-------------------//
function new(string name = "reset_sequence");
	super.new(name);
endfunction


//------------task body-------------//
  task body();
  begin
	  trans = ahb_transaction::type_id::create("trans");
	  start_item(trans);
	  
	 //assert(trans.randomize()); 
	 
	 // assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b000; trans.trans == 2'b10; trans.addr == 32'h0; trans.wdata == 32'h1; trans.ready == 1'b1; trans.trans_length == 3'b001; });
	  
	  `uvm_info("AHB_Sequence","Reset sequences generated..",UVM_MEDIUM);
	  finish_item(trans);
  end
endtask 

endclass


/*****************WRITE READ SEQUENCE***********************/

class wr_rd_sequence extends ahb_sequence;
	`uvm_object_utils(wr_rd_sequence)

//----------------------constructor-------------------------------
function new(string name ="wr_rd_sequence");
	super.new(name);
endfunction


//------------task body-------------//
task body();
begin
	  trans = ahb_transaction::type_id::create("trans");

	  `uvm_info("AHB_Sequence","Single write read sequence generated..",UVM_MEDIUM);
	  
	  start_item(trans);
	 assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b010; trans.trans_type == 2'b10; trans.ready == 1'b1; trans.trans_length == 3'b011; trans.addr[0] == 16'h15; trans.addr[1] == 16'hab; trans.addr[2] == 16'h45; });
	finish_item(trans);
	get_response(rsp);



	start_item(trans);
	assert(trans.randomize() with {  trans.write == 1'b0; trans.size == 3'b010; trans.trans_type == 2'b10; trans.ready == 1'b1;  trans.trans_length == 3'b011; trans.addr[0] == 16'h15; trans.addr[1] == 16'hab; trans.addr[2] == 16'h45; });
	finish_item(trans);
	get_response(rsp);



	start_item(trans);
	assert(trans.randomize() with {  trans.write == 1'b0; trans.size == 3'b010; trans.trans_type == 2'b10; trans.ready == 1'b1;  trans.trans_length == 3'b010;  });
	finish_item(trans);
	get_response(rsp);
	
	//--------------checking with the response-------//
	for(int i=0; i<trans.trans_length; i++) begin
	if(trans.resp_wdata[i] == trans.rdata[i])
		`uvm_info("------- SEQUENCE DATA MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h  i = %0h",$time, trans.resp_wdata[i],trans.rdata[i], i),UVM_LOW )
	else 
		`uvm_info("------- SEQUENCE DATA MIS MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h i = %0h",$time, trans.resp_wdata[i], trans.rdata[i],i),UVM_LOW )
	
	 end
 end
endtask 

endclass


//---------------------------------------------------//
/***************** WRITE SEQUENCE***********************/
//--------------------------------------------------//

class wr_sequence extends ahb_sequence;
	`uvm_object_utils(wr_sequence)

//----------------------constructor-------------------------------
function new(string name ="wr_sequence");
	super.new(name);
endfunction


//------------task body-------------//

task body();
	
begin
	trans=ahb_transaction::type_id::create("trans");
	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b010; trans.trans_type == 2'b10; trans.addr[0] == 16'h15; trans.wdata[0] == 32'h1245; trans.addr[1] == 16'h25; trans.wdata[1] == 32'habc; trans.ready == 1'b1; trans.trans_length == 3'b010; trans.burst == 3'b000; });
		
	finish_item(trans);
	get_response(rsp);

	//--------------checking with the response-------//
	if(trans.resp_wdata == trans.rdata)
		`uvm_info("------- SEQUENCE DATA MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h",$time, trans.resp_wdata[0],trans.rdata[0]),UVM_LOW )
	else 
		`uvm_info("------- SEQUENCE DATA MIS MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h",$time, trans.resp_wdata[0], trans.rdata[0]),UVM_LOW )

	end 
endtask
endclass

//---------------------------------------------------//
/***************** WRITE WITH WAIT SEQUENCE***********************/
//--------------------------------------------------//

class wr_wait_sequence extends ahb_sequence;
	`uvm_object_utils(wr_wait_sequence)

//----------------------constructor-------------------------------
function new(string name ="wr_wait_sequence");
	super.new(name);
endfunction


//------------task body-------------//

task body();
	
begin
	trans=ahb_transaction::type_id::create("trans");
	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b010; trans.trans_type == 2'b10; trans.addr[0] == 16'h15; trans.wdata[0] == 32'h1245; trans.addr[1] == 16'h25; trans.wdata[1] == 32'habc; trans.ready == 1'b0; trans.trans_length == 3'b010; trans.burst == 3'b000; });
		
	finish_item(trans);
	get_response(rsp);
	//`uvm_info("------- DATA-------",$sformatf("[%0t] wdata = %0h rdata = %0h",$time, rsp.wdata[0],rsp.rdata[0]),UVM_LOW )
	end 
endtask
endclass


