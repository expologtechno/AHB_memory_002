/*****************ENV_CONFIG*************************/
class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	age_config age_cn;

	virtual ahb_intf intf;

//---------------constructor------------------------
function new(string name="env_config");
	super.new(name);
endfunction

endclass
