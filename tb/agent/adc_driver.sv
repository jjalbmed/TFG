class adc_driver extends uvm_driver #(adc_transaction);

    `uvm_component_utils(adc_driver)

    virtual gp_adc_interface.driver vif;

    function new(string name="adc_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(
            virtual gp_adc_interface.driver
        )::get(this, "", "vif", vif))
            `uvm_fatal("NO VIF", "VIF no declarada")

    endfunction


    task run_phase(uvm_phase phase);

        forever begin

            seq_item_port.get_next_item(req); //1. esperar primera transacción

            `uvm_info("DRV",
                $sformatf("ADC vin = %0.3f", req.vin),
                UVM_LOW)

            // Drive after this edge, so Vin is stable for the next sample.
            @(vif.driver_cb);

            // Drive through the driver clocking block so this testbench
            // drive has a defined scheduling relation with the clock edge.
            vif.driver_cb.vin <= req.vin;

            @(vif.driver_cb);//3. Esperar el siguiente evento de captura

            seq_item_port.item_done();//4. Indicar que se ha acabado

        end

    endtask

endclass
