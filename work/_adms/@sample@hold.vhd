LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SampleHold IS
  GENERIC (
   vtrans :   real :=  5.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    SIGNAL clk : IN real;
    SIGNAL vin : IN real;
    SIGNAL vout : OUT real);
END ENTITY SampleHold;

