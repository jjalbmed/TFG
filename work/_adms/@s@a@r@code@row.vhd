LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARCodeRow IS
  PORT (
    SIGNAL \In\ : IN real;
    SIGNAL Reset : IN real;
    SIGNAL seq_b7 : IN real;
    SIGNAL seq_b6 : IN real;
    SIGNAL seq_b5 : IN real;
    SIGNAL seq_b4 : IN real;
    SIGNAL seq_b3 : IN real;
    SIGNAL seq_b2 : IN real;
    SIGNAL seq_b1 : IN real;
    SIGNAL seq_b0 : IN real;
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

