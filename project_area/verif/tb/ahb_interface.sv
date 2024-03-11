/************** INTERFACE ***************/

interface ahb_intf(input bit hclk);

	
	logic hresetn;
	logic [15:0] haddr;
	logic [31:0] hwdata;
	logic [31:0] hrdata;
	logic hwrite;
	logic hreadyout;
	logic hresp;
	logic hselx;
	logic hmastlock;
	logic hready;
	logic [2:0] hburst;	
	logic [3:0] hprot;
	logic [2:0] hsize;
	logic [1:0] htrans;


//--------DRIVER_CLOCKING_BLOCK-----------------
	
clocking dri_cb @(posedge hclk);
	default input #0 output #1;
	input hrdata;
	input hreadyout;
	input hresp;
	
	output hready;
	output hresetn;
	output hwdata;
	output haddr;
	output hwrite;
	output hselx;
	output hmastlock;
	output hburst;
	output hprot;
	output hsize;
	output htrans;
	
endclocking


//-------MONITOR_CLOCKING_BLOCK-----------------
clocking mon_cb@(posedge hclk);
	default input #0 output #1;
	input hclk;
	input hresetn;
	input hrdata;
	input hreadyout;
	input hresp;
	input hready;
	input hwdata;
	input haddr;
	input hwrite;
	input hselx;
	input hmastlock;
	input hburst;
	input hprot;
	input hsize;
	input htrans;
endclocking






//----------------MODPORT----------------------

modport monitor_mp(clocking mon_cb);

modport driver_mp(clocking dri_cb);
	
	

endinterface



