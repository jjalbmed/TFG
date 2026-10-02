// ADC top-level verification interface.
interface gp_adc_interface;
    logic clk;
    real vin, vout;
    real cmp_ref, cmp_out;
    real dac_b0, dac_b1, dac_b2, dac_b3;
    real dac_b4, dac_b5, dac_b6, dac_b7;
    real dac_out;
    real ff_set, ff_reset, ff_d;
    real ff_q, ff_qbar;
    real sar_in, sar_reset;
    real sar_seq_b7, sar_seq_b6, sar_seq_b5, sar_seq_b4;
    real sar_seq_b3, sar_seq_b2, sar_seq_b1, sar_seq_b0;
    real sar_register_clk;
    real sar_b7, sar_b6, sar_b5, sar_b4, sar_b3, sar_b2, sar_b1, sar_b0;
    real sar_b7b, sar_b6b, sar_b5b, sar_b4b, sar_b3b, sar_b2b, sar_b1b, sar_b0b;
    real sar_seq_reset, sar_seq_clk;
    real sar_auto_seq_b7, sar_auto_seq_b6, sar_auto_seq_b5, sar_auto_seq_b4;
    real sar_auto_seq_b3, sar_auto_seq_b2, sar_auto_seq_b1, sar_auto_seq_b0;
    real sar_auto_register_clk;

    // Digital testbench timing. These skews only define SystemVerilog
    // scheduling; they do not model the AMS propagation/settling time.
    clocking driver_cb @(posedge clk);
        default output #0;
        output vin;
    endclocking

    clocking monitor_cb @(posedge clk);
        // Sample Vin in the observed region of the sampling time slot.
        input #0 vin;
    endclocking

    modport driver (
        clocking driver_cb,
        input clk,
        input cmp_out,
        input dac_out,
        input ff_q,
        input ff_qbar,
        input sar_b7,
        input sar_b6,
        input sar_b5,
        input sar_b4,
        input sar_b3,
        input sar_b2,
        input sar_b1,
        input sar_b0,
        input sar_b7b,
        input sar_b6b,
        input sar_b5b,
        input sar_b4b,
        input sar_b3b,
        input sar_b2b,
        input sar_b1b,
        input sar_b0b,
        output vin,
        output cmp_ref,
        output dac_b0,
        output dac_b1,
        output dac_b2,
        output dac_b3,
        output dac_b4,
        output dac_b5,
        output dac_b6,
        output dac_b7,
        output ff_set,
        output ff_reset,
        output ff_d,
        output sar_in,
        output sar_reset,
        output sar_seq_b7,
        output sar_seq_b6,
        output sar_seq_b5,
        output sar_seq_b4,
        output sar_seq_b3,
        output sar_seq_b2,
        output sar_seq_b1,
        output sar_seq_b0,
        output sar_register_clk,
        output sar_seq_reset,
        output sar_seq_clk,
        input sar_auto_seq_b7,
        input sar_auto_seq_b6,
        input sar_auto_seq_b5,
        input sar_auto_seq_b4,
        input sar_auto_seq_b3,
        input sar_auto_seq_b2,
        input sar_auto_seq_b1,
        input sar_auto_seq_b0,
        input sar_auto_register_clk
    );

    modport dut (
        input clk,
        input vin,
        input cmp_ref,
        output vout,
        output cmp_out,
        input dac_b0,
        input dac_b1,
        input dac_b2,
        input dac_b3,
        input dac_b4,
        input dac_b5,
        input dac_b6,
        input dac_b7,
        output dac_out,
        input ff_set,
        input ff_reset,
        input ff_d,
        output ff_q,
        output ff_qbar,
        input sar_in,
        input sar_reset,
        input sar_seq_b7,
        input sar_seq_b6,
        input sar_seq_b5,
        input sar_seq_b4,
        input sar_seq_b3,
        input sar_seq_b2,
        input sar_seq_b1,
        input sar_seq_b0,
        input sar_register_clk,
        output sar_b7,
        output sar_b6,
        output sar_b5,
        output sar_b4,
        output sar_b3,
        output sar_b2,
        output sar_b1,
        output sar_b0,
        output sar_b7b,
        output sar_b6b,
        output sar_b5b,
        output sar_b4b,
        output sar_b3b,
        output sar_b2b,
        output sar_b1b,
        output sar_b0b,
        input sar_seq_reset,
        input sar_seq_clk,
        output sar_auto_seq_b7,
        output sar_auto_seq_b6,
        output sar_auto_seq_b5,
        output sar_auto_seq_b4,
        output sar_auto_seq_b3,
        output sar_auto_seq_b2,
        output sar_auto_seq_b1,
        output sar_auto_seq_b0,
        output sar_auto_register_clk
    );

    modport monitor (
        clocking monitor_cb,
        input clk,
        input vin,
        input vout
    );

endinterface
