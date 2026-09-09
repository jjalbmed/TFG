//interfaz de propósito general del adc
//no es componente uvm, no hereda includes ni packages
interface gp_adc_interface;
    logic clk, set, reset, d, q;


modport driver (
    input clk, //el driver no genera el clk
    output set,
    output d,
    output reset
);

modport ideal_ff(
    input clk,
    input set,
    input d,
    input reset,
    output q
);

modport monitor(
    input clk, set, d, reset, q
);



endinterface