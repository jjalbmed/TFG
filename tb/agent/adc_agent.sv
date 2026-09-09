class adc_agent extends uvm_agent;

    `uvm_component_utils(adc_agent)

    adc_monitor monitor;
    adc_sequencer sequencer;
    adc_driver driver;

    function new(string name ="adc_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction


    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        monitor =adc_monitor::type_id::create("monitor",this);
        sequencer =adc_sequencer::type_id::create("sequencer",this);
        driver =adc_driver::type_id::create("driver",this);
    endfunction : build_phase

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        driver.seq_item_port.connect(sequencer.seq_item_export); //seqeuncer se connecta al driver


    endfunction : connect_phase

endclass