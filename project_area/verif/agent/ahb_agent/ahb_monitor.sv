//======================================= MONITOR ====================================/

class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)
	
	ahb_transaction trans;
	virtual ahb_intf intf_h;
	age_config age_cn;

uvm_analysis_port#(ahb_transaction) analysis_port;

//-------------------constructor-----------------------
function new(string name="ahb_monitor",uvm_component parent);
	super.new(name,parent);
	trans=new();
	analysis_port = new("analysis_port",this);
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
		wait(intf_h.mon_cb.hselx);	
		if( intf_h.mon_cb.hwrite) 
		begin
			trans.write =  intf_h.mon_cb.hwrite;
			trans.ready    =  intf_h.mon_cb.hready;
			//trans.brust  =  intf_h.mon_cb.hbrust;
			trans.size       =  intf_h.mon_cb.hsize;
			trans.trans_type =  intf_h.mon_cb.htrans;
			//trans.selx     =  intf_h.mon_cb.hselx;
			//@(posedge intf_h.hclk);
			trans.addr[0]    =  intf_h.mon_cb.haddr;
			@(posedge intf_h.hclk);
			trans.wdata[0]    =  intf_h.mon_cb.hwdata;
		end
		else 
		begin
			trans.write    =  intf_h.mon_cb.hwrite;
			trans.ready    =  intf_h.mon_cb.hready;
			//trans.selx     =  intf_h.mon_cb.hselx;
			trans.trans_type    =  intf_h.mon_cb.htrans;
			trans.addr[0]    =  intf_h.mon_cb.haddr;
			@(posedge intf_h.hclk);
			trans.rdata[0] =  intf_h.mon_cb.hrdata;
		end
		$display($time,"===================================== MONITOR_DISPLAY_STARTED  ==========================\n" );
		`uvm_info("MONITOR",$sformatf("[%0t] write=%0h trans=%0h intf_h.mon_cb.hselx=%0b addr=%0h  wdata = %0h",$time,trans.write, trans.trans_type, intf_h.mon_cb.hselx, trans.addr[0], trans.wdata[0]),UVM_LOW)
		`uvm_info("MONITOR",$sformatf("[%0t] write=%0h trans=%0h intf_h.mon_cb.hselx=%0b addr=%0h  rdata = %0h",$time,trans.write, trans.trans_type, intf_h.mon_cb.hselx, trans.addr[0],  trans.rdata[0]),UVM_LOW)
		
		$display($time,"=====================================================================================================================================\n" );

		analysis_port.write(trans);

	end
endtask



endclass



