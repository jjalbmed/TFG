class adc_dac_comparator_test extends adc_base_test;

    `uvm_component_utils(adc_dac_comparator_test)

    localparam time AMS_SETTLING_TIME = 100ps;
    localparam real CMP_HIGH_MIN = 0.9;
    localparam real CMP_LOW_MAX  = 0.1;

    function new(
        string name = "adc_dac_comparator_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction


    task automatic drive_dac_code(int unsigned code);

        // Limpiar explícitamente todos los bits.
        env.agent.driver.vif.dac_b0 = 0.0;
        env.agent.driver.vif.dac_b1 = 0.0;
        env.agent.driver.vif.dac_b2 = 0.0;
        env.agent.driver.vif.dac_b3 = 0.0;
        env.agent.driver.vif.dac_b4 = 0.0;
        env.agent.driver.vif.dac_b5 = 0.0;
        env.agent.driver.vif.dac_b6 = 0.0;
        env.agent.driver.vif.dac_b7 = 0.0;

        // Aplicar el código como niveles eléctricos 0.0 / 1.8 V.
        env.agent.driver.vif.dac_b0 = (code & 8'h01) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b1 = (code & 8'h02) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b2 = (code & 8'h04) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b3 = (code & 8'h08) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b4 = (code & 8'h10) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b5 = (code & 8'h20) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b6 = (code & 8'h40) ? 1.8 : 0.0;
        env.agent.driver.vif.dac_b7 = (code & 8'h80) ? 1.8 : 0.0;

    endtask


    task automatic check_comparator(
        string case_name,
        bit expected_high
    );

        real actual;

        #(AMS_SETTLING_TIME);

        actual = env.agent.driver.vif.cmp_out;

        if (expected_high) begin

            if (actual < CMP_HIGH_MIN) begin
                `uvm_error(
                    "DAC_CMP_TEST",
                    $sformatf(
                        "%s: cmp_out=%0.6f V, expected HIGH",
                        case_name,
                        actual
                    )
                )
            end
            else begin
                `uvm_info(
                    "DAC_CMP_TEST",
                    $sformatf(
                        "%s: cmp_out=%0.6f V -> HIGH",
                        case_name,
                        actual
                    ),
                    UVM_LOW
                )
            end

        end
        else begin

            if (actual > CMP_LOW_MAX) begin
                `uvm_error(
                    "DAC_CMP_TEST",
                    $sformatf(
                        "%s: cmp_out=%0.6f V, expected LOW",
                        case_name,
                        actual
                    )
                )
            end
            else begin
                `uvm_info(
                    "DAC_CMP_TEST",
                    $sformatf(
                        "%s: cmp_out=%0.6f V -> LOW",
                        case_name,
                        actual
                    ),
                    UVM_LOW
                )
            end

        end

    endtask


    task automatic run_case(
        string case_name,
        real vin,
        int unsigned dac_code,
        bit expected_high
    );

        // Aplicar Vin y código DAC antes del flanco de muestreo.
        env.agent.driver.vif.vin = vin;
        drive_dac_code(dac_code);

        // Dejar que el DAC se estabilice antes de cualquier comparación.
        #(AMS_SETTLING_TIME);

        /*
         * Primer flanco:
         *
         * SampleHold captura Vin.
         *
         * El Comparator también se dispara, pero debido al comportamiento
         * ya validado usa el valor PREVIAMENTE retenido por SampleHold.
         */
        @(posedge env.agent.driver.vif.clk);

        /*
         * Segundo flanco:
         *
         * El Comparator ya ve el valor de SampleHold capturado en
         * el flanco anterior.
         *
         * Vin y el código DAC se han mantenido estables durante todo
         * el intervalo.
         */
        @(posedge env.agent.driver.vif.clk);

        // Esperar propagación AMS antes de observar cmp_out.
        check_comparator(case_name, expected_high);

    endtask


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        #1ps;

        /*
         * DAC code 128:
         *
         * dac_out = 128 * 1.8 / 256
         *         = 0.9 V
         */

        run_case(
            "CASE 1: SH=1.20 V > DAC=0.90 V",
            1.20,
            128,
            1'b1
        );

        run_case(
            "CASE 2: SH=0.60 V < DAC=0.90 V",
            0.60,
            128,
            1'b0
        );

        run_case(
            "CASE 3: SH=0.90 V == DAC=0.90 V",
            0.90,
            128,
            1'b0
        );

        phase.drop_objection(this);

    endtask

endclass