library ieee;
use ieee.std_logic_1164.all;

use ieee.upf.all;

entity ADC_SARR_debug_monitor is
  PORT (
    signal cmp_out : IN real;
    signal b0 : IN real;
    signal eoc : IN real;
    signal o0 : IN real);
end entity ADC_SARR_debug_monitor;

