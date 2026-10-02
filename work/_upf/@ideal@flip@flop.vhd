library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity IdealFlipFlop is
  generic (
   vtrans :   real :=  9.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    signal Set : IN real;
    signal Reset : IN real;
    signal D : IN real;
    signal Q : OUT real;
    signal QBAR : OUT real;
    signal CLK : IN real;
    signal VDD : IN real;
    signal VSS : IN real);
end entity IdealFlipFlop;

