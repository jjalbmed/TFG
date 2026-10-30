import uvm_pkg::*;
import adc_tb_pkg::*;
`include "uvm_macros.svh"

class adc_sar_logic_test extends adc_base_test;

    `uvm_component_utils(adc_sar_logic_test)

    //localparam real LOW  = 0.0;
    //localparam real HIGH = 1.8;

    function new(string name = "adc_sar_logic_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


   task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    env.agent.driver.vif.clk = 1'b0;

    fork
        begin
            forever begin
                #5ns;
                env.agent.driver.vif.clk = 1'b1;
                #5ns;
                env.agent.driver.vif.clk = 1'b0;
            end
        end
    join_none

    #2ns;

    `uvm_info("SAR_LOGIC",
              "Test SAR Logic con cmp_out = 0 V",
              UVM_LOW)

    force $root.test_fixture.adc_cmp_out_ams = 1'b0;

    #100ns;
    /*
    `uvm_info("SAR_LOGIC",
              "Test SAR Logic con cmp_out = 1.8 V",
              UVM_LOW)

    force $root.test_fixture.adc_cmp_out_ams = 1'b1;

    #100ns;
    */

    release $root.test_fixture.adc_cmp_out_ams;

    disable fork;

    env.agent.driver.vif.clk = 1'b0;

    phase.drop_objection(this);

endtask

endclass