//======================================= MONITOR ====================================/

class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)
	
	ahb_transaction trans;
	virtual ahb_intf intf_h;
	age_config age_cn;
	ahb_transaction cov_trans;

uvm_analysis_port#(ahb_transaction) analysis_port;

//coverage
covergroup ahb_cg;
	option.per_instance=1;

	 WRITE: coverpoint cov_trans.write 
		{bins read ={0}; 
		 bins write ={1}; }

         TRANS: coverpoint cov_trans.trans_type 
		{bins idle={0}; 
		 bins busy={1}; 
		 bins non_seq={2}; 
		 bins seq={3};}

         SIZE: coverpoint cov_trans.size
		{bins b0={0}; 
		 bins b1={1}; 
		 bins b2={2}; } 

         ADDR: coverpoint cov_trans.addr[0]
	 	{ bins adr_bin={[0:65535]};}

         WDATA: coverpoint cov_trans.wdata[0]
	 	{ bins wdata_bin = {[0:32'hffffffff]};}
         /*RESP: coverpoint cov_trans.resp
		{bins b0 ={0}; 
		 bins b1 ={1}; }*/
         READY: coverpoint cov_trans.ready
		{bins b0 ={0}; 
		 bins b1 ={1}; }
 
             
        endgroup


//-------------------constructor-----------------------
function new(string name="ahb_monitor",uvm_component parent);
	super.new(name,parent);
	trans=new();
	analysis_port = new("analysis_port",this);
	ahb_cg=new();
endfunction
	
//-----------------------build_phase----------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("MONITOR",$sformatf("ENTERED MONITOR"),UVM_MEDIUM)

	if(!uvm_config_db#(age_config)::get(this,"*","age_config",age_cn))
	`uvm_fatal("MASTER_AGT_CONFIG","cannot get() ag_con_h from uvm_config");


endfunction

//--------------------------connect_phase----------------------
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	intf_h= age_cn.intf_h;
endfunction


//----------------------run_phase-------------------------------
task run_phase(uvm_phase phase);

trans=ahb_transaction::type_id::create("trans");
	`uvm_info("ahb_monitor","monitor run phase", UVM_LOW)

	forever begin
		@(posedge intf_h.hclk);
		if(intf_h.mon_cb.hselx) begin	
			if( intf_h.mon_cb.hwrite) begin
			trans.write =  intf_h.mon_cb.hwrite;
			trans.ready    =  intf_h.mon_cb.hready;
			//trans.brust  =  intf_h.mon_cb.hbrust;
			trans.size       =  intf_h.mon_cb.hsize;
			trans.trans_type =  intf_h.mon_cb.htrans;
			//trans.selx     =  intf_h.mon_cb.hselx;
		//	@(posedge intf_h.hclk);
			trans.addr[0]    =  intf_h.mon_cb.haddr;
			@(posedge intf_h.hclk);
			trans.wdata[0]    =  intf_h.mon_cb.hwdata;

			cov_trans=trans;
			ahb_cg.sample();	
		       end
		       else begin
			trans.write    =  intf_h.mon_cb.hwrite;
			trans.ready    =  intf_h.mon_cb.hready;
			trans.size     = intf_h.mon_cb.hsize;
			//trans.selx     =  intf_h.mon_cb.hselx;
			trans.trans_type    =  intf_h.mon_cb.htrans;
			trans.addr[0]    =  intf_h.mon_cb.haddr;
			@(posedge intf_h.hclk);
			trans.rdata[0] =  intf_h.mon_cb.hrdata;
			
			cov_trans=trans;
			ahb_cg.sample();	

		       end
		       analysis_port.write(trans);
	end
		$display($time,"===================================== MONITOR_DISPLAY_STARTED  ==========================\n" );
		`uvm_info("MONITOR",$sformatf("[%0t] write=%0h trans=%0h intf_h.mon_cb.hselx=%0b addr=%0h  wdata = %0h",$time,trans.write, trans.trans_type, intf_h.mon_cb.hselx, trans.addr[0], trans.wdata[0]),UVM_LOW)
		`uvm_info("MONITOR",$sformatf("[%0t] write=%0h trans=%0h intf_h.mon_cb.hselx=%0b addr=%0h  rdata = %0h",$time,trans.write, trans.trans_type, intf_h.mon_cb.hselx, trans.addr[0],  trans.rdata[0]),UVM_LOW)
		
		$display($time,"=====================================================================================================================================\n" );
//ahb_cg.sample();
		//analysis_port.write(trans);
end
endtask



endclass



