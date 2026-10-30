LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY \Not\ IS
  GENERIC (
   vtrans :   real :=  9.000000e-01 );
  PORT (
    SIGNAL \In\ : IN real;
    SIGNAL \Out\ : OUT real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real);
END ENTITY \Not\;

