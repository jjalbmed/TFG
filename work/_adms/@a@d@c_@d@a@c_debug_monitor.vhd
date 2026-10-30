LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY STD;
USE STD.ALL;

ENTITY ADC_DAC_debug_monitor IS
  PORT (
    SIGNAL b3 : IN real;
    SIGNAL b2 : IN real;
    SIGNAL b1 : IN real;
    SIGNAL b0 : IN real;
    SIGNAL original : IN real;
    SIGNAL event_driven : IN real;
    SIGNAL trace : IN real);
END ENTITY ADC_DAC_debug_monitor;

