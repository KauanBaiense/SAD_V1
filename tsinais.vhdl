library ieee;
use ieee.std_logic_1164.all;

package tsinais is
  type sinais_t is record 
    ci    : std_logic;
    zi    : std_logic;
    cpa   : std_logic;
    cpb   : std_logic;
    zsoma : std_logic;
    csoma : std_logic;
    csad  : std_logic;
  end record;
end package;

package body tsinais is
end package body;
