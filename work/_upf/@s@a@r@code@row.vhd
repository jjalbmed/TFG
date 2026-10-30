library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SARCodeRow is
  PORT (
    signal \In\ : IN real;
    signal sample_clk : IN real;
    signal net32 : IN real;
    signal net42 : IN real;
    signal net47 : IN real;
    signal net51 : IN real;
    signal net60 : IN real;
    signal net72 : IN real;
    signal net75 : IN real;
    signal net84 : IN real;
    signal register_clk : IN real;
    signal VDD : IN real;
    signal VSS : IN real;
    signal b7 : OUT real;
    signal b6 : OUT real;
    signal b5 : OUT real;
    signal b4 : OUT real;
    signal b3 : OUT real;
    signal b2 : OUT real;
    signal b1 : OUT real;
    signal b0 : OUT real;
    signal b7b : OUT real;
    signal b6b : OUT real;
    signal b5b : OUT real;
    signal b4b : OUT real;
    signal b3b : OUT real;
    signal b2b : OUT real;
    signal b1b : OUT real;
    signal b0b : OUT real);
end entity SARCodeRow;

