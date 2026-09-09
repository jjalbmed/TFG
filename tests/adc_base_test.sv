//test base del cual heredarán todos los futuros tests a implementar
class adc_base_test extends uvm_test;

    `uvm_component_utils(adc_base_test)

    adc_env env;

    function new(string name="adc_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env =adc_env::type_id::create("env",this);

    endfunction : build_phase


endclass