LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARR IS
  PORT (
    SIGNAL b7 : IN real;
    SIGNAL b6 : IN real;
    SIGNAL b5 : IN real;
    SIGNAL b4 : IN real;
    SIGNAL b3 : IN real;
    SIGNAL b2 : IN real;
    SIGNAL b1 : IN real;
    SIGNAL b0 : IN real;
    SIGNAL EOC : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real;
    SIGNAL o7 : OUT real;
    SIGNAL o6 : OUT real;
    SIGNAL o5 : OUT real;
    SIGNAL o4 : OUT real;
    SIGNAL o3 : OUT real;
    SIGNAL o2 : OUT real;
    SIGNAL o1 : OUT real;
    SIGNAL o0 : OUT real);
END ENTITY SARR;

