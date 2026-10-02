LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY SARSequenceRow IS
  PORT (
    SIGNAL Reset : IN real;
    SIGNAL CLK : IN real;
    SIGNAL VDD : IN real;
    SIGNAL VSS : IN real;
    SIGNAL seq_b7 : OUT real;
    SIGNAL seq_b6 : OUT real;
    SIGNAL seq_b5 : OUT real;
    SIGNAL seq_b4 : OUT real;
    SIGNAL seq_b3 : OUT real;
    SIGNAL seq_b2 : OUT real;
    SIGNAL seq_b1 : OUT real;
    SIGNAL seq_b0 : OUT real;
    SIGNAL register_clk : OUT real);
END ENTITY SARSequenceRow;

