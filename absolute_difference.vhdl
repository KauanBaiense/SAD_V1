--------------------------------------------------
--	Author:      Ismael Seidel (entity)
--	Created:     May 1, 2025
--
--	Project:     Exercício 6 de INE5406
--	Description: Contém a descrição de uma entidade para o cálculo da
--               diferença absoluta entre dois valores de N bits sem sinal.
--               A saída também é um valor de N bits sem sinal. 
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Calcula a diferença absoluta entre dois valores, similar ao Exercício 2.
-- Note que agora nosso circuito será parametrizável para N bits e as entradas
-- e saídas são unsigned (no Exercício 2 eram std_logic_vector pois tratava-se do
-- top-level). 
-- A saída abs_diff deve ser o resultado de |input_a - input_b|, onde | | é a operação
-- de valor absoluto.
entity absolute_difference IS
	generic(
		N : positive := 8
	);
	port(
		input_a  : in  unsigned(N - 1 downto 0);
		input_b  : in  unsigned(N - 1 downto 0);
		abs_diff : out unsigned(N - 1 downto 0)
	);
end entity;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture structure OF absolute_difference IS
   signal A1, B1, S :  SIGNED(N DOWNTO 0);
begin

    A1 <= signed(resize(input_a,N+1));
    B1 <= signed(resize(input_b,N+1));
    S <= (A1 - B1);
    abs_diff <= resize(unsigned(abs(S)),N);
    
    --    O objetivo nesta descrição é apenas usar possíveis conversões e instanciar
    -- Outros módulos para fazer o cálculo.
    -- Se você quiser, pode usar a mesmo lógica do Exercício 2, mas garantindo o
    -- uso de generics.
    -- É possível fazer o upload de um arquivo para criar a entidade absolute.
    
    -- DICA: é possível fazer o cálculo do valor absoluto com 2 subtratores e um
    -- multiplexador 2:1. Tal implementação tem a vantagem de ser mais rápida
    -- (i.e., menor atraso de propagação) do que um subtrator seguido do cálculo
    -- do valor absoluto.
end architecture structure;