// Independent DAC integration test.  DAC_SETTLING_TIME represents only the
// mixed-signal propagation after a code change; it is not UVM synchronization.
class adc_dac_test extends adc_base_test;

    `uvm_component_utils(adc_dac_test)

    localparam time DAC_SETTLING_TIME = 100ps;
    localparam real DAC_TOLERANCE = 0.001;

    function new(string name = "adc_dac_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task automatic drive_dac_code(int unsigned code);
        // Explicitly clear every bit before applying the new code.  The
        // independent wreal inputs are driven only from this testbench path.
        env.agent.driver.vif.dac_b0 = 0.0;
        env.agent.driver.vif.dac_b1 = 0.0;
        env.agent.driver.vif.dac_b2 = 0.0;
        env.agent.driver.vif.dac_b3 = 0.0;
        env.agent.driver.vif.dac_b4 = 0.0;
        env.agent.driver.vif.dac_b5 = 0.0;
        env.agent.driver.vif.dac_b6 = 0.0;
        env.agent.driver.vif.dac_b7 = 0.0;

        env.agent.driver.vif.dac_b0 = (code & 8'h01) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b1 = (code & 8'h02) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b2 = (code & 8'h04) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b3 = (code & 8'h08) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b4 = (code & 8'h10) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b5 = (code & 8'h20) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b6 = (code & 8'h40) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b7 = (code & 8'h80) ? 1.8 : 0.0;
    endtask

    task automatic check_dac(string case_name, real expected);
        real actual;

        #(DAC_SETTLING_TIME);
        actual = env.agent.driver.vif.dac_out;
        if ((actual < (expected - DAC_TOLERANCE)) ||
            (actual > (expected + DAC_TOLERANCE))) begin
            `uvm_error("DAC_TEST",
                $sformatf("%s: dac_out=%0.9f V, expected %0.9f V",
                          case_name, actual, expected))
        end
        else begin
            `uvm_info("DAC_TEST",
                $sformatf("%s: dac_out=%0.9f V", case_name, actual),
                UVM_LOW)
        end
    endtask

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        #1ps;

        drive_dac_code(0);
        check_dac("CASE 1: code 0", 0.0);

        drive_dac_code(1);
        check_dac("CASE 2: code 1 (b0 / LSB)", 0.00703125);

        drive_dac_code(64);
        check_dac("CASE 3: code 64", 0.45);

        drive_dac_code(128);
        check_dac("CASE 4: code 128 (b7 / MSB)", 0.9);

        drive_dac_code(192);
        check_dac("CASE 5: code 192", 1.35);

        drive_dac_code(255);
        check_dac("CASE 6: code 255", 1.79296875);

        // Extra adjacent code to exercise the LSB progression.
        drive_dac_code(2);
        check_dac("EXTRA: code 2", 0.0140625);

        phase.drop_objection(this);
    endtask

endclass
