library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity AND_Ideal is
  generic (
   vtrans :   real :=  9.000000e-01;
   VDD :   real :=  1.800000e+00;
   VSS :   real :=  0.000000e+00 );
  PORT (
    signal \Out\ : OUT real;
    signal In1 : IN real;
    signal In2 : IN real);
end entity AND_Ideal;

