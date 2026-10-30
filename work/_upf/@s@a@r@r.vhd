library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity SARR is
  PORT (
    signal b7 : IN real;
    signal b6 : IN real;
    signal b5 : IN real;
    signal b4 : IN real;
    signal b3 : IN real;
    signal b2 : IN real;
    signal b1 : IN real;
    signal b0 : IN real;
    signal EOC : IN real;
    signal VDD : IN real;
    signal VSS : IN real;
    signal o7 : OUT real;
    signal o6 : OUT real;
    signal o5 : OUT real;
    signal o4 : OUT real;
    signal o3 : OUT real;
    signal o2 : OUT real;
    signal o1 : OUT real;
    signal o0 : OUT real);
end entity SARR;

