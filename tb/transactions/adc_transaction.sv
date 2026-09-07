
//La jerarquía es: uvm_seqeucne_item --> uvm_transaction --> uvm_object. Heredar de uvm_object o de uvm_transaction es simplemente añadir más o menos info
class adc_transaction extends uvm_sequence_item;
    `uvm_object_utils(adc_transaction)

    rand logic reset, set, d;
    //clk es función del driver/if
    function new (string name="adc_transaction");
        super.new(name);
    endfunction : new

endclass