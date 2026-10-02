module sample_hold_rnm (
    input logic clk,
    input real vin,
    output real vout
);

    always @(posedge clk)
        vout = vin;

endmodule