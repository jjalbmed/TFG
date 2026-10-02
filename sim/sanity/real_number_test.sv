`timescale 1ns/1ps

module real_test;

    logic clk;

    real vin;
    real vout;

    // Clock de 100 MHz
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    // Sample & Hold simplificado usando real numbers
    always @(posedge clk) begin
        vout = vin;

        $display(
            "time = %0t | vin = %0.4f V | vout = %0.4f V",
            $time,
            vin,
            vout
        );
    end


    // Estímulos
    initial begin

        vin = 0.100;

        #7;
        vin = 0.537;

        #10;
        vin = 1.243;

        #10;
        vin = 0.825;

        #10;
        vin = 1.700;

        #20;

        $finish;

    end

endmodule