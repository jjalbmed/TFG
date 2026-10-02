LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY Comparador IS
  GENERIC (
   trans_time :   real :=  1.000000e-12;
   ret :   integer  := 0;
   clk_threshold :   real :=  9.000000e-01 );
  PORT (
    SIGNAL InS : IN real;
    SIGNAL InD : IN real;
    SIGNAL \Out\ : OUT real;
    SIGNAL clk : IN real);
END ENTITY Comparador;

