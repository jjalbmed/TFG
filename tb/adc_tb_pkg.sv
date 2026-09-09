package adc_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "transactions/adc_transaction.sv"
    `include "sequences/adc_sequence.sv"
    
    `include "agent/adc_sequencer.sv"
    `include "agent/adc_driver.sv"
    `include "agent/adc_monitor.sv"
    `include "agent/adc_agent.sv"

    `include "env/adc_env.sv"

    `include "/home/jalberic/proyectos/TFG/tests/adc_base_test.sv"
    
endpackage    