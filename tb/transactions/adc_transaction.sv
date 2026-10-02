class adc_transaction extends uvm_sequence_item;
    `uvm_object_utils(adc_transaction)

    // ADC top-level stimulus and observed result.
    real vin, vout;

    function new (string name="adc_transaction");
        super.new(name);
    endfunction : new

endclass
