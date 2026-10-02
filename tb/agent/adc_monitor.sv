class adc_monitor extends uvm_monitor;

    `uvm_component_utils(adc_monitor)

    virtual gp_adc_interface.monitor vif; //limito acceso a modport monitor


    uvm_analysis_port #(adc_transaction) ap;

    // AMS propagation/settling after the sample edge. This is deliberately
    // separate from clocking-block skews, which only define SV scheduling.
    localparam time AMS_SETTLING_TIME = 100ps;

    function new(string name ="adc_monitor", uvm_component parent = null);
        super.new(name,parent);
        ap = new("ap",this);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        if 
            (!uvm_config_db#(virtual gp_adc_interface.monitor)::get(this,"","vif",vif))
            begin
                `uvm_fatal("NO VIF", "VIF no declarada")
            end
    endfunction : build_phase

    task run_phase (uvm_phase phase);

        adc_transaction tr;
        real sampled_vin;
        real sampled_vout;

        forever begin
            // Vin is sampled in the monitor clocking block at this edge.
            @(vif.monitor_cb);
            sampled_vin = vif.monitor_cb.vin;

            // Vout is observed only after the distinct AMS settling time.
            #(AMS_SETTLING_TIME);
            sampled_vout = vif.vout;

            tr = adc_transaction::type_id::create("tr");
            
            tr.vin = sampled_vin;
            tr.vout = sampled_vout;

            `uvm_info("MON", $sformatf("ADC vin = %0.3f | ADC vout = %0.3f", tr.vin, tr.vout),UVM_LOW)

            ap.write(tr);
        end

    endtask : run_phase

endclass
