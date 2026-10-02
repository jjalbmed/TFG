`timescale 1ns/1ps

module test_fixture;

    gp_adc_interface intf();

    // Redes wreal en el límite digital/analógico del ADC.
    wreal adc_clk_ams;
    wreal adc_vin_ams;
    wreal adc_vout_ams;
    wreal adc_cmp_ref_ams;
    wreal adc_cmp_out_ams;
    wreal adc_dac_b0_ams;
    wreal adc_dac_b1_ams;
    wreal adc_dac_b2_ams;
    wreal adc_dac_b3_ams;
    wreal adc_dac_b4_ams;
    wreal adc_dac_b5_ams;
    wreal adc_dac_b6_ams;
    wreal adc_dac_b7_ams;
    wreal adc_dac_out_ams;
    wreal adc_ff_set_ams;
    wreal adc_ff_reset_ams;
    wreal adc_ff_d_ams;
    wreal adc_ff_q_ams;
    wreal adc_ff_qbar_ams;
    wreal adc_sar_in_ams;
    wreal adc_sar_reset_ams;
    wreal adc_sar_seq_b7_ams;
    wreal adc_sar_seq_b6_ams;
    wreal adc_sar_seq_b5_ams;
    wreal adc_sar_seq_b4_ams;
    wreal adc_sar_seq_b3_ams;
    wreal adc_sar_seq_b2_ams;
    wreal adc_sar_seq_b1_ams;
    wreal adc_sar_seq_b0_ams;
    wreal adc_sar_register_clk_ams;
    wreal adc_sar_b7_ams;
    wreal adc_sar_b6_ams;
    wreal adc_sar_b5_ams;
    wreal adc_sar_b4_ams;
    wreal adc_sar_b3_ams;
    wreal adc_sar_b2_ams;
    wreal adc_sar_b1_ams;
    wreal adc_sar_b0_ams;
    wreal adc_sar_b7b_ams;
    wreal adc_sar_b6b_ams;
    wreal adc_sar_b5b_ams;
    wreal adc_sar_b4b_ams;
    wreal adc_sar_b3b_ams;
    wreal adc_sar_b2b_ams;
    wreal adc_sar_b1b_ams;
    wreal adc_sar_b0b_ams;
    wreal adc_sar_seq_reset_ams;
    wreal adc_sar_seq_clk_ams;
    wreal adc_sar_auto_seq_b7_ams;
    wreal adc_sar_auto_seq_b6_ams;
    wreal adc_sar_auto_seq_b5_ams;
    wreal adc_sar_auto_seq_b4_ams;
    wreal adc_sar_auto_seq_b3_ams;
    wreal adc_sar_auto_seq_b2_ams;
    wreal adc_sar_auto_seq_b1_ams;
    wreal adc_sar_auto_seq_b0_ams;
    wreal adc_sar_auto_register_clk_ams;
    //***********************************
    //conversion señales de la if a wreal
    //***********************************
    //inputs
    assign adc_clk_ams = intf.clk ? 1.8 : 0.0;
    assign adc_vin_ams = intf.vin;
    assign adc_cmp_ref_ams = intf.cmp_ref;
    assign adc_dac_b0_ams = intf.dac_b0;
    assign adc_dac_b1_ams = intf.dac_b1;
    assign adc_dac_b2_ams = intf.dac_b2;
    assign adc_dac_b3_ams = intf.dac_b3;
    assign adc_dac_b4_ams = intf.dac_b4;
    assign adc_dac_b5_ams = intf.dac_b5;
    assign adc_dac_b6_ams = intf.dac_b6;
    assign adc_dac_b7_ams = intf.dac_b7;
    assign adc_ff_set_ams = intf.ff_set;
    assign adc_ff_reset_ams = intf.ff_reset;
    assign adc_ff_d_ams = intf.ff_d;
    assign adc_sar_in_ams = intf.sar_in;
    assign adc_sar_reset_ams = intf.sar_reset;
    assign adc_sar_seq_b7_ams = intf.sar_seq_b7;
    assign adc_sar_seq_b6_ams = intf.sar_seq_b6;
    assign adc_sar_seq_b5_ams = intf.sar_seq_b5;
    assign adc_sar_seq_b4_ams = intf.sar_seq_b4;
    assign adc_sar_seq_b3_ams = intf.sar_seq_b3;
    assign adc_sar_seq_b2_ams = intf.sar_seq_b2;
    assign adc_sar_seq_b1_ams = intf.sar_seq_b1;
    assign adc_sar_seq_b0_ams = intf.sar_seq_b0;
    assign adc_sar_register_clk_ams = intf.sar_register_clk;
    assign adc_sar_seq_reset_ams = intf.sar_seq_reset;
    assign adc_sar_seq_clk_ams = intf.sar_seq_clk;
    //outputs
    assign intf.vout = adc_vout_ams;
    assign intf.cmp_out = adc_cmp_out_ams;
    assign intf.dac_out = adc_dac_out_ams;
    assign intf.ff_q = adc_ff_q_ams;
    assign intf.ff_qbar = adc_ff_qbar_ams;
    assign intf.sar_b7 = adc_sar_b7_ams;
    assign intf.sar_b6 = adc_sar_b6_ams;
    assign intf.sar_b5 = adc_sar_b5_ams;
    assign intf.sar_b4 = adc_sar_b4_ams;
    assign intf.sar_b3 = adc_sar_b3_ams;
    assign intf.sar_b2 = adc_sar_b2_ams;
    assign intf.sar_b1 = adc_sar_b1_ams;
    assign intf.sar_b0 = adc_sar_b0_ams;
    assign intf.sar_b7b = adc_sar_b7b_ams;
    assign intf.sar_b6b = adc_sar_b6b_ams;
    assign intf.sar_b5b = adc_sar_b5b_ams;
    assign intf.sar_b4b = adc_sar_b4b_ams;
    assign intf.sar_b3b = adc_sar_b3b_ams;
    assign intf.sar_b2b = adc_sar_b2b_ams;
    assign intf.sar_b1b = adc_sar_b1b_ams;
    assign intf.sar_b0b = adc_sar_b0b_ams;
    assign intf.sar_auto_seq_b7 = adc_sar_auto_seq_b7_ams;
    assign intf.sar_auto_seq_b6 = adc_sar_auto_seq_b6_ams;
    assign intf.sar_auto_seq_b5 = adc_sar_auto_seq_b5_ams;
    assign intf.sar_auto_seq_b4 = adc_sar_auto_seq_b4_ams;
    assign intf.sar_auto_seq_b3 = adc_sar_auto_seq_b3_ams;
    assign intf.sar_auto_seq_b2 = adc_sar_auto_seq_b2_ams;
    assign intf.sar_auto_seq_b1 = adc_sar_auto_seq_b1_ams;
    assign intf.sar_auto_seq_b0 = adc_sar_auto_seq_b0_ams;
    assign intf.sar_auto_register_clk = adc_sar_auto_register_clk_ams;
    // interfaz

    //tb_top

    tb_top tb(
        .intf(intf)
    );

    //ADC DUT
    adc_top dut (
        .clk  (adc_clk_ams),
        .vin  (adc_vin_ams),
        .vout (adc_vout_ams),
        .cmp_ref (adc_cmp_ref_ams),
        .cmp_out (adc_cmp_out_ams),
        .dac_b0 (adc_dac_b0_ams),
        .dac_b1 (adc_dac_b1_ams),
        .dac_b2 (adc_dac_b2_ams),
        .dac_b3 (adc_dac_b3_ams),
        .dac_b4 (adc_dac_b4_ams),
        .dac_b5 (adc_dac_b5_ams),
        .dac_b6 (adc_dac_b6_ams),
        .dac_b7 (adc_dac_b7_ams),
        .dac_out (adc_dac_out_ams),
        .ff_set (adc_ff_set_ams),
        .ff_reset (adc_ff_reset_ams),
        .ff_d (adc_ff_d_ams),
        .ff_q (adc_ff_q_ams),
        .ff_qbar (adc_ff_qbar_ams),
        .sar_in (adc_sar_in_ams),
        .sar_reset (adc_sar_reset_ams),
        .sar_seq_b7 (adc_sar_seq_b7_ams),
        .sar_seq_b6 (adc_sar_seq_b6_ams),
        .sar_seq_b5 (adc_sar_seq_b5_ams),
        .sar_seq_b4 (adc_sar_seq_b4_ams),
        .sar_seq_b3 (adc_sar_seq_b3_ams),
        .sar_seq_b2 (adc_sar_seq_b2_ams),
        .sar_seq_b1 (adc_sar_seq_b1_ams),
        .sar_seq_b0 (adc_sar_seq_b0_ams),
        .sar_register_clk (adc_sar_register_clk_ams),
        .sar_b7 (adc_sar_b7_ams),
        .sar_b6 (adc_sar_b6_ams),
        .sar_b5 (adc_sar_b5_ams),
        .sar_b4 (adc_sar_b4_ams),
        .sar_b3 (adc_sar_b3_ams),
        .sar_b2 (adc_sar_b2_ams),
        .sar_b1 (adc_sar_b1_ams),
        .sar_b0 (adc_sar_b0_ams),
        .sar_b7b (adc_sar_b7b_ams),
        .sar_b6b (adc_sar_b6b_ams),
        .sar_b5b (adc_sar_b5b_ams),
        .sar_b4b (adc_sar_b4b_ams),
        .sar_b3b (adc_sar_b3b_ams),
        .sar_b2b (adc_sar_b2b_ams),
        .sar_b1b (adc_sar_b1b_ams),
        .sar_b0b (adc_sar_b0b_ams),
        .sar_seq_reset (adc_sar_seq_reset_ams),
        .sar_seq_clk (adc_sar_seq_clk_ams),
        .sar_auto_seq_b7 (adc_sar_auto_seq_b7_ams),
        .sar_auto_seq_b6 (adc_sar_auto_seq_b6_ams),
        .sar_auto_seq_b5 (adc_sar_auto_seq_b5_ams),
        .sar_auto_seq_b4 (adc_sar_auto_seq_b4_ams),
        .sar_auto_seq_b3 (adc_sar_auto_seq_b3_ams),
        .sar_auto_seq_b2 (adc_sar_auto_seq_b2_ams),
        .sar_auto_seq_b1 (adc_sar_auto_seq_b1_ams),
        .sar_auto_seq_b0 (adc_sar_auto_seq_b0_ams),
        .sar_auto_register_clk (adc_sar_auto_register_clk_ams)
    );

endmodule
