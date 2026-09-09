//dento de env también va: scoreboard, golden model y coverage
class adc_env extends uvm_env;


    `uvm_component_utils(adc_env)

    adc_agent agent;

    function new(string name ="adc_env", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent =adc_agent::type_id::create("agent",this);
        
    endfunction  : build_phase 

    /*
    
    Connect phase se implementa cuando conectemos el agent (monitor) al scoreboard

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        enviroment.seq_item_port.connect(agent.seq_item_export); 
    endfunction : connect_phase
    */
endclass