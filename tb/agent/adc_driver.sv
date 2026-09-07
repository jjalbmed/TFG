class adc_driver extends uvm_driver #(adc_transaction); //driver acepta items de tipo adc_transaction

    `uvm_component_utils(adc_driver)

    virtual gp_adc_interface.driver vif; //aprovecho el modport de la interfaz

    function new (string name="adc_driver", uvm_component parent =null);
        super.new(name, parent);
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase
    
    

endclass