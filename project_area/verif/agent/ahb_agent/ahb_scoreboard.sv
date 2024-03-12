//=====================================SCOREBOARD========================================/

class ahb_scoreboard extends uvm_scoreboard;
  	`uvm_component_utils(ahb_scoreboard)

ahb_transaction trans;
reg [31:0] scb_mem [bit [15:0]] ;

uvm_tlm_analysis_fifo#(ahb_transaction) analysis_fifo;

//---------------------------------constructor---------------------------------------------
function new(string name="ahb_scoreboard", uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------------------------build_phase-------------------------------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	analysis_fifo = new("analysis_fifo",this);

	`uvm_info("SCOREBOARD","BUILD_PHASE" ,UVM_LOW )
endfunction




//--------------------------------------run_phase---------------------------------------------
virtual task run_phase(uvm_phase phase);
	forever begin
		analysis_fifo.get(trans);
		
		if(trans.write) begin
		scb_mem[trans.addr[0]] = trans.wdata[0];
	end
	else if(!trans.write)begin
		if(scb_mem.exists(trans.addr[0]))begin
			if(scb_mem[trans.addr[0]] == trans.rdata[0]) begin
			`uvm_info(get_type_name(),$sformatf("------SCOREBOARD_READ_DATA_MATCHED------"),UVM_LOW)
          	     	`uvm_info(get_type_name(),$sformatf(" Address= %0h  Expected Data= %0h Actual Data= %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0]),UVM_LOW)
		end
		else begin
			`uvm_error(get_type_name(),"------SCOREBOARD_READ_DATA_MISMATCH------")
          	    	`uvm_error(get_type_name(),$sformatf("Address= %0h Expected Data= %0h Actual Data= %0h",trans.addr[0],scb_mem[trans.addr[0]],trans.rdata[0]))
 		 end
		end
	end
end
endtask


endclass



























//=====================================SCOREBOARD========================================/

/*class ahb_scoreboard extends uvm_scoreboard;
  	`uvm_component_utils(ahb_scoreboard)

	ahb_transaction trans;
	pass_transaction pass_trans;

`uvm_analysis_imp_decl(_analy_mon)
`uvm_analysis_imp_decl(_analy_passive)

	pass_transaction ptrans_qu[$];
	ahb_transaction trans_qu[$];


reg [31:0] sc_mem [bit [15:0]] ;
uvm_analysis_imp_analy_mon#(ahb_transaction,ahb_scoreboard) analy_mon;
uvm_analysis_imp_analy_passive#(pass_transaction,ahb_scoreboard) analy_passive;

//---------------------------------constructor---------------------------------------------
function new(string name="ahb_scoreboard", uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------------------------build_phase-------------------------------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	analy_mon = new("analy_mon",this);
	analy_passive = new("analy_passive",this);

	`uvm_info("SCOREBOARD","BUILD_PHASE" ,UVM_LOW )
endfunction

//-----------------------implementing_write_method-----------------------------------
virtual function void write_analy_passive(pass_transaction pass_trans);
ptrans_qu.push_back(pass_trans);
endfunction

//-----------------------implementing_write_method-----------------------------------
virtual function void write_analy_mon(ahb_transaction trans);
trans_qu.push_back(trans);
endfunction

//--------------------------------------run_phase---------------------------------------------
virtual task run_phase(uvm_phase phase);

	`uvm_info("SCOREBOARD","RUN_PHASE" ,UVM_LOW )
forever begin

	wait(ptrans_qu.size()>0 && trans_qu.size()>0);
	trans = trans_qu.pop_front();
	pass_trans = ptrans_qu.pop_front();
	



if(trans.write) 
		begin
			sc_mem[trans.addr[0]] = trans.wdata[0];
		`uvm_info(get_type_name(),$sformatf("------ :: WRITE_DATA       :: ------"),UVM_LOW)
        	`uvm_info(get_type_name(),$sformatf("Addr: %0h",trans.addr[0]),UVM_LOW)
       	 	`uvm_info(get_type_name(),$sformatf("Data: %0h",trans.wdata[0]),UVM_LOW)
       	 	`uvm_info(get_type_name(),$sformatf("mem_data: %0h",sc_mem[trans.addr[0]]),UVM_LOW)
		end

	else if(!trans.write)
		begin

			 if(sc_mem[trans.addr[0]] == pass_trans.prdata[0])
			 begin
			`uvm_info(get_type_name(),$sformatf("------ :: READ_DATA_Match :: ------"),UVM_LOW)
          		`uvm_info(get_type_name(),$sformatf("Addr: %0h",trans.addr[0]),UVM_LOW)
          		`uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[trans.addr[0]],pass_trans.prdata[0]),UVM_LOW)
			end
	else
	       		begin
			`uvm_info(get_type_name(),"------ :: READ_DATA_MisMatch :: ------",UVM_LOW)
          		`uvm_info(get_type_name(),$sformatf("Addr: %0h",trans.addr[0]),UVM_LOW)
          		`uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[trans.addr[0]],pass_trans.prdata[0]),UVM_LOW)
 		 	end
		end

	
	
end
endtask


endclass*/
