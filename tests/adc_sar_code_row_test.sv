class adc_sar_code_row_test extends adc_base_test;

    `uvm_component_utils(adc_sar_code_row_test)

    localparam time SAR_SETTLING_TIME = 100ps;
    localparam real VHIGH = 1.0;
    localparam real VLOW  = 0.0;
    localparam real TOL   = 0.001;

    function new(string name = "adc_sar_code_row_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function real abs_real(input real x);
        if (x < 0.0)
            return -x;
        else
            return x;
    endfunction


    task clear_controls();
        env.agent.driver.vif.sar_seq_b7 = VLOW;
        env.agent.driver.vif.sar_seq_b6 = VLOW;
        env.agent.driver.vif.sar_seq_b5 = VLOW;
        env.agent.driver.vif.sar_seq_b4 = VLOW;
        env.agent.driver.vif.sar_seq_b3 = VLOW;
        env.agent.driver.vif.sar_seq_b2 = VLOW;
        env.agent.driver.vif.sar_seq_b1 = VLOW;
        env.agent.driver.vif.sar_seq_b0 = VLOW;
        env.agent.driver.vif.sar_register_clk = VLOW;
    endtask


    task pulse_seq(input int bit_idx);
        case (bit_idx)
            7: env.agent.driver.vif.sar_seq_b7 = VHIGH;
            6: env.agent.driver.vif.sar_seq_b6 = VHIGH;
            5: env.agent.driver.vif.sar_seq_b5 = VHIGH;
            4: env.agent.driver.vif.sar_seq_b4 = VHIGH;
            3: env.agent.driver.vif.sar_seq_b3 = VHIGH;
            2: env.agent.driver.vif.sar_seq_b2 = VHIGH;
            1: env.agent.driver.vif.sar_seq_b1 = VHIGH;
            0: env.agent.driver.vif.sar_seq_b0 = VHIGH;
        endcase

        #SAR_SETTLING_TIME;

        case (bit_idx)
            7: env.agent.driver.vif.sar_seq_b7 = VLOW;
            6: env.agent.driver.vif.sar_seq_b6 = VLOW;
            5: env.agent.driver.vif.sar_seq_b5 = VLOW;
            4: env.agent.driver.vif.sar_seq_b4 = VLOW;
            3: env.agent.driver.vif.sar_seq_b3 = VLOW;
            2: env.agent.driver.vif.sar_seq_b2 = VLOW;
            1: env.agent.driver.vif.sar_seq_b1 = VLOW;
            0: env.agent.driver.vif.sar_seq_b0 = VLOW;
        endcase

        #SAR_SETTLING_TIME;
    endtask


    task pulse_register_clk();
        env.agent.driver.vif.sar_register_clk = VHIGH;
        #SAR_SETTLING_TIME;
        env.agent.driver.vif.sar_register_clk = VLOW;
        #SAR_SETTLING_TIME;
    endtask


    task check_q(
        input string case_name,
        input real e7,
        input real e6,
        input real e5,
        input real e4,
        input real e3,
        input real e2,
        input real e1,
        input real e0
    );

        if ((abs_real(env.agent.driver.vif.sar_b7 - e7) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b6 - e6) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b5 - e5) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b4 - e4) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b3 - e3) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b2 - e2) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b1 - e1) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b0 - e0) > TOL)) begin

            `uvm_error("SAR_CODE_ROW",
                $sformatf(
                    "%s: b7..b0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f",
                    case_name,
                    env.agent.driver.vif.sar_b7,
                    env.agent.driver.vif.sar_b6,
                    env.agent.driver.vif.sar_b5,
                    env.agent.driver.vif.sar_b4,
                    env.agent.driver.vif.sar_b3,
                    env.agent.driver.vif.sar_b2,
                    env.agent.driver.vif.sar_b1,
                    env.agent.driver.vif.sar_b0
                )
            )

        end else begin

            `uvm_info("SAR_CODE_ROW",
                $sformatf(
                    "%s: b7..b0 = %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f",
                    case_name,
                    env.agent.driver.vif.sar_b7,
                    env.agent.driver.vif.sar_b6,
                    env.agent.driver.vif.sar_b5,
                    env.agent.driver.vif.sar_b4,
                    env.agent.driver.vif.sar_b3,
                    env.agent.driver.vif.sar_b2,
                    env.agent.driver.vif.sar_b1,
                    env.agent.driver.vif.sar_b0
                ),
                UVM_LOW
            )

        end
    endtask


    task check_complements(
        input string case_name,
        input real expected_q,
        input real expected_qbar
    );

        if ((abs_real(env.agent.driver.vif.sar_b7  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b6  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b5  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b4  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b3  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b2  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b1  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b0  - expected_q)    > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b7b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b6b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b5b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b4b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b3b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b2b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b1b - expected_qbar) > TOL) ||
            (abs_real(env.agent.driver.vif.sar_b0b - expected_qbar) > TOL)) begin

            `uvm_error("SAR_CODE_ROW",
                $sformatf("%s: Q/QBAR complement check failed", case_name))

        end else begin

            `uvm_info("SAR_CODE_ROW",
                $sformatf("%s: Q/QBAR complement check passed", case_name),
                UVM_LOW)

        end
    endtask


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        clear_controls();

        env.agent.driver.vif.sar_reset = VLOW;
        env.agent.driver.vif.sar_in    = VLOW;

        #1ns;


        // -------------------------------------------------
        // CASE 1: In = 0
        // Cada bit se prueba a 1 y el anterior captura 0.
        // -------------------------------------------------

        pulse_seq(7);
        check_q("IN=0 after seq_b7",
                1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(6);
        check_q("IN=0 after seq_b6",
                0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(5);
        check_q("IN=0 after seq_b5",
                0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(4);
        check_q("IN=0 after seq_b4",
                0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(3);
        check_q("IN=0 after seq_b3",
                0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0);

        pulse_seq(2);
        check_q("IN=0 after seq_b2",
                0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0);

        pulse_seq(1);
        check_q("IN=0 after seq_b1",
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);

        pulse_seq(0);
        check_q("IN=0 after seq_b0",
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);

        pulse_register_clk();

        check_q("IN=0 final code",
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        check_complements("IN=0 final complement",
                          0.0, 1.0);


        // -------------------------------------------------
        // Reset con todos los FF ya inicializados
        // -------------------------------------------------

        env.agent.driver.vif.sar_reset = VHIGH;
        #SAR_SETTLING_TIME;

        check_complements("RESET",
                          0.0, 1.0);

        env.agent.driver.vif.sar_reset = VLOW;
        #SAR_SETTLING_TIME;


        // -------------------------------------------------
        // CASE 2: In = 1.0
        // Cada bit se prueba a 1 y el anterior captura 1.
        // -------------------------------------------------

        env.agent.driver.vif.sar_in = VHIGH;

        pulse_seq(7);
        check_q("IN=1 after seq_b7",
                1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(6);
        check_q("IN=1 after seq_b6",
                1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(5);
        check_q("IN=1 after seq_b5",
                1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(4);
        check_q("IN=1 after seq_b4",
                1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0);

        pulse_seq(3);
        check_q("IN=1 after seq_b3",
                1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0);

        pulse_seq(2);
        check_q("IN=1 after seq_b2",
                1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0);

        pulse_seq(1);
        check_q("IN=1 after seq_b1",
                1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0);

        pulse_seq(0);
        check_q("IN=1 after seq_b0",
                1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

        pulse_register_clk();

        check_q("IN=1 final code",
                1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

        check_complements("IN=1 final complement",
                          1.0, 0.0);


        phase.drop_objection(this);

    endtask

endclass