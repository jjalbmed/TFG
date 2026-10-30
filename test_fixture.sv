`timescale 1ns/1ps

module test_fixture;

    gp_adc_interface intf();

    // Redes wreal en el límite digital/analógico del ADC.
    wreal adc_clk_ams;
    wreal adc_vin_ams;
    wreal adc_vout_ams;
    wreal adc_cmp_out_ams;
    wreal adc_dac_out_ams;
    wreal adc_sar_logic_b7_ams;
    wreal adc_sar_logic_b6_ams;
    wreal adc_sar_logic_b5_ams;
    wreal adc_sar_logic_b4_ams;
    wreal adc_sar_logic_b3_ams;
    wreal adc_sar_logic_b2_ams;
    wreal adc_sar_logic_b1_ams;
    wreal adc_sar_logic_b0_ams;
    wreal adc_sar_logic_sample_clk_ams;
    wreal adc_sar_logic_register_clk_ams;
    wreal adc_sarr_o7_ams;
    wreal adc_sarr_o6_ams;
    wreal adc_sarr_o5_ams;
    wreal adc_sarr_o4_ams;
    wreal adc_sarr_o3_ams;
    wreal adc_sarr_o2_ams;
    wreal adc_sarr_o1_ams;
    wreal adc_sarr_o0_ams;
    //***********************************
    //conversion señales de la if a wreal
    //***********************************
    //inputs
    assign adc_clk_ams = intf.clk ? 1.8 : 0.0;
    assign adc_vin_ams = intf.vin;
    //outputs
    assign intf.vout = adc_vout_ams;
    assign intf.cmp_out = adc_cmp_out_ams;
    assign intf.dac_out = adc_dac_out_ams;
    assign intf.sar_logic_b7 = adc_sar_logic_b7_ams;
    assign intf.sar_logic_b6 = adc_sar_logic_b6_ams;
    assign intf.sar_logic_b5 = adc_sar_logic_b5_ams;
    assign intf.sar_logic_b4 = adc_sar_logic_b4_ams;
    assign intf.sar_logic_b3 = adc_sar_logic_b3_ams;
    assign intf.sar_logic_b2 = adc_sar_logic_b2_ams;
    assign intf.sar_logic_b1 = adc_sar_logic_b1_ams;
    assign intf.sar_logic_b0 = adc_sar_logic_b0_ams;
    assign intf.sar_logic_sample_clk = adc_sar_logic_sample_clk_ams;
    assign intf.sar_logic_register_clk = adc_sar_logic_register_clk_ams;
    assign intf.sarr_o7 = adc_sarr_o7_ams;
    assign intf.sarr_o6 = adc_sarr_o6_ams;
    assign intf.sarr_o5 = adc_sarr_o5_ams;
    assign intf.sarr_o4 = adc_sarr_o4_ams;
    assign intf.sarr_o3 = adc_sarr_o3_ams;
    assign intf.sarr_o2 = adc_sarr_o2_ams;
    assign intf.sarr_o1 = adc_sarr_o1_ams;
    assign intf.sarr_o0 = adc_sarr_o0_ams;
    // interfaz

    //tb_top

    tb_top tb(
        .intf(intf)
    );

    //ADC DUT
    adc_top dut (
        .clk                    (adc_clk_ams),
        .vin                    (adc_vin_ams),
        .vout                   (adc_vout_ams),
        .cmp_out                (adc_cmp_out_ams),
        .dac_out                (adc_dac_out_ams),
        .sar_logic_b7           (adc_sar_logic_b7_ams),
        .sar_logic_b6           (adc_sar_logic_b6_ams),
        .sar_logic_b5           (adc_sar_logic_b5_ams),
        .sar_logic_b4           (adc_sar_logic_b4_ams),
        .sar_logic_b3           (adc_sar_logic_b3_ams),
        .sar_logic_b2           (adc_sar_logic_b2_ams),
        .sar_logic_b1           (adc_sar_logic_b1_ams),
        .sar_logic_b0           (adc_sar_logic_b0_ams),
        .sar_logic_sample_clk   (adc_sar_logic_sample_clk_ams),
        .sar_logic_register_clk (adc_sar_logic_register_clk_ams),
        .sarr_o7                (adc_sarr_o7_ams),
        .sarr_o6                (adc_sarr_o6_ams),
        .sarr_o5                (adc_sarr_o5_ams),
        .sarr_o4                (adc_sarr_o4_ams),
        .sarr_o3                (adc_sarr_o3_ams),
        .sarr_o2                (adc_sarr_o2_ams),
        .sarr_o1                (adc_sarr_o1_ams),
        .sarr_o0                (adc_sarr_o0_ams)
    );

endmodule
