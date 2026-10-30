library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SARSequenceRow is
  PORT (
    signal CLK : IN real;
    signal VDD : IN real;
    signal VSS : IN real;
    signal sample_clk : OUT real;
    signal net2 : OUT real;
    signal net32 : OUT real;
    signal net42 : OUT real;
    signal net47 : OUT real;
    signal net51 : OUT real;
    signal net60 : OUT real;
    signal net72 : OUT real;
    signal net75 : OUT real;
    signal net84 : OUT real;
    signal register_clk : OUT real);
end entity SARSequenceRow;

