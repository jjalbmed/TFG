class sh_sequence extends uvm_sequence #(adc_transaction);

    `uvm_object_utils(sh_sequence)

    function new(string name = "sh_sequence");
        super.new(name);
    endfunction
    
    task body();

        adc_transaction req;
        req = adc_transaction::type_id::create("req");

        start_item(req);

        req.vin = 0.73;

        finish_item(req);

    endtask

endclass
