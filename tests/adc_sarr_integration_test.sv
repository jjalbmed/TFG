class adc_sarr_integration_test extends adc_base_test;

    `uvm_component_utils(adc_sarr_integration_test)

    localparam real LOW  = 0.0;
    localparam real HIGH = 1.8;
    localparam time SETTLING_TIME = 100ps;

    function new(string name = "adc_sarr_integration_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function int bit_value(input real x);
        return (x > 0.5) ? 1 : 0;
    endfunction

    function int get_sar_code();
        return
            bit_value(env.agent.driver.vif.sar_logic_b7) * 128 +
            bit_value(env.agent.driver.vif.sar_logic_b6) * 64  +
            bit_value(env.agent.driver.vif.sar_logic_b5) * 32  +
            bit_value(env.agent.driver.vif.sar_logic_b4) * 16  +
            bit_value(env.agent.driver.vif.sar_logic_b3) * 8   +
            bit_value(env.agent.driver.vif.sar_logic_b2) * 4   +
            bit_value(env.agent.driver.vif.sar_logic_b1) * 2   +
            bit_value(env.agent.driver.vif.sar_logic_b0);
    endfunction

    function int get_sarr_code();
        return
            bit_value(env.agent.driver.vif.sarr_o7) * 128 +
            bit_value(env.agent.driver.vif.sarr_o6) * 64  +
            bit_value(env.agent.driver.vif.sarr_o5) * 32  +
            bit_value(env.agent.driver.vif.sarr_o4) * 16  +
            bit_value(env.agent.driver.vif.sarr_o3) * 8   +
            bit_value(env.agent.driver.vif.sarr_o2) * 4   +
            bit_value(env.agent.driver.vif.sarr_o1) * 2   +
            bit_value(env.agent.driver.vif.sarr_o0);
    endfunction

    task wait_register_clk();
        do begin
            @(posedge env.agent.driver.vif.clk);
            #SETTLING_TIME;
        end
        while (env.agent.driver.vif.sar_logic_register_clk < 0.5);
    endtask

    task wait_sample_clk();
        do begin
            @(posedge env.agent.driver.vif.clk);
            #SETTLING_TIME;
        end
        while (env.agent.driver.vif.sar_logic_sample_clk < 0.5);
    endtask

    task check_result(input string case_name);
        int sar_code;
        int sarr_code;

        sar_code  = get_sar_code();
        sarr_code = get_sarr_code();

        if (sar_code != sarr_code) begin
            `uvm_error("SARR_INT",
                $sformatf("%s: SAR=%0d (0x%02h) | SARR=%0d (0x%02h) | diferencia=%0d",
                    case_name, sar_code, sar_code, sarr_code, sarr_code, sarr_code-sar_code))
        end
        else begin
            `uvm_info("SARR_INT",
                $sformatf("%s: SAR=%0d (0x%02h) | SARR=%0d (0x%02h) | MATCH",
                    case_name, sar_code, sar_code, sarr_code, sarr_code),
                UVM_LOW)
        end
    endtask

    task run_next_conversion(input string case_name, input real vin_value);
        env.agent.driver.vif.vin = vin_value;
        wait_sample_clk();
        wait_register_clk();
        #SETTLING_TIME;
        check_result(case_name);
    endtask

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        // Primera conversión: el anillo SAR se autoarranca desde net5.
        env.agent.driver.vif.vin = 0.0;

        wait_register_clk();
        #SETTLING_TIME;
        check_result("Vin = 0.00 V");

        //run_next_conversion("Vin = 0.45 V", 0.45);
        //run_next_conversion("Vin = 0.90 V", 0.90);
        //run_next_conversion("Vin = 1.35 V", 1.35);
        //run_next_conversion("Vin = 1.80 V", 1.80);
        run_next_conversion("Target code 2",   0.017578125);
        run_next_conversion("Target code 64",  0.453515625);
        run_next_conversion("Target code 128", 0.903515625);
        run_next_conversion("Target code 192", 1.353515625);

        phase.drop_objection(this);

    endtask

endclass
