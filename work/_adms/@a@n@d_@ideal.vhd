LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY AND_Ideal IS
  GENERIC (
   vtrans :   real :=  9.000000e-01;
   VDD :   real :=  1.800000e+00;
   VSS :   real :=  0.000000e+00 );
  PORT (
    SIGNAL \Out\ : OUT real;
    SIGNAL In1 : IN real;
    SIGNAL In2 : IN real);
END ENTITY AND_Ideal;

