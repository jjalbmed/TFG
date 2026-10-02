class adc_sh_test extends adc_base_test;

    `uvm_component_utils(adc_sh_test)

    function new(string name = "adc_sh_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        sh_sequence seq;

        phase.raise_objection(this);

        seq = sh_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        #1ns;

        phase.drop_objection(this);

    endtask

endclass