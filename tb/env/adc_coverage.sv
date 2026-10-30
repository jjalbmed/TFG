class adc_coverage extends uvm_subscriber #(adc_transaction);

    `uvm_component_utils(adc_coverage)

    localparam real VREF = 1.8;
    localparam int  N_CODES = 256;

    int unsigned vin_code;
    bit [7:0]    adc_code;
    bit [255:0]  covered_codes;


    covergroup adc_cg;

        option.per_instance = 1;

        // Código ideal correspondiente al Vin aplicado.
        cp_vin_code : coverpoint vin_code {
            bins codes[] = {[0:255]};
        }

        // Código realmente producido por el ADC.
        cp_adc_code : coverpoint adc_code {
            bins codes[] = {[0:255]};
        }

    endgroup


    function new(string name = "adc_coverage",uvm_component parent = null);

        super.new(name, parent);

        adc_cg = new();
        covered_codes = '0;

    endfunction


    function void write(adc_transaction t);

        if (!t.conversion_done)
            return;


        // Convertir Vin a un código discreto entre 0 y 255.
        if (t.vin <= 0.0) begin

            vin_code = 0;

        end
        else if (t.vin >= VREF) begin

            vin_code = 255;

        end
        else begin

            vin_code = $rtoi(
                (t.vin / VREF) * N_CODES
            );

        end


        adc_code = t.adc_code;
        covered_codes[adc_code] = 1'b1;

        adc_cg.sample();

        `uvm_info("ADC_COVERAGE", $sformatf("Sample: vin_code=%0d adc_code=%0d", vin_code, adc_code), UVM_LOW)

    endfunction

    /*
    function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("ADC_COVERAGE",
        $sformatf("Functional coverage = %0.2f%%", adc_cg.get_inst_coverage()), UVM_LOW)
    endfunction

    */

    function bit range_covered (int low, int high);

        for (int i =low ;i<= high ;i++ ) begin
            if (!covered_codes[i])
                return 1'b0;            
        end

        return 1'b1;
    endfunction

    function int uncovered_in_range(int low, int high);

        int missing = 0;

        for (int i = low; i <= high; i++) begin
            if (!covered_codes[i])
                missing++;
        end

        return missing;

    endfunction

    function real get_coverage_pct();

        return adc_cg.get_inst_coverage();

    endfunction
endclass