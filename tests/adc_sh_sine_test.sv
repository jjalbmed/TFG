class adc_sh_sine_test extends adc_base_test;

    `uvm_component_utils(adc_sh_sine_test)

    function new(string name = "adc_sh_sine_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        real pi;
        real amplitude;
        real offset;
        real period_ns;
        real t_ns;

        time step;
        int n_period;
        int n_steps;

        phase.raise_objection(this);

        pi = 3.141592653589793;

        // Senoide entre 0.5 V y 1.5 V
        amplitude = 0.5;
        offset    = 1.0;

        // Senoide más lenta:
        // ~20 conversiones SAR por periodo
        period_ns = 2000.0;

        // Actualización de Vin cada 500 ps
        step = 500ps;

        // Simular 2 periodos completos = 4 us
        n_period = 2;

        // 2000 ns / 0.5 ns = 4000 pasos por periodo
        n_steps = n_period * 4000;

        // CLK = 10 ns
        env.agent.driver.vif.clk = 1'b0;

        fork

            // -----------------------------
            // Generador de reloj
            // -----------------------------
            begin
                forever begin
                    #5ns;
                    env.agent.driver.vif.clk = 1'b1;

                    #5ns;
                    env.agent.driver.vif.clk = 1'b0;
                end
            end

            // -----------------------------
            // Generador de senoide
            // -----------------------------
            begin
                for (int i = 0; i <= n_steps; i++) begin

                    t_ns = i * 0.5;

                    env.agent.driver.vif.vin =
                        offset +
                        amplitude *
                        $sin(2.0 * pi * t_ns / period_ns);

                    #(step);
                end
            end

        join_any

        disable fork;

        env.agent.driver.vif.clk = 1'b0;

        #1ns;

        phase.drop_objection(this);

    endtask

endclass