class adc_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(adc_scoreboard)

    uvm_analysis_imp #(adc_transaction, adc_scoreboard) analysis_export;

    localparam real VREF = 1.8;
    localparam int  N_CODES = 256;

    int unsigned n_checked;
    int unsigned n_errors;

    function new(string name = "adc_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);

        n_checked = 0;
        n_errors  = 0;
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_export = new("analysis_export", this);
    endfunction


    function void write(adc_transaction tr);

        int expected_code;

        // Modelo ideal ADC de 8 bits:
        //
        // Vin <= 0 V   -> 0
        // Vin >= 1.8 V -> 255
        // resto        -> floor(Vin / VREF * 256)

        if (tr.vin <= 0.0) begin
            expected_code = 0;
        end
        else if (tr.vin >= VREF) begin
            expected_code = 255;
        end
        else begin
            expected_code = $rtoi(
                (tr.vin / VREF) * N_CODES
            );
        end

        n_checked++;

        if (tr.adc_code != expected_code) begin

            n_errors++;

            `uvm_error(
                "ADC_SCOREBOARD",
                $sformatf(
                    "Mismatch: Vin = %.6f V | Expected = 0x%02h (%0d) | DUT = 0x%02h (%0d)",
                    tr.vin,
                    expected_code,
                    expected_code,
                    tr.adc_code,
                    tr.adc_code
                )
            )

        end
        else begin

            `uvm_info(
                "ADC_SCOREBOARD",
                $sformatf(
                    "PASS: Vin = %.6f V | Code = 0x%02h (%0d)",
                    tr.vin,
                    tr.adc_code,
                    tr.adc_code
                ),
                UVM_LOW
            )

        end

    endfunction


    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "ADC_SCOREBOARD",
            $sformatf(
                "Resumen: %0d conversiones comprobadas | %0d errores",
                n_checked,
                n_errors
            ),
            UVM_LOW
        )

    endfunction

endclass