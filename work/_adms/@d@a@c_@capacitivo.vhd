LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY DAC_Capacitivo IS
  GENERIC (
   vtrans :   real :=  9.000000e-01;
   delay :   integer  := 0;
   trans_time :   real :=  1.000000e-12 );
  PORT (
    SIGNAL b0 : IN real;
    SIGNAL b1 : IN real;
    SIGNAL b2 : IN real;
    SIGNAL b3 : IN real;
    SIGNAL b4 : IN real;
    SIGNAL b5 : IN real;
    SIGNAL b6 : IN real;
    SIGNAL b7 : IN real;
    SIGNAL Aout : OUT real;
    SIGNAL vdd : IN real;
    SIGNAL vss : IN real);
END ENTITY DAC_Capacitivo;

