library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity DAC_Capacitivo is
  generic (
   vtrans :   real :=  9.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12 );
  PORT (
    signal b0 : IN real;
    signal b1 : IN real;
    signal b2 : IN real;
    signal b3 : IN real;
    signal b4 : IN real;
    signal b5 : IN real;
    signal b6 : IN real;
    signal b7 : IN real;
    signal Aout : OUT real;
    signal vdd : IN real;
    signal vss : IN real);
end entity DAC_Capacitivo;

