class adc_full_test extends adc_base_test;

    `uvm_component_utils(adc_full_test)

    function new(
        string name = "adc_full_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        //--------------------------------------------------
        // Primera entrada
        //--------------------------------------------------
        env.agent.driver.vif.vin = 0.0;

        `uvm_info(
            "ADC_FULL",
            "Aplicando Vin = 0.0 V",
            UVM_LOW
        )

        // Tiempo suficiente para que ocurra una conversión completa
        #250ns;


        //--------------------------------------------------
        // Segunda entrada
        //--------------------------------------------------
        env.agent.driver.vif.vin = 1.8;

        `uvm_info(
            "ADC_FULL",
            "Aplicando Vin = 1.8 V",
            UVM_LOW
        )

        // Tiempo suficiente para otra conversión
        #250ns;


        phase.drop_objection(this);

    endtask : run_phase

endclass : adc_full_test