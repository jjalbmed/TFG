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
        int n_period;

        time step;
        int n_steps;

        phase.raise_objection(this);

        // Senoide entre -1 V y +1 V
        pi        = 3.141592653589793;
        amplitude = 1.0;
        offset    = 0.0;

        // Clock = 10 ns -> 20 muestras por periodo de senoide
        period_ns = 200.0;

        // Actualización suficientemente rápida para verla suave
        step    = 500ps;

        // Simular dos periodos completos: 400 ns
        n_period = 5;
        n_steps = n_period*400;

        for (int i = 0; i <= n_steps; i++) begin

            t_ns = i * 0.5;

            env.agent.driver.vif.vin =
                offset +
                amplitude * $sin(2.0 * pi * t_ns / period_ns);

            #(step);

        end

        #1ns;

        phase.drop_objection(this);

    endtask

endclass