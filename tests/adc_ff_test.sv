class adc_ff_test extends adc_base_test;

    `uvm_component_utils(adc_ff_test)

    localparam time FF_SETTLING_TIME = 100ps;
    localparam real FF_TOLERANCE = 0.001;

    function new(string name = "adc_ff_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    task automatic drive_ff(
        real set_value,
        real reset_value,
        real d_value
    );

        env.agent.driver.vif.ff_set   = set_value;
        env.agent.driver.vif.ff_reset = reset_value;
        env.agent.driver.vif.ff_d     = d_value;

    endtask


    task automatic check_ff(
        string case_name,
        real expected_q,
        real expected_qbar
    );

        real actual_q;
        real actual_qbar;

        #(FF_SETTLING_TIME);

        actual_q    = env.agent.driver.vif.ff_q;
        actual_qbar = env.agent.driver.vif.ff_qbar;

        if ((actual_q < (expected_q - FF_TOLERANCE)) ||
            (actual_q > (expected_q + FF_TOLERANCE)) ||
            (actual_qbar < (expected_qbar - FF_TOLERANCE)) ||
            (actual_qbar > (expected_qbar + FF_TOLERANCE))) begin

            `uvm_error(
                "FF_TEST",
                $sformatf(
                    "%s: Q=%0.6f V QBAR=%0.6f V, expected Q=%0.6f V QBAR=%0.6f V",
                    case_name,
                    actual_q,
                    actual_qbar,
                    expected_q,
                    expected_qbar
                )
            )

        end
        else begin

            `uvm_info(
                "FF_TEST",
                $sformatf(
                    "%s: Q=%0.6f V QBAR=%0.6f V",
                    case_name,
                    actual_q,
                    actual_qbar
                ),
                UVM_LOW
            )

        end

    endtask


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        #1ps;

        // ---------------------------------------------------------
        // CASE 1
        // Reset activo -> Q=0, QBAR=1
        // Además fuerza un estado inicial conocido.
        // ---------------------------------------------------------

        drive_ff(0.0, 1.8, 0.0);

        @(posedge env.agent.driver.vif.clk);

        check_ff(
            "CASE 1: Reset=1",
            0.0,
            1.0
        );


        // ---------------------------------------------------------
        // CASE 2
        // Set activo -> Q=1, QBAR=0
        // ---------------------------------------------------------

        @(negedge env.agent.driver.vif.clk);

        drive_ff(1.8, 0.0, 0.0);

        check_ff(
            "CASE 2: Set=1",
            1.0,
            0.0
        );


        // ---------------------------------------------------------
        // CASE 3
        // Set y Reset simultáneos.
        // El modelo original da prioridad a Set.
        // ---------------------------------------------------------

        drive_ff(1.8, 1.8, 0.0);

        check_ff(
            "CASE 3: Set=1 Reset=1 -> Set priority",
            1.0,
            0.0
        );


        // ---------------------------------------------------------
        // CASE 4
        // D=0 solo debe capturarse en flanco ascendente.
        //
        // Partimos de Q=1 gracias al caso anterior.
        // Aplicamos D=0 entre flancos.
        // Antes del siguiente posedge Q debe seguir siendo 1.
        // ---------------------------------------------------------

        @(negedge env.agent.driver.vif.clk);

        drive_ff(0.0, 0.0, 0.0);

        check_ff(
            "CASE 4A: D=0 before rising edge -> Q must hold",
            1.0,
            0.0
        );

        @(posedge env.agent.driver.vif.clk);

        check_ff(
            "CASE 4B: D=0 after rising edge",
            0.0,
            1.0
        );


        // ---------------------------------------------------------
        // CASE 5
        // D=1 solo debe capturarse en flanco ascendente.
        //
        // Ahora partimos de Q=0.
        // ---------------------------------------------------------

        @(negedge env.agent.driver.vif.clk);

        drive_ff(0.0, 0.0, 1.8);

        check_ff(
            "CASE 5A: D=1 before rising edge -> Q must hold",
            0.0,
            1.0
        );

        @(posedge env.agent.driver.vif.clk);

        check_ff(
            "CASE 5B: D=1 after rising edge",
            1.0,
            0.0
        );


        // ---------------------------------------------------------
        // CASE 6
        // Comprobar el comportamiento asíncrono de Reset.
        //
        // Partimos de Q=1 y activamos Reset entre flancos.
        // ---------------------------------------------------------

        @(negedge env.agent.driver.vif.clk);

        drive_ff(0.0, 1.8, 1.8);

        check_ff(
            "CASE 6: Async Reset between clock edges",
            0.0,
            1.0
        );


        // ---------------------------------------------------------
        // CASE 7
        // Comprobar el comportamiento asíncrono de Set.
        //
        // Partimos de Q=0 y activamos Set entre flancos.
        // ---------------------------------------------------------

        drive_ff(1.8, 0.0, 0.0);

        check_ff(
            "CASE 7: Async Set between clock edges",
            1.0,
            0.0
        );


        phase.drop_objection(this);

    endtask

endclass