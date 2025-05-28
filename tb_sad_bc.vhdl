library ieee;
use ieee.std_logic_1164.all;

entity tb_sad_bc is
end entity;

architecture behavior of tb_sad_bc is

    -- Sinais para conectar ao DUT (Device Under Test)
    signal clk       : std_logic := '0';
    signal rst_a     : std_logic := '0';
    signal enable    : std_logic := '0';
    signal menor     : std_logic := '0';
    
    signal done      : std_logic;
    signal read_mem  : std_logic;
    signal ci        : std_logic;
    signal zi        : std_logic;
    signal cpa       : std_logic;
    signal cpb       : std_logic;
    signal zsoma     : std_logic;
    signal csoma     : std_logic;
    signal csad      : std_logic;

    -- Clock period constant
    constant clk_period : time := 20 ns;

begin

    -- Instanciação do bloco de controle (DUT)
    uut: entity work.das_cb
        port map (
            clk       => clk,
            rst_a     => rst_a,
            enable    => enable,
            menor     => menor,
            done      => done,
            read_mem  => read_mem,
            ci        => ci,
            zi        => zi,
            cpa       => cpa,
            cpb       => cpb,
            zsoma     => zsoma,
            csoma     => csoma,
            csad      => csad
        );
    
    -- Geração de clock
    clk_process : process
    begin
        while now < 900 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo de estímulo
    stim_proc : process
    begin
        -- Reset
        rst_a <= '1';
        wait for 10 ns;
        rst_a <= '0';
        wait for clk_period;

        -- Início do processamento
        enable <= '1';
        wait for 2 * clk_period;

        -- Simula o laço: menor = '1' por duas iterações
        menor <= '1';
        wait for 4 * clk_period; -- Simula 2 ciclos dentro do laço

        -- menor = '0' para sair do laço e ir para estado final
        menor <= '0';
        wait for 1 * clk_period;

        enable <= '0'; -- Desabilita o processamento
        wait for 2 * clk_period;
        -- Finaliza simulação
        wait;
    end process;

end architecture;
