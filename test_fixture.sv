`timescale 1ns/1ps

module test_fixture;

    //interfaz 

    gp_adc_interface intf();

    //tb_top

    tb_top tb(
        .intf(intf)
    );

    //DUT


endmodule