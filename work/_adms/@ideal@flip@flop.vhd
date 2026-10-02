LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY IdealFlipFlop IS
  GENERIC (
   vtrans :   real :=  9.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    SIGNAL Set : IN real;
    SIGNAL Reset : IN real;
    SIGNAL D : IN real;
    SIGNAL Q : OUT real;
    SIGNAL QBAR : OUT real;
    SIGNAL CLK : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real);
END ENTITY IdealFlipFlop;

