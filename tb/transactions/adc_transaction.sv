class adc_transaction extends uvm_sequence_item;

    `uvm_object_utils(adc_transaction)

    // Entrada analógica
    real vin;

    // Salida analógica
    real vout;

    // Código digital producido por SARR
    bit [7:0] adc_code;

    // Indica que el código corresponde a una conversión completa
    bit conversion_done;


    function new(string name = "adc_transaction");
        super.new(name);

        adc_code        = 8'h00;
        conversion_done = 1'b0;
    endfunction : new

endclass : adc_transaction