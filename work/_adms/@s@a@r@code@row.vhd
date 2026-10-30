LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARCodeRow IS
  PORT (
    SIGNAL \In\ : IN real;
    SIGNAL sample_clk : IN real;
    SIGNAL net32 : IN real;
    SIGNAL net42 : IN real;
    SIGNAL net47 : IN real;
    SIGNAL net51 : IN real;
    SIGNAL net60 : IN real;
    SIGNAL net72 : IN real;
    SIGNAL net75 : IN real;
    SIGNAL net84 : IN real;
    SIGNAL register_clk : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real;
    SIGNAL b7 : OUT real;
    SIGNAL b6 : OUT real;
    SIGNAL b5 : OUT real;
    SIGNAL b4 : OUT real;
    SIGNAL b3 : OUT real;
    SIGNAL b2 : OUT real;
    SIGNAL b1 : OUT real;
    SIGNAL b0 : OUT real;
    SIGNAL b7b : OUT real;
    SIGNAL b6b : OUT real;
    SIGNAL b5b : OUT real;
    SIGNAL b4b : OUT real;
    SIGNAL b3b : OUT real;
    SIGNAL b2b : OUT real;
    SIGNAL b1b : OUT real;
    SIGNAL b0b : OUT real);
END ENTITY SARCodeRow;

