class adc_monitor extends uvm_monitor;

    `uvm_component_utils(adc_monitor)

    virtual gp_adc_interface.monitor vif; //limito acceso a modport monitor


    uvm_analysis_port #(adc_transaction) ap;

    function new(string name ="adc_monitor", uvm_component parent = "null");
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

        forever begin
            @(posedge vif.clk);

            tr = adc_transaction::type_id::create("tr");
            
            tr.reset = vif.reset;
            tr.set = vif. set;
            tr.d = vif.d;
            tr.q = vif.q;

            ap.write(tr);
        end

    endtask : run_phase

endclass