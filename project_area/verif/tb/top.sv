//`include "cmsdk_ahb_memory_models_defs.v"
`include "../../rtl/cmsdk_ahb_ram.v"
//`include "cmsdk_ahb_ram_beh.v"
`include "../sv/ahb_pkg.sv"
`include "../sv/ahb_interface.sv"

import uvm_pkg::*;

import pkg::*;


module tb_top;

bit hclk=1;
//bit hresetn;

//----------------------------------clock_generation and interface handle ---------------------------------------
always #5 hclk=~hclk;

ahb_intf intf_h(hclk);

/*initial begin
	intf_h.hresetn=0;
	#5;
	intf_h.hresetn=1;
end*/

//----------------------------------dut_instantiation---------------------------------------

cmsdk_ahb_ram dut(
	.HCLK(intf_h.hclk),
	.HRESETn(intf_h.hresetn),
	.HSEL(intf_h.hselx),
	.HADDR(intf_h.haddr),
	.HTRANS(intf_h.htrans),
	.HSIZE(intf_h.hsize),
	.HWRITE(intf_h.hwrite),
	.HWDATA(intf_h.hwdata),
	.HREADY(intf_h.hready),
	.HREADYOUT(intf_h.hreadyout),
	.HRDATA(intf_h.hrdata),
	.HRESP(intf_h.hresp)
);

initial begin

	uvm_config_db #(virtual ahb_intf)::set(null,"*","ahb_intf",intf_h);
	`uvm_info("TOP",$sformatf("ENTERED TOP"),UVM_MEDIUM)

	run_test("test");
//	run_test("reset_test");
//	run_test("wr_rd_test");
//	run_test("wr_test");

end

/*initial 
begin
set_global_timeout(1000000ns);
end*/


endmodule
