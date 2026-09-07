//adc_sequence: Crea las transacciones y las envía al seqeuncer
class adc_sequence extends uvm_sequence #(adc_transaction);
    `uvm_object_utils(adc_sequence)

    function new(string name = "adc_sequence");
        super.new(name);
    endfunction

    task body();
     //1. crear la transacción
    adc_transaction req;
    req = adc_transaction ::type_id::create("req"); //llamada a factory con create() method.
    //2. Avisar al sequence de que se va a enviar
    start_item(req);
    //3. Dar valores a las variables. En este caso se randomiza.adc_sequence
    assert(req.randomize());
    //4. Se acaba el item
    finish_item(req);
    endtask

endclass