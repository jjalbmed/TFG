library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity ADC_DAC_debug_monitor is
  PORT (
    signal b3 : IN real;
    signal b2 : IN real;
    signal b1 : IN real;
    signal b0 : IN real;
    signal original : IN real;
    signal event_driven : IN real;
    signal trace : IN real);
end entity ADC_DAC_debug_monitor;

