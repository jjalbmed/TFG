LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARLogic IS
  GENERIC (
   vtrans :   real :=  9.000000e-01;
   gate_delay :   integer  := 0;
   gate_trans :   real :=  1.000000e-11 );
  PORT (
    SIGNAL CLK : IN real;
    SIGNAL \In\ : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real;
    SIGNAL b0 : OUT real;
    SIGNAL b1 : OUT real;
    SIGNAL b2 : OUT real;
    SIGNAL b3 : OUT real;
    SIGNAL b4 : OUT real;
    SIGNAL b5 : OUT real;
    SIGNAL b6 : OUT real;
    SIGNAL b7 : OUT real;
    SIGNAL register_clk : OUT real;
    SIGNAL sample_clk : OUT real);
END ENTITY SARLogic;

