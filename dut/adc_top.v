`timescale 1ns/1ps

// Verilog wrapper for the mixed-signal ADC hierarchy.
// The wreal ports allow ADMS to insert the existing REAL <-> electrical
// boundary elements at the Verilog-A instances.
module adc_top(
    clk, vin, vout, cmp_out, dac_out,
    sar_logic_b7, sar_logic_b6, sar_logic_b5, sar_logic_b4,
    sar_logic_b3, sar_logic_b2, sar_logic_b1, sar_logic_b0,
    sar_logic_sample_clk, sar_logic_register_clk,
    sarr_o7, sarr_o6, sarr_o5, sarr_o4, sarr_o3, sarr_o2, sarr_o1, sarr_o0
);

    input  wreal clk;
    input  wreal vin;
    output wreal vout;
    output wreal cmp_out;
    output wreal dac_out;

    output wreal sar_logic_b7;
    output wreal sar_logic_b6;
    output wreal sar_logic_b5;
    output wreal sar_logic_b4;
    output wreal sar_logic_b3;
    output wreal sar_logic_b2;
    output wreal sar_logic_b1;
    output wreal sar_logic_b0;

    output wreal sar_logic_sample_clk;
    output wreal sar_logic_register_clk;

    output wreal sarr_o7;
    output wreal sarr_o6;
    output wreal sarr_o5;
    output wreal sarr_o4;
    output wreal sarr_o3;
    output wreal sarr_o2;
    output wreal sarr_o1;
    output wreal sarr_o0;

    wreal sh_vout;
    wreal dac_vdd;
    wreal dac_vss;
    wreal sar_logic_vdd;
    wreal sar_logic_vss;
    wreal sarr_vdd;
    wreal sarr_vss;
    //wreal sar_logic_b7b_int, sar_logic_b6b_int, sar_logic_b5b_int, sar_logic_b4b_int, sar_logic_b3b_int, sar_logic_b2b_int, sar_logic_b1b_int, sar_logic_b0b_int;

    assign dac_vdd       = 1.8;
    assign dac_vss       = 0.0;
    assign sar_logic_vdd = 1.8;
    assign sar_logic_vss = 0.0;
    assign sarr_vdd      = 1.8;
    assign sarr_vss      = 0.0;

    SampleHold u_sample_hold (
        .clk  (sar_logic_sample_clk),
        .vin  (vin),
        .vout (sh_vout)
    );

    Comparador u_comparador (
        .InS (sh_vout),
        .InD (dac_out),
        .Out (cmp_out),
        .clk (clk)
    );

    DAC_Capacitivo u_dac_feedback (
        .b0   (sar_logic_b0),
        .b1   (sar_logic_b1),
        .b2   (sar_logic_b2),
        .b3   (sar_logic_b3),
        .b4   (sar_logic_b4),
        .b5   (sar_logic_b5),
        .b6   (sar_logic_b6),
        .b7   (sar_logic_b7),
        .Aout (dac_out),
        .vdd  (dac_vdd),
        .vss  (dac_vss)
    );


    SARLogic u_sar_logic (
    .In           (cmp_out),
    .CLK          (clk),
    .VDD          (sar_logic_vdd),
    .VSS          (sar_logic_vss),

    .b7           (sar_logic_b7),
    .b6           (sar_logic_b6),
    .b5           (sar_logic_b5),
    .b4           (sar_logic_b4),
    .b3           (sar_logic_b3),
    .b2           (sar_logic_b2),
    .b1           (sar_logic_b1),
    .b0           (sar_logic_b0),

    .sample_clk   (sar_logic_sample_clk),
    .register_clk (sar_logic_register_clk)
    );

    /*
    SARLogic u_sar_logic (
        .In           (cmp_out),
        .CLK          (clk),
        .VDD          (sar_logic_vdd),
        .VSS          (sar_logic_vss),
        .b7           (sar_logic_b7),
        .b6           (sar_logic_b6),
        .b5           (sar_logic_b5),
        .b4           (sar_logic_b4),
        .b3           (sar_logic_b3),
        .b2           (sar_logic_b2),
        .b1           (sar_logic_b1),
        .b0           (sar_logic_b0),
        .b7b          (sar_logic_b7b_int),
        .b6b          (sar_logic_b6b_int),
        .b5b          (sar_logic_b5b_int),
        .b4b          (sar_logic_b4b_int),
        .b3b          (sar_logic_b3b_int),
        .b2b          (sar_logic_b2b_int),
        .b1b          (sar_logic_b1b_int),
        .b0b          (sar_logic_b0b_int),
        .sample_clk   (sar_logic_sample_clk),
        .register_clk (sar_logic_register_clk)
    );
    */
    wreal sarr_clk;

    assign sarr_clk = (sar_logic_register_clk > 0.9) ? 0.0 : 1.8;
    SARR u_sarr (
        .b7  (sar_logic_b7),
        .b6  (sar_logic_b6),
        .b5  (sar_logic_b5),
        .b4  (sar_logic_b4),
        .b3  (sar_logic_b3),
        .b2  (sar_logic_b2),
        .b1  (sar_logic_b1),
        .b0  (sar_logic_b0),
        .EOC (sarr_clk), //sar_logic_register_clk
        .VDD (sarr_vdd),
        .VSS (sarr_vss),
        .o7  (sarr_o7),
        .o6  (sarr_o6),
        .o5  (sarr_o5),
        .o4  (sarr_o4),
        .o3  (sarr_o3),
        .o2  (sarr_o2),
        .o1  (sarr_o1),
        .o0  (sarr_o0)
    );


    DAC_Capacitivo u_dac_output (
        .b0   (sarr_o0),
        .b1   (sarr_o1),
        .b2   (sarr_o2),
        .b3   (sarr_o3),
        .b4   (sarr_o4),
        .b5   (sarr_o5),
        .b6   (sarr_o6),
        .b7   (sarr_o7),
        .Aout (vout),
        .vdd  (dac_vdd),
        .vss  (dac_vss)
    );

endmodule
