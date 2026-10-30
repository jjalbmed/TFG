import uvm_pkg::*;
import adc_tb_pkg::*;
`include "uvm_macros.svh"

class adc_sarr_test extends adc_base_test;

    `uvm_component_utils(adc_sarr_test)

    localparam real LOW  = 0.0;
    localparam real HIGH = 1.8;
    localparam real TOL  = 0.001;
    localparam time SETTLING_TIME = 100ps;

    function new(string name = "adc_sarr_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function real abs_real(input real x);
        if (x < 0.0)
            return -x;
        else
            return x;
    endfunction

    task drive_code(input bit [7:0] code);
        env.agent.driver.vif.sarr_b7 = code[7] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b6 = code[6] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b5 = code[5] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b4 = code[4] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b3 = code[3] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b2 = code[2] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b1 = code[1] ? HIGH : LOW;
        env.agent.driver.vif.sarr_b0 = code[0] ? HIGH : LOW;
    endtask

    task pulse_eoc();
        env.agent.driver.vif.sarr_eoc = HIGH;
        #SETTLING_TIME;
        env.agent.driver.vif.sarr_eoc = LOW;
        #SETTLING_TIME;
    endtask

    task check_code(input string case_name, input bit [7:0] expected);
        bit failed;

        failed =
            (abs_real(env.agent.driver.vif.sarr_o7 - (expected[7] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o6 - (expected[6] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o5 - (expected[5] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o4 - (expected[4] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o3 - (expected[3] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o2 - (expected[2] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o1 - (expected[1] ? 1.0 : 0.0)) > TOL) ||
            (abs_real(env.agent.driver.vif.sarr_o0 - (expected[0] ? 1.0 : 0.0)) > TOL);

        if (failed) begin
            `uvm_error("SARR",
                $sformatf(
                    "%s: o7..o0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f | expected = %08b",
                    case_name,
                    env.agent.driver.vif.sarr_o7,
                    env.agent.driver.vif.sarr_o6,
                    env.agent.driver.vif.sarr_o5,
                    env.agent.driver.vif.sarr_o4,
                    env.agent.driver.vif.sarr_o3,
                    env.agent.driver.vif.sarr_o2,
                    env.agent.driver.vif.sarr_o1,
                    env.agent.driver.vif.sarr_o0,
                    expected
                )
            )
        end
        else begin
            `uvm_info("SARR",
                $sformatf(
                    "%s: o7..o0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f",
                    case_name,
                    env.agent.driver.vif.sarr_o7,
                    env.agent.driver.vif.sarr_o6,
                    env.agent.driver.vif.sarr_o5,
                    env.agent.driver.vif.sarr_o4,
                    env.agent.driver.vif.sarr_o3,
                    env.agent.driver.vif.sarr_o2,
                    env.agent.driver.vif.sarr_o1,
                    env.agent.driver.vif.sarr_o0
                ),
                UVM_LOW
            )
        end
    endtask

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        env.agent.driver.vif.sarr_eoc = LOW;

        // Inicializar el registro con un código conocido.
        drive_code(8'b00000000);
        #SETTLING_TIME;
        pulse_eoc();
        check_code("INIT", 8'b00000000);

        // CASE 1: capturar 10100101.
        drive_code(8'b10100101);
        #SETTLING_TIME;
        check_code("BEFORE EOC - must hold old value", 8'b00000000);

        pulse_eoc();
        check_code("AFTER EOC - capture 10100101", 8'b10100101);

        // CASE 2: cambiar entradas sin EOC; la salida debe mantenerse.
        drive_code(8'b01011010);
        #SETTLING_TIME;
        check_code("INPUT CHANGED WITHOUT EOC", 8'b10100101);

        // CASE 3: segundo EOC captura el nuevo código.
        pulse_eoc();
        check_code("SECOND EOC - capture 01011010", 8'b01011010);

        phase.drop_objection(this);

    endtask

endclass
