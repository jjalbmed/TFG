`timescale 1ns/1ps

// Verilog wrapper for the mixed-signal ADC hierarchy.
// The wreal ports allow ADMS to insert the existing REAL <-> electrical
// boundary elements at the Verilog-A instances.
module adc_top(
    clk, vin, vout, cmp_ref, cmp_out,
    dac_b0, dac_b1, dac_b2, dac_b3, dac_b4, dac_b5, dac_b6, dac_b7,
    dac_out,
    ff_set, ff_reset, ff_d, ff_q, ff_qbar,
    sar_in, sar_reset,
    sar_seq_b7, sar_seq_b6, sar_seq_b5, sar_seq_b4,
    sar_seq_b3, sar_seq_b2, sar_seq_b1, sar_seq_b0,
    sar_register_clk,
    sar_b7, sar_b6, sar_b5, sar_b4, sar_b3, sar_b2, sar_b1, sar_b0,
    sar_b7b, sar_b6b, sar_b5b, sar_b4b, sar_b3b, sar_b2b, sar_b1b, sar_b0b,
    sar_seq_reset, sar_seq_clk,
    sar_auto_seq_b7, sar_auto_seq_b6, sar_auto_seq_b5, sar_auto_seq_b4,
    sar_auto_seq_b3, sar_auto_seq_b2, sar_auto_seq_b1, sar_auto_seq_b0,
    sar_auto_register_clk
);

    input  wreal clk;
    input  wreal vin;
    output wreal vout;
    input  wreal cmp_ref;
    output wreal cmp_out;
    input  wreal dac_b0;
    input  wreal dac_b1;
    input  wreal dac_b2;
    input  wreal dac_b3;
    input  wreal dac_b4;
    input  wreal dac_b5;
    input  wreal dac_b6;
    input  wreal dac_b7;
    output wreal dac_out;
    input  wreal ff_set;
    input  wreal ff_reset;
    input  wreal ff_d;
    output wreal ff_q;
    output wreal ff_qbar;
    input  wreal sar_in;
    input  wreal sar_reset;
    input  wreal sar_seq_b7;
    input  wreal sar_seq_b6;
    input  wreal sar_seq_b5;
    input  wreal sar_seq_b4;
    input  wreal sar_seq_b3;
    input  wreal sar_seq_b2;
    input  wreal sar_seq_b1;
    input  wreal sar_seq_b0;
    input  wreal sar_register_clk;
    output wreal sar_b7;
    output wreal sar_b6;
    output wreal sar_b5;
    output wreal sar_b4;
    output wreal sar_b3;
    output wreal sar_b2;
    output wreal sar_b1;
    output wreal sar_b0;
    output wreal sar_b7b;
    output wreal sar_b6b;
    output wreal sar_b5b;
    output wreal sar_b4b;
    output wreal sar_b3b;
    output wreal sar_b2b;
    output wreal sar_b1b;
    output wreal sar_b0b;
    input  wreal sar_seq_reset;
    input  wreal sar_seq_clk;
    output wreal sar_auto_seq_b7;
    output wreal sar_auto_seq_b6;
    output wreal sar_auto_seq_b5;
    output wreal sar_auto_seq_b4;
    output wreal sar_auto_seq_b3;
    output wreal sar_auto_seq_b2;
    output wreal sar_auto_seq_b1;
    output wreal sar_auto_seq_b0;
    output wreal sar_auto_register_clk;

    // Keep the SampleHold output visible at vout while also feeding the
    // comparator through an explicit internal wreal node.
    wreal sh_vout;
    wreal dac_vdd;
    wreal dac_vss;
    wreal ff_vdd;
    wreal ff_vss;
    wreal sar_vdd;
    wreal sar_vss;
    wreal sar_seq_vdd;
    wreal sar_seq_vss;

    assign dac_vdd = 1.8;
    assign dac_vss = 0.0;
    assign ff_vdd = 1.8;
    assign ff_vss = 0.0;
    assign sar_vdd = 1.8;
    assign sar_vss = 0.0;
    assign sar_seq_vdd = 1.8;
    assign sar_seq_vss = 0.0;

    SampleHold u_sample_hold (
        .clk  (clk),
        .vin  (vin),
        .vout (sh_vout)
    );

    assign vout = sh_vout;

    Comparador u_comparador (
        .InS (sh_vout),
        .InD (dac_out),
        .Out (cmp_out),
        .clk (clk)
    );

    // The DAC remains independent of the comparator in this integration step.
    DAC_Capacitivo u_dac (
        .b0   (dac_b0),
        .b1   (dac_b1),
        .b2   (dac_b2),
        .b3   (dac_b3),
        .b4   (dac_b4),
        .b5   (dac_b5),
        .b6   (dac_b6),
        .b7   (dac_b7),
        .Aout (dac_out),
        .vdd  (dac_vdd),
        .vss  (dac_vss)
    );

    // Standalone flip-flop instance for independent validation.
    IdealFlipFlop u_ideal_flipflop (
        .Set   (ff_set),
        .Reset (ff_reset),
        .D     (ff_d),
        .Q     (ff_q),
        .QBAR  (ff_qbar),
        .CLK   (clk),
        .VDD   (ff_vdd),
        .VSS   (ff_vss)
    );

    // Isolated lower SAR code row for manual sequencing validation.
    SARCodeRow u_sar_code_row (
        .In           (sar_in),
        .Reset        (sar_reset),
        .seq_b7       (sar_seq_b7),
        .seq_b6       (sar_seq_b6),
        .seq_b5       (sar_seq_b5),
        .seq_b4       (sar_seq_b4),
        .seq_b3       (sar_seq_b3),
        .seq_b2       (sar_seq_b2),
        .seq_b1       (sar_seq_b1),
        .seq_b0       (sar_seq_b0),
        .register_clk (sar_register_clk),
        .VDD          (sar_vdd),
        .VSS          (sar_vss),
        .b7           (sar_b7),
        .b6           (sar_b6),
        .b5           (sar_b5),
        .b4           (sar_b4),
        .b3           (sar_b3),
        .b2           (sar_b2),
        .b1           (sar_b1),
        .b0           (sar_b0),
        .b7b          (sar_b7b),
        .b6b          (sar_b6b),
        .b5b          (sar_b5b),
        .b4b          (sar_b4b),
        .b3b          (sar_b3b),
        .b2b          (sar_b2b),
        .b1b          (sar_b1b),
        .b0b          (sar_b0b)
    );

    // Experimental upper SAR sequence row.  Its outputs deliberately remain
    // isolated from SARCodeRow during this validation stage.
    SARSequenceRow u_sar_sequence_row (
        .Reset        (sar_seq_reset),
        .CLK          (sar_seq_clk),
        .VDD          (sar_seq_vdd),
        .VSS          (sar_seq_vss),
        .seq_b7       (sar_auto_seq_b7),
        .seq_b6       (sar_auto_seq_b6),
        .seq_b5       (sar_auto_seq_b5),
        .seq_b4       (sar_auto_seq_b4),
        .seq_b3       (sar_auto_seq_b3),
        .seq_b2       (sar_auto_seq_b2),
        .seq_b1       (sar_auto_seq_b1),
        .seq_b0       (sar_auto_seq_b0),
        .register_clk (sar_auto_register_clk)
    );

endmodule
