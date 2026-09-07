class adc_sequencer extends uvm_sequencer #(adc_transaction);

    `uvm_component_utils(adc_sequencer)

    function new (string name="adc_sequencer", uvm_component parent =null);
        super.new(name, parent);
    endfunction : new
endclass