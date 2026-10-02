library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SampleHold is
  generic (
   vtrans :   real :=  5.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    signal clk : IN real;
    signal vin : IN real;
    signal vout : OUT real);
end entity SampleHold;

