library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity \Not\ is
  generic (
   vtrans :   real :=  9.000000e-01 );
  PORT (
    signal \In\ : IN real;
    signal \Out\ : OUT real;
    signal VDD : IN real;
    signal VSS : IN real);
end entity \Not\;

