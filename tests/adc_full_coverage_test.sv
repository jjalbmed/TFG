class adc_full_coverage_test extends adc_base_test;

    `uvm_component_utils(adc_full_coverage_test)

    typedef struct {
        int low;
        int high;
    } code_range_t;

    code_range_t pending_ranges[$];

    localparam real VREF = 1.8;
    localparam int  N_CODES = 256;

    localparam int MAX_NO_PROGRESS = 20;
    localparam int MAX_TOTAL_ITERATIONS = 5000;


    function new(string name = "adc_full_coverage_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction


    task run_phase(uvm_phase phase);

        code_range_t current_range;

        bit [7:0] target_code;

        real vin;

        int missing_before;
        int missing_after;

        int attempts_without_progress;
        int total_iterations;

        int mid;


        phase.raise_objection(this);


        // Rangos iniciales de 64 códigos.
        pending_ranges.push_back('{0,   63});
        pending_ranges.push_back('{64,  127});
        pending_ranges.push_back('{128, 191});
        pending_ranges.push_back('{192, 255});


        total_iterations = 0;


        while ((pending_ranges.size() > 0) &&
               (total_iterations < MAX_TOTAL_ITERATIONS)) begin


            current_range = pending_ranges.pop_front();


            // Si el rango ya está completamente cubierto,
            // no hace falta volver a estimularlo.
            if (env.coverage.range_covered(
                    current_range.low,
                    current_range.high)) begin

                `uvm_info(
                    "FULL_COVERAGE",
                    $sformatf(
                        "Rango [%0d:%0d] ya cubierto",
                        current_range.low,
                        current_range.high
                    ),
                    UVM_LOW
                )

                continue;

            end


            attempts_without_progress = 0;

            missing_before =
                env.coverage.uncovered_in_range(
                    current_range.low,
                    current_range.high
                );


            `uvm_info(
                "FULL_COVERAGE",
                $sformatf(
                    "Trabajando rango [%0d:%0d] | faltan %0d códigos",
                    current_range.low,
                    current_range.high,
                    missing_before
                ),
                UVM_LOW
            )


            while (!env.coverage.range_covered(
                        current_range.low,
                        current_range.high) &&
                   (attempts_without_progress < MAX_NO_PROGRESS) &&
                   (total_iterations < MAX_TOTAL_ITERATIONS)) begin


                assert(std::randomize(target_code) with {
                    target_code inside {
                        [current_range.low:current_range.high]
                    };
                });


                // Aplicamos el centro del bin correspondiente.
                vin =
                    (real'(target_code) + 0.5)
                    * (VREF / N_CODES);


                env.agent.driver.vif.vin = vin;


                `uvm_info(
                    "FULL_COVERAGE",
                    $sformatf(
                        "Target code = %0d | Vin = %.6f V",
                        target_code,
                        vin
                    ),
                    UVM_LOW
                )


                // Esperar una conversión completa.
                // Tu ADC está tardando aproximadamente 100 ns.
                #110ns;


                total_iterations++;


                missing_after =
                    env.coverage.uncovered_in_range(
                        current_range.low,
                        current_range.high
                    );


                if (missing_after < missing_before) begin

                    attempts_without_progress = 0;
                    missing_before = missing_after;

                end
                else begin

                    attempts_without_progress++;

                end

            end


            // Si el rango ya se ha cerrado, seguimos.
            if (env.coverage.range_covered(
                    current_range.low,
                    current_range.high)) begin

                `uvm_info(
                    "FULL_COVERAGE",
                    $sformatf(
                        "Rango [%0d:%0d] COMPLETO",
                        current_range.low,
                        current_range.high
                    ),
                    UVM_LOW
                )

            end

            // Si se ha atascado, subdividimos.
            else if (current_range.low < current_range.high) begin

                mid =
                    (current_range.low +
                     current_range.high) / 2;


                // Solo añadimos las mitades que todavía
                // tengan códigos sin cubrir.
                if (!env.coverage.range_covered(
                        current_range.low,
                        mid)) begin

                    pending_ranges.push_back(
                        '{current_range.low, mid}
                    );

                end


                if (!env.coverage.range_covered(
                        mid + 1,
                        current_range.high)) begin

                    pending_ranges.push_back(
                        '{mid + 1, current_range.high}
                    );

                end


                `uvm_info(
                    "FULL_COVERAGE",
                    $sformatf(
                        "Subdividiendo [%0d:%0d] -> [%0d:%0d] y [%0d:%0d]",
                        current_range.low,
                        current_range.high,
                        current_range.low,
                        mid,
                        mid + 1,
                        current_range.high
                    ),
                    UVM_LOW
                )

            end

            // Si hemos llegado a un único código y todavía
            // no se cubre, lo volvemos a poner en la cola.
            else begin

                pending_ranges.push_back(current_range);

                `uvm_warning(
                    "FULL_COVERAGE",
                    $sformatf(
                        "El código %0d todavía no se ha cubierto",
                        current_range.low
                    )
                )

            end

        end


        `uvm_info(
            "FULL_COVERAGE",
            $sformatf(
                "Test terminado | Coverage = %.2f%% | Iteraciones = %0d",
                env.coverage.get_coverage_pct(),
                total_iterations
            ),
            UVM_LOW
        )


        phase.drop_objection(this);

    endtask : run_phase


endclass