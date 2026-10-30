library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SARLogic is
  generic (
   vtrans :   real :=  9.000000e-01;
   gate_delay :   integer  := 0;
   gate_trans :   real :=  1.000000e-11 );
  PORT (
    signal CLK : IN real;
    signal \In\ : IN real;
    signal VDD : IN real;
    signal VSS : IN real;
    signal b0 : OUT real;
    signal b1 : OUT real;
    signal b2 : OUT real;
    signal b3 : OUT real;
    signal b4 : OUT real;
    signal b5 : OUT real;
    signal b6 : OUT real;
    signal b7 : OUT real;
    signal register_clk : OUT real;
    signal sample_clk : OUT real);
end entity SARLogic;

