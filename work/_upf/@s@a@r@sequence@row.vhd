library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SARSequenceRow is
  PORT (
    signal Reset : IN real;
    signal CLK : IN real;
    signal VDD : IN real;
    signal VSS : IN real;
    signal seq_b7 : OUT real;
    signal seq_b6 : OUT real;
    signal seq_b5 : OUT real;
    signal seq_b4 : OUT real;
    signal seq_b3 : OUT real;
    signal seq_b2 : OUT real;
    signal seq_b1 : OUT real;
    signal seq_b0 : OUT real;
    signal register_clk : OUT real);
end entity SARSequenceRow;

