class ahb_coverage extends uvm_subscriber#(ahb_transaction);

        `uvm_component_utils(ahb_coverage)


	uvm_analysis_imp#(ahb_transaction, ahb_coverage) ahb_cov_port;

        ahb_transaction trans;
	
	real cov;

        covergroup ahb_cg;

                option.per_instance = 1;

                WRITE: coverpoint trans.write 
		{bins b0 ={0}; 
		 bins b1 ={1}; }

                TRANS: coverpoint trans.trans_type 
		{bins b0={0}; 
		 bins b1={1}; 
		 bins b2={2}; 
		 bins b3={3};}

                SIZE: coverpoint trans.size
		{bins b0={0}; 
		 bins b1={1}; 
		 bins b2={2}; } 

                ADDR: coverpoint trans.addr[0];
                WDATA: coverpoint trans.wdata[0];
                RESP: coverpoint trans.resp
		{bins b0 ={0}; 
		 bins b1 ={1}; }
                READY: coverpoint trans.ready
		{bins b0 ={0}; 
		 bins b1 ={1}; }
 
             
        endgroup


        //-------------------------------------------------
        // Methods
        //-------------------------------------------------


        //Constructor
        function new(string name = "ahb_coverage", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build_phase
        function void build_phase(uvm_phase phase);      
		ahb_cov_port = new("ahb_cov_port", this);
		trans = ahb_transaction::type_id::create("trans", this);
		super.build_phase(phase);
        endfunction

	//write
        function void write(ahb_transaction t);
		`uvm_info("AHB_AGENT_COVERAE", "From Coverage Write function", UVM_LOW)
		ahb_cg.sample();		
        endfunction
	
	   //Extract
        function void extract_phase(uvm_phase phase);
                cov = ahb_cg.get_coverage();
        endfunction

	   //Report
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(), $sformatf("Coverage is: %f", cov), UVM_MEDIUM)
        endfunction
	
endclass
