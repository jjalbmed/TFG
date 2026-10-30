//dento de env también va: scoreboard, golden model y coverage
class adc_env extends uvm_env;

    `uvm_component_utils(adc_env)

    adc_agent agent;
    adc_scoreboard scoreboard;
    adc_coverage coverage;

    function new(string name ="adc_env", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent =adc_agent::type_id::create("agent",this);
        scoreboard =adc_scoreboard::type_id::create("scoreboard",this);
        coverage = adc_coverage::type_id::create("coverage",this);
    endfunction  : build_phase 

    //Connect phase se implementa cuando conectemos el agent (monitor) al scoreboard

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.ap.connect(scoreboard.analysis_export);
        agent.monitor.ap.connect(coverage.analysis_export);

    endfunction : connect_phase
endclass