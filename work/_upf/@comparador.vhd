library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity Comparador is
  generic (
   trans_time :   real :=  1.000000e-12;
   ret :   integer  := 0;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    signal InS : IN real;
    signal InD : IN real;
    signal \Out\ : OUT real;
    signal clk : IN real);
end entity Comparador;

