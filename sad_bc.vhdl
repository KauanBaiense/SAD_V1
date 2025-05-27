--------------------------------------------------
--	Author:      Ismael Seidel (entity)
--	Created:     May 1, 2025
--
--	Project:     Exercício 6 de INE5406
--	Description: Contém a descrição da entidade `sad_bc`, que representa o
--               bloco de controle (BC) do circuito para cálculo da soma das
--               diferenças absolutas (SAD - Sum of Absolute Differences).
--               Este bloco é responsável pela geração dos sinais de controle
--               necessários para coordenar o funcionamento do bloco operativo
--               (BO), como enable de registradores, seletores de multiplexadores,
--               sinais de início e término de processamento, etc.
--               A arquitetura é comportamental e deverá descrever uma máquina
--               de estados finitos (FSM) adequada ao controle do datapath.
--               Os sinais adicionais de controle devem ser definidos conforme
--               a necessidade do projeto. PS: já foram definidos nos slides
--               da aula 6T.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- Bloco de Controle (BC) do circuito SAD.
-- Responsável por gerar os sinais de controle para o bloco operativo (BO),
-- geralmente por meio de uma FSM.
entity sad_bc is
	port(
		clk   : in std_logic;  -- clock (sinal de relógio)
		rst_a : in std_logic;   -- reset assíncrono ativo em nível alto
		enable  : in std_logic;   -- sinal de início de processamento
        done  : out std_logic;  -- sinal de término de processamento
        read_mem : out std_logic; -- sinal de leitura da memória
        menor : in std_logic; -- sinal de controle do laço de execução
		ci    : out std_logic;
        zi    : out std_logic;
        cpa   : out std_logic;
        cpb   : out std_logic;
        zsoma : out std_logic;
        csoma : out std_logic;
        csad  : out std_logic
	);
end entity;
-- Não altere o nome da entidade nem da arquitetura!

architecture behavior of sad_bc is
    type estados_t is (
        s0,s1,s2,s3,s4,s5
    );
    signal estado: estados_t;

    signal cont : std_logic := '0';
    
begin   
  LPE : process(clk,rst_a)
        begin
            if rst_a = '1' then
                estado <= s0;
            elsif rising_edge(clk) then
                case estado is 
                    when s0 =>
                        if enable = '1' then
                            estado <= s1;
                        elsif enable = '0' then
                            estado <= s0;
                            --done <= '1';
                        end if;
                    when s1 =>
                        estado <= s2;
                    when s2 =>
                        if menor = '1' then
                            estado <= s3;
                        elsif menor = '0' then
                            estado <= s5;
                        end if;    
                    when s3 =>
                        estado <= s4;
                    when s4 =>
                        estado <= s2;
                    when s5 =>
                        estado <= s0;
                end case;
            end if;
    end process LPE;

 LS: process(estado)
     begin
        done  <= '1' when estado = s0 else '0';
    
        ci     <= '1' when estado = s1 else '0';
        zi     <= '1' when estado = s1 else '0';
        csoma  <= '1' when estado = s1 else '0';
        zsoma  <= '1' when estado = s1 else '0';
    
        cpa     <= '1' when estado = s3 else '0';
        cpb     <= '1' when estado = s3 else '0';
        read_mem <= '1' when estado = s3 else '0';
        
        csoma  <= '1' when estado = s4 else '0';
        ci     <= '1' when estado = s4 else '0';
    
        csad   <= '1' when estado = s5 else '0';
    end process LS;
    

    -- Descreva a FSM responsável por coordenar o circuito SAD.
    
    -- Dica: separar em 3 processos:
    -- 1) carga e reset do registrador de estado;
    -- 2) LPE;
    -- 3) LS.
end architecture;
