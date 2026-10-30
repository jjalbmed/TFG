LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARSequenceRow IS
  PORT (
    SIGNAL CLK : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real;
    SIGNAL sample_clk : OUT real;
    SIGNAL net2 : OUT real;
    SIGNAL net32 : OUT real;
    SIGNAL net42 : OUT real;
    SIGNAL net47 : OUT real;
    SIGNAL net51 : OUT real;
    SIGNAL net60 : OUT real;
    SIGNAL net72 : OUT real;
    SIGNAL net75 : OUT real;
    SIGNAL net84 : OUT real;
    SIGNAL register_clk : OUT real);
END ENTITY SARSequenceRow;

