class adc_monitor extends uvm_monitor;

    `uvm_component_utils(adc_monitor)

    virtual gp_adc_interface.monitor vif;

    uvm_analysis_port #(adc_transaction) ap;

    // Tiempo para permitir el asentamiento AMS después de un flanco.
    localparam time AMS_SETTLING_TIME = 100ps;

    // Umbral para interpretar una señal analógica 0/1.8 V como bit.
    localparam real LOGIC_THRESHOLD = 0.9;


    function new(string name = "adc_monitor",
                 uvm_component parent = null);

        super.new(name, parent);
        ap = new("ap", this);

    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if (!uvm_config_db#(
                virtual gp_adc_interface.monitor
            )::get(this, "", "vif", vif)) begin

            `uvm_fatal("NO VIF", "VIF no declarada")

        end

    endfunction : build_phase


    // Interpreta un nivel analógico como nivel lógico.
    function automatic bit analog_to_bit(real value);

        return (value > LOGIC_THRESHOLD);

    endfunction


    task run_phase(uvm_phase phase);

        adc_transaction tr;

        real sampled_vin;

        // Vin correspondiente a la conversión actualmente en curso.
        real vin_at_sample;

        // Si comienza una nueva conversión mientras estamos terminando
        // de procesar la anterior, guardamos aquí su Vin.
        real pending_vin;

        bit current_register_clk;
        bit previous_register_clk;

        bit sample_valid;
        bit pending_sample_valid;

        // Protege el estado compartido entre los dos hilos del monitor.
        semaphore state_lock;


        previous_register_clk = 1'b0;

        sample_valid         = 1'b0;
        pending_sample_valid = 1'b0;

        state_lock = new(1);


        fork

            // =====================================================
            // HILO 1: DETECCIÓN EXACTA DEL SAMPLE
            // =====================================================
            begin : sample_thread

                forever begin

                    @(posedge vif.sample_clk_d);

                    state_lock.get(1);

                    // Si todavía tenemos una muestra asociada a la
                    // conversión anterior, esta nueva muestra pertenece
                    // a la siguiente conversión.
                    if (sample_valid) begin

                        pending_vin          = vif.vin;
                        pending_sample_valid = 1'b1;

                        `uvm_info(
                            "MON",
                            $sformatf(
                                "ADC sample pendiente: Vin = %0.3f V",
                                pending_vin
                            ),
                            UVM_LOW
                        )

                    end
                    else begin

                        vin_at_sample = vif.vin;
                        sample_valid  = 1'b1;

                        `uvm_info(
                            "MON",
                            $sformatf(
                                "ADC sample: Vin = %0.3f V",
                                vin_at_sample
                            ),
                            UVM_LOW
                        )

                    end

                    state_lock.put(1);

                end

            end


            // =====================================================
            // HILO 2: DETECCIÓN DEL FINAL DE CONVERSIÓN
            // =====================================================
            begin : conversion_thread

                forever begin

                    @(vif.monitor_cb);

                    sampled_vin = vif.monitor_cb.vin;

                    #(AMS_SETTLING_TIME);

                    current_register_clk =
                        analog_to_bit(vif.sar_logic_register_clk);


                    // register_clk ↓ = fin de conversión
                    if (previous_register_clk &&
                        !current_register_clk) begin

                        // Esperar a que SARR y Vout se estabilicen.
                        #(AMS_SETTLING_TIME);

                        state_lock.get(1);

                        tr = adc_transaction::type_id::create("tr");


                        // -----------------------------------------
                        // Vin correspondiente a esta conversión
                        // -----------------------------------------
                        if (sample_valid) begin

                            tr.vin = vin_at_sample;

                        end
                        else begin

                            `uvm_warning(
                                "MON",
                                "Fin de conversion detectado sin una muestra Vin previa valida"
                            )

                            tr.vin = sampled_vin;

                        end


                        // -----------------------------------------
                        // Salida analógica
                        // -----------------------------------------
                        tr.vout = vif.vout;


                        // -----------------------------------------
                        // Código ADC registrado
                        // -----------------------------------------
                        tr.adc_code = {
                            analog_to_bit(vif.sarr_o7),
                            analog_to_bit(vif.sarr_o6),
                            analog_to_bit(vif.sarr_o5),
                            analog_to_bit(vif.sarr_o4),
                            analog_to_bit(vif.sarr_o3),
                            analog_to_bit(vif.sarr_o2),
                            analog_to_bit(vif.sarr_o1),
                            analog_to_bit(vif.sarr_o0)
                        };


                        tr.conversion_done = 1'b1;


                        `uvm_info(
                            "MON",
                            $sformatf(
                                "ADC conversion: Vin = %0.3f V | Code = 0x%02h | Vout = %0.3f V",
                                tr.vin,
                                tr.adc_code,
                                tr.vout
                            ),
                            UVM_LOW
                        )


                        ap.write(tr);


                        // -----------------------------------------
                        // La conversión actual ya ha sido consumida.
                        // -----------------------------------------
                        sample_valid = 1'b0;


                        // Si ya ocurrió el sample de la conversión
                        // siguiente, lo promovemos ahora.
                        if (pending_sample_valid) begin

                            vin_at_sample = pending_vin;

                            sample_valid         = 1'b1;
                            pending_sample_valid = 1'b0;

                        end


                        state_lock.put(1);

                    end


                    previous_register_clk =
                        current_register_clk;

                end

            end

        join

    endtask : run_phase


endclass