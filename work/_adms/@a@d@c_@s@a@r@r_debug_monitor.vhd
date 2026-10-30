LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY ADC_SARR_debug_monitor IS
  PORT (
    SIGNAL cmp_out : IN real;
    SIGNAL b0 : IN real;
    SIGNAL eoc : IN real;
    SIGNAL o0 : IN real);
END ENTITY ADC_SARR_debug_monitor;

