//================================= RESET-DRIVER ==========================================/

class reset_driver extends uvm_driver#(ahb_transaction);
	`uvm_component_utils(reset_driver)
	 
	 virtual ahb_intf intf_h;
	 ahb_transaction trans;
	 age_config age_cn;

//--------------------------------------constructor-------------------------------	 
function new(string name="reset_driver",uvm_component parent);
	super.new(name,parent);
endfunction

//--------------------------------------build_phase-------------------------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);

`uvm_info("RESET_DRIVER",$sformatf("ENTERED RESET_DRIVER"),UVM_MEDIUM)
	 
	trans=ahb_transaction::type_id::create("trans",this);

	if(!uvm_config_db#(age_config)::get(this,"*","age_config",age_cn))
		`uvm_fatal("AGT_CONFIG","cannot get() ag_con_h from uvm_config");
	
endfunction

//----------------------------connect_phase--------------------------------------
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	intf_h=age_cn.intf_h;
`uvm_info("DRIVER",$sformatf("ENTERED CONNECT of RESET_DRIVER"),UVM_MEDIUM)

endfunction

//------------------------------run_phase ---------------------------------------
task run_phase(uvm_phase phase);
		`uvm_info("DRIVER",$sformatf("ENTERED RUN RESET_DRIVER"),UVM_MEDIUM)

	forever begin

		seq_item_port.get_next_item(trans);
	//@(posedge intf_h.hclk);
		intf_h.hresetn <= 0;
		intf_h.hselx  <= 0;
		intf_h.hwdata <=0;
		intf_h.hready <=0;
		intf_h.hburst <=0;
		intf_h.hsize  <=0;
		intf_h.hwrite <=0;
		intf_h.htrans <=0;
		intf_h.haddr  <=0;

		@(posedge intf_h.hclk);
		intf_h.hresetn <= 1;
		
		$display($time,"=================================================================== RESET DRIVER_DISPLAY_STARTED  ========================================\n" );
		`uvm_info("RESET DRIVER ",$sformatf("[%0t] hresetn=%0h",$time,intf_h.hresetn),UVM_LOW)
		
		$display($time,"====================================================================================================================================\n" );
		seq_item_port.item_done();
	end


endtask


endclass
