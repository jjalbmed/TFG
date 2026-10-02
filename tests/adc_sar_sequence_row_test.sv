class adc_sar_sequence_row_test extends adc_base_test;

    `uvm_component_utils(adc_sar_sequence_row_test)

    localparam real LOW  = 0.0;
    localparam real HIGH = 1.8;
    localparam real TOL  = 0.001;
    localparam time SETTLING_TIME = 100ps;

    function new(string name = "adc_sar_sequence_row_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function real abs_real(input real x);
        if (x < 0.0)
            return -x;
        else
            return x;
    endfunction

    task check_state(
        input string case_name,
        input real e7,
        input real e6,
        input real e5,
        input real e4,
        input real e3,
        input real e2,
        input real e1,
        input real e0,
        input real ereg
    );
        bit failed;

        failed =
            (abs_real(env.agent.driver.vif.sar_auto_seq_b7 - e7) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b6 - e6) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b5 - e5) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b4 - e4) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b3 - e3) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b2 - e2) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b1 - e1) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_seq_b0 - e0) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_auto_register_clk - ereg) > TOL);

        if (failed) begin
            `uvm_error("SAR_SEQ_ROW",
                $sformatf(
                    "%s: seq_b7..b0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f | register_clk = %.1f",
                    case_name,
                    env.agent.driver.vif.sar_auto_seq_b7,
                    env.agent.driver.vif.sar_auto_seq_b6,
                    env.agent.driver.vif.sar_auto_seq_b5,
                    env.agent.driver.vif.sar_auto_seq_b4,
                    env.agent.driver.vif.sar_auto_seq_b3,
                    env.agent.driver.vif.sar_auto_seq_b2,
                    env.agent.driver.vif.sar_auto_seq_b1,
                    env.agent.driver.vif.sar_auto_seq_b0,
                    env.agent.driver.vif.sar_auto_register_clk
                )
            )
        end
        else begin
            `uvm_info("SAR_SEQ_ROW",
                $sformatf(
                    "%s: seq_b7..b0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f | register_clk = %.1f",
                    case_name,
                    env.agent.driver.vif.sar_auto_seq_b7,
                    env.agent.driver.vif.sar_auto_seq_b6,
                    env.agent.driver.vif.sar_auto_seq_b5,
                    env.agent.driver.vif.sar_auto_seq_b4,
                    env.agent.driver.vif.sar_auto_seq_b3,
                    env.agent.driver.vif.sar_auto_seq_b2,
                    env.agent.driver.vif.sar_auto_seq_b1,
                    env.agent.driver.vif.sar_auto_seq_b0,
                    env.agent.driver.vif.sar_auto_register_clk
                ),
                UVM_LOW
            )
        end
    endtask

    task pulse_clk();
        env.agent.driver.vif.sar_seq_clk = HIGH;
        #SETTLING_TIME;
    endtask

    task finish_clk_pulse();
        env.agent.driver.vif.sar_seq_clk = LOW;
        #SETTLING_TIME;
    endtask

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        env.agent.driver.vif.sar_seq_clk   = LOW;
        env.agent.driver.vif.sar_seq_reset = HIGH;

        #SETTLING_TIME;

        check_state("RESET",
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    0.0);

        env.agent.driver.vif.sar_seq_reset = LOW;
        #SETTLING_TIME;

        pulse_clk();
        check_state("CLK 1", 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 2", 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 3", 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 4", 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 5", 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 6", 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 7", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 8", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 9", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        finish_clk_pulse();

        pulse_clk();
        check_state("CLK 10", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        finish_clk_pulse();

        phase.drop_objection(this);

    endtask

endclass
