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
			if(trans.size == 3'b000) begin     //byte
			    if(trans.addr[0][1:0] == 2'b00) begin    // byte0
				scb_mem[trans.addr[0]] = trans.wdata[0][7:0];
				`uvm_info(get_type_name(),$sformatf("scoreboard storing Byte0 of wdata"),UVM_LOW) 
			    end
			    
			    else if(trans.addr[0][1:0] == 2'b01) begin //byte1
				scb_mem[trans.addr[0]] = trans.wdata[0][15:8];
				`uvm_info(get_type_name(),$sformatf("scoreboard storing Byte1 of wdata"),UVM_LOW) 
			    end
			    
			    else if(trans.addr[0][1:0] == 2'b10) begin //byte2
				scb_mem[trans.addr[0]] = trans.wdata[0][23:16];
				`uvm_info(get_type_name(),$sformatf("scoreboard storing Byte2 of wdata"),UVM_LOW)
			    end
			    
			    else if(trans.addr[0][1:0] == 2'b11) begin  //byte3
				scb_mem[trans.addr[0]] = trans.wdata[0][31:24];
				`uvm_info(get_type_name(),$sformatf("scoreboard storing Byte3 of wdata"),UVM_LOW) 
			   end
		        end
			
			else if(trans.size == 3'b001)begin  //halfword
				if(trans.addr[0][1])begin
					scb_mem[trans.addr[0]] = trans.wdata[0][31:16];// Upper_halfword
					`uvm_info(get_type_name(),$sformatf("scoreboard storing upper halfword of wdata"),UVM_LOW) 
				end
				
				else begin
				scb_mem[trans.addr[0]] = trans.wdata[0][15:0]; // lower_halfword
				`uvm_info(get_type_name(),$sformatf("scoreboard storing lower halfword of wdata"),UVM_LOW) 
			        end
			end	
			
			else begin
			scb_mem[trans.addr[0]] = trans.wdata[0]; //whole word
				`uvm_info(get_type_name(),$sformatf("scoreboard storing wholeword of wdata"),UVM_LOW) 
			end
		
		end


	else if(!trans.write)begin
		if(scb_mem.exists(trans.addr[0]))begin
			if(trans.size == 3'b000) begin
				if(trans.addr[0][1:0] == 2'b00) begin
					if(scb_mem[trans.addr[0]] == trans.rdata[0][7:0]) begin  //byte0
					`uvm_info(get_type_name(),$sformatf("SCOREBOARD BYTE0 DATA MATCH"),UVM_LOW) 
          	     			`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][7:0]),UVM_LOW)
					end
				end
				else if(trans.addr[0][1:0] == 2'b01) begin
					if(scb_mem[trans.addr[0]] == trans.rdata[0][15:8]) begin  //byte1
					`uvm_info(get_type_name(),$sformatf("SCOREBOARD BYTE1 DATA MATCH"),UVM_LOW) 
          	     			`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][15:8]),UVM_LOW)
					
					end
				end
				
				else if(trans.addr[0][1:0] == 2'b10) begin
					if(scb_mem[trans.addr[0]] == trans.rdata[0][23:16]) begin  //byte2
					`uvm_info(get_type_name(),$sformatf("SCOREBOARD BYTE2 DATA MATCH"),UVM_LOW) 
          	     			`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][23:16]),UVM_LOW)
					
					end
				end
				
				else if(trans.addr[0][1:0] == 2'b11) begin
					if(scb_mem[trans.addr[0]] == trans.rdata[0][31:24]) begin //byte3
					`uvm_info(get_type_name(),$sformatf("SCOREBOARD BYTE3 DATA MATCH"),UVM_LOW)
          	     			`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][31:24]),UVM_LOW)
					
					end
				end
			end
			else if(trans.size == 3'b001 )begin
					if(trans.addr[0][1])begin
						if(scb_mem[trans.addr[0]] == trans.rdata[0][31:16]) begin  //upper halfword
						`uvm_info(get_type_name(),$sformatf("SCOREBOARD UPPER HALFWORD DATA MATCH"),UVM_LOW) 
          	     				`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][31:16]),UVM_LOW)
						end
					end
					else begin
						if(scb_mem[trans.addr[0]] == trans.rdata[0][15:0]) begin
						`uvm_info(get_type_name(),$sformatf("SCOREBOARD LOWER HALFWORD DATA MATCH"),UVM_LOW) //lower word
          	     				`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0][15:0]),UVM_LOW)
						end
					end
			end	
			
			else if(trans.size == 3'b010 || trans.size == 3'b011 || trans.size == 3'b100 || trans.size ==3'b101 || trans.size == 3'b110 || trans.size == 3'b111  )begin  //default
				if(scb_mem[trans.addr[0]] == trans.rdata[0] ) begin
					`uvm_info(get_type_name(),$sformatf("SCOREBOARD WHOLE DATA MATCH"),UVM_LOW) //whole word
					`uvm_info(get_type_name(),$sformatf(" Addr :%0h  Expected Data: %0h Actual Data: %0h",trans.addr[0], scb_mem[trans.addr[0]],trans.rdata[0]),UVM_LOW)
					end
			end
	else begin
		`uvm_error(get_type_name(),"SCOREBOARD RDATA MISMATCH")
          	`uvm_error(get_type_name(),$sformatf("Addr:%0h Expected Data: %0h Actual Data: %0h",trans.addr[0],scb_mem[trans.addr[0]],trans.rdata[0]))
	end
end
end
		
	/*	if(trans.write)
			scb_mem[trans.addr[0]] = trans.wdata[0];
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
	end*/

end
endtask


endclass




