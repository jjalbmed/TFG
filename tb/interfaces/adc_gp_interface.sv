// ADC top-level verification interface.
interface gp_adc_interface;

    logic clk;
    logic sample_clk_d;

    real vin;
    real vout;

    real cmp_out;
    real dac_out;

    real sar_logic_b7, sar_logic_b6, sar_logic_b5, sar_logic_b4;
    real sar_logic_b3, sar_logic_b2, sar_logic_b1, sar_logic_b0;

    real sar_logic_sample_clk;
    real sar_logic_register_clk;

    real sarr_o7, sarr_o6, sarr_o5, sarr_o4;
    real sarr_o3, sarr_o2, sarr_o1, sarr_o0;

    assign sample_clk_d = (sar_logic_sample_clk > 0.9);

    clocking driver_cb @(posedge clk);
        default output #0;
        output vin;
    endclocking

    clocking monitor_cb @(posedge clk or negedge clk);
        input #0 vin;
    endclocking

    modport driver (
        clocking driver_cb,

        input clk,

        output vin,

        input vout,
        input cmp_out,
        input dac_out,

        input sar_logic_b7,
        input sar_logic_b6,
        input sar_logic_b5,
        input sar_logic_b4,
        input sar_logic_b3,
        input sar_logic_b2,
        input sar_logic_b1,
        input sar_logic_b0,

        input sar_logic_sample_clk,
        input sar_logic_register_clk,

        input sarr_o7,
        input sarr_o6,
        input sarr_o5,
        input sarr_o4,
        input sarr_o3,
        input sarr_o2,
        input sarr_o1,
        input sarr_o0
    );

    modport monitor (
        clocking monitor_cb,
        input clk,
        input vin,
        input vout,

        input sar_logic_sample_clk,
        input sar_logic_register_clk,
        input sample_clk_d,
        
        input sarr_o7,
        input sarr_o6,
        input sarr_o5,
        input sarr_o4,
        input sarr_o3,
        input sarr_o2,
        input sarr_o1,
        input sarr_o0

    );

endinterface
