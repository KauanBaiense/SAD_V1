library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sad_pack.all;

entity tb_sad_bo is
end entity;

architecture test of tb_sad_bo is

  -- Configuração
  constant CFG : datapath_configuration_t := (
    bits_per_sample   => 8,
    samples_per_block => 64,
    parallel_samples  => 1
  );
   constant ClockPeriod  : time    := 20 ns;
  -- Sinais de entrada
  signal clk         : std_logic := '0';
  signal sample_ori  : std_logic_vector(7 downto 0) := (others => '0');
  signal sample_can  : std_logic_vector(7 downto 0) := (others => '0');
  signal ci, zi      : std_logic := '0';
  signal cpa, cpb    : std_logic := '0';
  signal zsoma, csoma, csad : std_logic := '0';

  -- Sinais de saída
  signal address     : std_logic_vector(5 downto 0);
  signal sad         : std_logic_vector(13 downto 0);
  signal menor       : std_logic;

begin

  -- Instanciação do DUT (Device Under Test)
  DUT: entity work.sad_bo
    generic map (CFG => CFG)
    port map (
      clk         => clk,
      sample_ori  => sample_ori,
      sample_can  => sample_can,
      address     => address,
      sad         => sad,
      menor       => menor,
      ci          => ci,
      zi          => zi,
      cpa         => cpa,
      cpb         => cpb,
      zsoma       => zsoma,
      csoma       => csoma,
      csad        => csad
    );

  clock_process: process
      begin
          for i in 0 to 35 loop
              clk <= '0';
              wait for ClockPeriod / 2;
              clk <= '1';
              wait for ClockPeriod / 2;
          end loop;
          wait;
      end process;

  stimulus: process
  begin
    zi <= '1';
    ci <= '1'; 
    wait for 20 ns;

    zi <= '0';
    ci <= '1'; 
    wait for 20 ns;

    zi <= '0';
    ci <= '1'; 
    wait for 20 ns;

    zi <= '0';
    ci <= '1'; 
    wait for 20 ns;

    zi <= '0';
    ci <= '1'; 
    wait for 20 ns;

    zi <= '0';
    ci <= '1'; 
    wait for 20 ns;
    -- Força amostras para subtração
    sample_ori <= x"10";
    sample_can <= x"08";

    -- Ativa carga nos registradores
    cpa <= '1';
    cpb <= '1';
    zsoma <= '1';
    csoma <= '1';
    csad  <= '1';


    -- Encerra simulação
    wait;
  end process;

end architecture;
