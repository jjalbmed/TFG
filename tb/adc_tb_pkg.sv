package adc_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "transactions/adc_transaction.sv"
    `include "sequences/adc_sequence.sv"
    `include "sequences/sh_sequence.sv"

    `include "agent/adc_sequencer.sv"
    `include "agent/adc_driver.sv"
    `include "agent/adc_monitor.sv"
    `include "agent/adc_agent.sv"

    `include "env/adc_env.sv"

    `include "/home/jalberic/proyectos/TFG/tests/adc_base_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_sh_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_sh_sine_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_comparator_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_dac_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_dac_comparator_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_ff_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_sar_code_row_test.sv"
    `include "/home/jalberic/proyectos/TFG/tests/adc_sar_sequence_row_test.sv"

    
endpackage
