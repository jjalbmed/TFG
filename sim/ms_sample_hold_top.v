`timescale 1ns/1ps

module ms_sample_hold_top;

    real clk_drv;
    real vin_drv;

    wreal clk;
    wreal vin;
    wreal vout;

    assign clk = clk_drv;
    assign vin = vin_drv;

    SampleHold dut (
        .clk  (clk),
        .vin  (vin),
        .vout (vout)
    );

    // Clock: 0 V / 1.8 V
    initial begin
        clk_drv = 0.0;
        forever #5
            clk_drv = (clk_drv < 0.9) ? 1.8 : 0.0;
    end

    // Entrada analógica
    initial begin
        vin_drv = 0.73;

        #12;
        vin_drv = 1.20;

        #20;
        $finish;
    end

    initial begin
        $monitor(
            "t=%0t clk=%0.2f V vin=%0.3f V vout=%0.3f V",
            $time, clk, vin, vout
        );
    end

endmodule