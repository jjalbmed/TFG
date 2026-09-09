class adc_driver extends uvm_driver #(adc_transaction); //driver acepta items de tipo adc_transaction #(req/rep)

    `uvm_component_utils(adc_driver)

    virtual gp_adc_interface.driver vif; //aprovecho el modport de la interfaz

    function new (string name="adc_driver", uvm_component parent =null);
        super.new(name, parent);
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if 
            (!uvm_config_db#(virtual gp_adc_interface.driver)::get(this,"","vif",vif)) //::get(desde donde busco/ruta relativa --> no hace falta bjara ningún otro componente, se busca aquí/ nombre del dato/donde lo guardo)
        begin 
            `uvm_fatal("NO VIF", "VIF no declarada")
        end
    endfunction : build_phase
    
    //run phase
    task run_phase (uvm_phase phase);
        forever begin
            //1. esperar primera transacción
            seq_item_port.get_next_item(req); 
            //2. asignar interfaz
            vif.reset <= req.reset;
            vif.set   <= req.set;
            vif.d     <= req.d;
        
            //3. Esperar evento de captura
            @(posedge vif.clk);

            //4. Indicar que se ha acabado
            seq_item_port.item_done();
        end
    endtask : run_phase

    

endclass