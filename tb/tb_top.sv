`timescale 1ns/1ps
module tb_top(gp_adc_interface intf);

    import uvm_pkg::*;
    import adc_tb_pkg::*;

    //clk gen
    initial begin
        intf.clk = 0;
        forever #5 intf.clk = ~intf.clk;
    end

    //uvm
    initial begin
        uvm_config_db#(virtual gp_adc_interface.driver)::set(null,"uvm_test_top.env.agent.driver","vif",intf.driver);

        uvm_config_db#(virtual gp_adc_interface.monitor)::set(null,"uvm_test_top.env.agent.monitor","vif",intf.monitor);
    end


    run_test(); //a efectos prácticos es un método. Hace falta para desde la barra de comandos, indicar que test simular.

endmodule
