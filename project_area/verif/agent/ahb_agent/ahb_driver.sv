//================================= DRIVER ==========================================/

class ahb_driver extends uvm_driver#(ahb_transaction);
	`uvm_component_utils(ahb_driver)
	 
	 virtual ahb_intf intf_h;
	 ahb_transaction trans;
	 age_config age_cn;

//--------------------------------------constructor-------------------------------	 
function new(string name="ahb_driver",uvm_component parent);
	super.new(name,parent);
endfunction

//--------------------------------------build_phase-------------------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

`uvm_info("DRIVER",$sformatf("ENTERED DRIVER"),UVM_MEDIUM)
	 
	trans=ahb_transaction::type_id::create("trans",this);

	if(!uvm_config_db#(age_config)::get(this,"*","age_config",age_cn))
		`uvm_fatal("MASTER_AGT_CONFIG","cannot get() ag_con_h from uvm_config");
	
endfunction

//----------------------------connect_phase--------------------------------------
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	intf_h=age_cn.intf_h;
`uvm_info("DRIVER",$sformatf("ENTERED CONNECT DRIVER"),UVM_MEDIUM)

endfunction



//------------------------------run_phase ---------------------------------------
task run_phase(uvm_phase phase);
		`uvm_info("DRIVER",$sformatf("ENTERED RUN DRIVER"),UVM_MEDIUM)

	forever begin
		seq_item_port.get_next_item(trans);
		for(int i=0; i<trans.trans_length; i++) begin
			if(trans.write)
			begin
			//	intf_h.dri_cb.hselx  <= trans.selx;
				intf_h.dri_cb.hselx  <= 1;
				intf_h.dri_cb.hready <= trans.ready;
				intf_h.dri_cb.hburst <= trans.burst;
				intf_h.dri_cb.hsize  <= trans.size;
				intf_h.dri_cb.hwrite <= trans.write;
				intf_h.dri_cb.htrans <= trans.trans_type;
				intf_h.dri_cb.haddr  <= trans.addr[i];
				@(posedge intf_h.hclk);
				intf_h.dri_cb.hwdata <= trans.wdata[i];
				trans.resp_wdata[i] = intf_h.dri_cb.hwdata;
				@(posedge intf_h.hclk);
			//	intf_h.dri_cb.hselx  <= 0;

			end
			else
			begin
				intf_h.dri_cb.hwrite <= trans.write;
				intf_h.dri_cb.hready <= trans.ready;
				//intf_h.dri_cb.hselx  <= trans.selx;
				intf_h.dri_cb.htrans <= trans.trans_type;
				intf_h.dri_cb.hselx  <= 1;
				//@(posedge intf_h.hclk);
				intf_h.dri_cb.haddr  <= trans.addr[i];
				@(posedge intf_h.hclk);
				trans.rdata[i]= intf_h.hrdata;
				//trans.resp_rdata[i] = trans.rdata[i];				
		//		@(posedge intf_h.hclk);
			//	intf_h.dri_cb.hselx  <= 0;
			end
	@(posedge intf_h.hclk);	
			$display($time,"=================================================================== DRIVER_DISPLAY_STARTED  ========================================\n" );
					`uvm_info("DRIVER ",$sformatf("[%0t] hselx=%0h  hwrite=%0h  hready=%0h  hburst =%0h  hsize=%0b  htrans=%0b  haddr=%0h  hwdata = %0h",$time,trans.selx, trans.write, trans.ready, trans.burst, trans.size, trans.trans_type, trans.addr[i], trans.wdata[i] ),UVM_LOW)
					`uvm_info("DRIVER ",$sformatf("[%0t] hselx=%0h  hwrite=%0h  hready=%0h  htrans=%0b haddr=%0h  hrdata = %0h",$time,trans.selx, trans.write, trans.ready, trans.trans_type, trans.addr[i],  trans.rdata[i]),UVM_LOW)
					
			$display($time,"====================================================================================================================================\n" );
			//rsp=trans;
		//	rsp.set_id_info(trans);
		rsp = ahb_transaction::type_id::create("rsp");
			rsp=trans;
		//rsp.data = virtual_interface.data;
		rsp.set_id_info(trans);
		end
	//	seq_item_port.put(rsp);
		
		seq_item_port.item_done(rsp);
	end


endtask
	 
endclass

