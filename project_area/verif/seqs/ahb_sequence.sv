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


/*****************MULTIPLE WRITE READ SEQUENCE***********************/

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
	 assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b000; trans.trans_type == 2'b10; trans.ready == 1'b1; trans.trans_length == 3'b011; trans.addr[0] == 16'h15; trans.addr[1] == 16'hab; trans.addr[2] == 16'h45; });
	finish_item(trans);
	get_response(rsp);



	start_item(trans);
	assert(trans.randomize() with {  trans.write == 1'b0; trans.size == 3'b000; trans.trans_type == 2'b10; trans.ready == 1'b1;  trans.trans_length == 3'b011; trans.addr[0] == 16'h15; trans.addr[1] == 16'hab; trans.addr[2] == 16'h45; });
	finish_item(trans);
	get_response(rsp);


 end
endtask 

endclass


//---------------------------------------------------//
/*****************Single WRITE SEQUENCE***********************/
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
		 assert(trans.randomize() with {  trans.write == 1'b1; trans.size == 3'b000; trans.trans_type == 2'b10; trans.addr[0] == 16'hff11; trans.ready == 1'b1; trans.trans_length == 3'b001; trans.burst == 3'b000; });
		
	finish_item(trans);
	get_response(rsp);


		start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b0; trans.size == 3'b000; trans.trans_type == 2'b10; trans.addr[0] == 16'hff11; trans.ready == 1'b1; trans.trans_length == 3'b001; trans.burst == 3'b000; });
		
	finish_item(trans);
	get_response(rsp);

	//--------------checking with the response-------//
	
/*	if(trans.resp_wdata == trans.rdata)
		`uvm_info("------- SEQUENCE DATA MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h",$time, trans.resp_wdata[0],trans.rdata[0]),UVM_LOW )
	else 
		`uvm_info("------- SEQUENCE DATA MIS MATCH-------",$sformatf("[%0t] wdata = %0h rdata = %0h",$time, trans.resp_wdata[0], trans.rdata[0]),UVM_LOW )*/

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
		 assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b001; 
						trans.addr[0] == 16'h21; trans.wdata[0] == 32'habc;   
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001;  trans.trans_type == 2'b10; });	
	finish_item(trans);
	get_response(rsp);
	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b001; 
						trans.addr[0] == 16'h21; trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });
	finish_item(trans);
	get_response(rsp);


	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; trans.selx == 1'b0;
		 				trans.size == 3'b000;   trans.ready == 1'b0; 
						trans.trans_length == 3'b001; trans.addr[0] == 16'hab;
						trans.trans_type == 2'b10; });
		
	finish_item(trans);
	get_response(rsp);

	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b0; trans.selx == 1'b1;
		 				trans.size == 3'b000;   trans.ready == 1'b0; 
						trans.trans_length == 3'b001; trans.addr[0] == 16'hab;
						trans.trans_type == 2'b10; });
		
	finish_item(trans);
	get_response(rsp);


		start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; 
		 					trans.size == 3'b000;   trans.ready == 1'b1; 
							trans.trans_length == 3'b001; trans.trans_type == 2'b10;
							trans.addr[0] == 16'h13;   });
	finish_item(trans);
	get_response(rsp);
//	repeat(3) begin
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b0;
		 				trans.size == 3'b000;   trans.ready == 1'b0; 
						trans.trans_length == 3'b001; 
						trans.trans_type == 2'b10; });
		
	finish_item(trans);
	get_response(rsp);
//end


start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b000;   trans.ready == 1'b1; 
						trans.trans_length == 3'b001; 
						trans.trans_type == 2'b10;trans.addr[0] == 16'h13;  });
	finish_item(trans);
	get_response(rsp);


	end 
endtask
endclass


//---------------------------------------------------//
/*****************Increment burst***********************/
//--------------------------------------------------//

class incr_sequence extends ahb_sequence;
	`uvm_object_utils(incr_sequence)

//----------------------constructor-------------------------------
function new(string name ="incr_sequence");
	super.new(name);
endfunction


//------------task body-------------//

task body();
	
begin
	trans=ahb_transaction::type_id::create("trans");
	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b010; trans.selx == 1'b1;
						trans.addr[0] == 16'h35; trans.wdata[0] == 32'h254;   
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
	finish_item(trans);
	get_response(rsp);
	
	start_item(trans);
		 assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b000; 
						trans.addr[0] == 16'h40;trans.wdata[0] == 8'h12; trans.wdata[1] == 8'hfe; trans.wdata[2] == 8'h66;    
						trans.ready == 1'b1; 
						 trans.trans_type == 2'b11; });
	finish_item(trans);
	get_response(rsp);



	end 
endtask
endclass


//---------------------------------------------------//
/*****************Transfer size***********************/
//--------------------------------------------------//

class size_sequence extends ahb_sequence;
	`uvm_object_utils(size_sequence)

//----------------------constructor-------------------------------
function new(string name ="size_sequence");
	super.new(name);
endfunction


//------------task body-------------//

task body();
	
begin
	trans=ahb_transaction::type_id::create("trans");
	
	//for(int i=0;i<=3; i++) begin
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b000; trans.addr[0] == 16'h00; 
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);
		
				start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b000; trans.addr[0] == 16'h00; 
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);
			
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b001; trans.addr[0] == 16'h0016;  
						trans.ready == 1'b1; trans.trans_length == 3'b001;
						 trans.trans_type == 2'b10; });
	 	finish_item(trans);
		get_response(rsp);
		
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b001; trans.addr[0] == 16'h0016;
						trans.ready == 1'b1; trans.trans_length == 3'b001;
						 trans.trans_type == 2'b10; });
	 	finish_item(trans);
		get_response(rsp);


		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b010; trans.addr[0] == 16'h50; 
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);
		
		
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b010; trans.addr[0] == 16'h50;
						trans.ready == 1'b1; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);
		

		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b011;trans.addr[0] == 16'h29;  
						trans.ready == 1'b1; trans.trans_length == 3'b001;
						 trans.trans_type == 2'b10; });
	 	finish_item(trans);
		get_response(rsp);



		
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b011; trans.addr[0]==16'h29;
						trans.ready == 1'b1; trans.trans_length == 3'b001;
						 trans.trans_type == 2'b10; });
	 	finish_item(trans);
		get_response(rsp);
	
		
	//end 
end 
endtask
endclass



//---------------------------------------------------//
/*****************Transfer type***********************/
//--------------------------------------------------//

class type_sequence extends ahb_sequence;
	`uvm_object_utils(type_sequence)

//----------------------constructor-------------------------------
function new(string name ="type_sequence");
	super.new(name);
endfunction


//------------task body-------------//

task body();
	
begin
	trans=ahb_transaction::type_id::create("trans");
	
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h0011; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b00; });	
		finish_item(trans);
		get_response(rsp);

			start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h0013; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b01; });	
		finish_item(trans);
		get_response(rsp);

	
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h28; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);

		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b1; 
		 				trans.size == 3'b100; 
						trans.ready == 1'b1; trans.addr[0]== 16'h36; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b11; });	
		finish_item(trans);
		get_response(rsp);

//////////////////////////////////////////////////
		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h0011; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b00; });	
		finish_item(trans);
		get_response(rsp);

				start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h0013; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b01; });	
		finish_item(trans);
		get_response(rsp);

		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b010; 
						trans.ready == 1'b1; trans.addr[0]== 16'h28; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b10; });	
		finish_item(trans);
		get_response(rsp);

		start_item(trans);
		assert(trans.randomize() with {  trans.write == 1'b0; 
		 				trans.size == 3'b100; 
						trans.ready == 1'b1; trans.addr[0]== 16'h36; 
						trans.trans_length == 3'b001; trans.trans_type == 2'b11; });	
		finish_item(trans);
		get_response(rsp);



	
end 
endtask
endclass

