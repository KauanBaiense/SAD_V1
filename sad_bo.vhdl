kauãn
kauanbr__
Invisível



Canal de texto
Macacos falativos:vhdl
Buscar

Chat do canal vhdl
Bem-vindo(a) a #vhdl!
Este é o começo do canal #vhdl.

Editar canal
31 de março de 2025

kauãn — 31/03/2025 20:29

2 de abril de 2025

kauãn — 02/04/2025 00:06

[00:07]


kauãn — 02/04/2025 22:07
https://github.com/ghdl/ghdl/blob/master/libraries/ieee/numeric_std.vhdl
GitHub
ghdl/libraries/ieee/numeric_std.vhdl at master · ghdl/ghdl
VHDL 2008/93/87 simulator. Contribute to ghdl/ghdl development by creating an account on GitHub.

4 de abril de 2025

Zeppa fiufiu Grêmio — 04/04/2025 15:19

croc.vhd
602 bytes

croc_tb.vhd
1.04 KB
[15:19]
depois tem que dar uma mudada nos nomes dos arquivos e em alguns bagulho
[15:20]
mandei o testbench caso alguem quiser, até porque tem que modificar algumas coisas pro codigo funcionar como ele quer
7 de abril de 2025

kauãn — 07/04/2025 14:13


kauãn — 07/04/2025 15:00

croc_tb.vhd
1.12 KB
[15:01]

croc.vhd
727 bytes
13 de maio de 2025

kauãn — 13/05/2025 13:46
clock_process: process
      begin
          for i in 0 to 35 loop
              cloqui <= '0';
              wait for ClockPeriod / 2;
              cloqui <= '1';
              wait for ClockPeriod / 2;
          end loop;
          wait;
      end process;
[13:48]
constant ClockPeriod  : time    := 20 ns;
20 de maio de 2025

kauãn — 20/05/2025 11:07

[11:07]

23 de maio de 2025

kauãn — 23/05/2025 10:53
--------------------------------------------------
--Author:      Ismael Seidel (entity)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade `sad_bc`, que representa o
Expandir
sad_bc.vhdl
4 KB
--------------------------------------------------
--Author:      Ismael Seidel (entidade)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade `sad_bo`, que representa o
Expandir
sad_bo.vhdl
7 KB
[10:53]
--------------------------------------------------
--Author:      Ismael Seidel (entity)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade sad (que é o top-level). Tal
Expandir
sad.vhdl
5 KB

kauãn — 23/05/2025 11:07
ghdl -a --std=08 unsigned_adder.vhdl

ghdl -a --std=08 unsigned_register.vhdl

ghdl -a --std=08 mux_2to1.vhdl

ghdl -a --std=08 absolute_difference.vhdl

ghdl -a --std=08 sad_pack.vhdl

ghdl -a --std=08 pacoteBC.vhdl

ghdl -a --std=08 sad_bc.vhdl

ghdl -a --std=08 sad_bo.vhdl (editado)

kauãn — 23/05/2025 11:22

[11:24]
https://www.pexels.com/pt-br/foto/foto-marrom-e-verde-de-mountain-view-842711/

kauãn — 23/05/2025 11:38
library ieee;
use ieee.std_logic_1164.all;

package tsinais is
  type sinais_t is record 
    ci    : std_logic;
Expandir
pacoteBC.vhdl
1 KB
28 de maio de 2025

kauãn — 18:51
--------------------------------------------------
--Author:      Ismael Seidel (entity)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade sad (que é o top-level). Tal
Expandir
sad.vhdl
6 KB
--------------------------------------------------
--Author:      Ismael Seidel (entity)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade `sad_bc`, que representa o
Expandir
sad_bc.vhdl
5 KB
--------------------------------------------------
--Author:      Ismael Seidel (entidade)
--Created:     May 1, 2025
--
--Project:     Exercício 6 de INE5406
--Description: Contém a descrição da entidade `sad_bo`, que representa o
--               bloco operativo (BO) do circuito para cálculo da soma das
--               diferenças absolutas (SAD - Sum of Absolute Differences).
--               Este bloco implementa o *datapath* principal do circuito e
--               realiza operações como subtração, valor absoluto e acumulação
--               dos valores calculados. Além disso, também será feito aqui o
--               calculo de endereçamento e do sinal de controle do laço de
--               execução (menor), que deve ser enviado ao bloco de controle (i.e.,
--               menor será um sinal de status gerado no BO).
--               A parametrização é feita por meio do tipo
--               `datapath_configuration_t` definido no pacote `sad_pack`.
--               Os parâmetros incluem:
--               - `bits_per_sample`: número de bits por amostra; (uso obrigatório)
--               - `samples_per_block`: número total de amostras por bloco; (uso 
--                  opcional, útil para definição do número de bits da sad e 
--                  endereço, conforme feito no top-level, i.e., no arquivo sad.vhdl)
--               - `parallel_samples`: número de amostras processadas em paralelo.
--                  (uso opcional)
--               A arquitetura estrutural instanciará os componentes necessários
--               à implementação completa do bloco operativo.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sad_pack.all;



-- Bloco Operativo (BO) do circuito SAD.
-- Responsável pelo processamento aritmético dos dados de entrada, incluindo
-- subtração, cálculo de valor absoluto e soma acumulada.
-- Totalmente parametrizável por meio do tipo `datapath_configuration_t`.
entity sad_bo is
generic(
bits_per_sample   : positive := 8; -- número de bits por amostra
-----------------------------------------------------------------------
-- desejado (i.e., não obrigatório) ---
-- se você desejar, pode usar os valores abaixo para descrever uma
-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
samples_per_block : positive := 64; -- número de amostras por bloco
parallel_samples  : positive := 1 
);
port(
clk : in std_logic;
sample_ori, sample_can : in std_logic_vector(bits_per_sample * parallel_samples - 1 downto 0);
        address : out std_logic_vector(5 downto 0);
        sad : out std_logic_vector(6 + bits_per_sample -1 downto 0);
        menor : out std_logic;
        ci    : in std_logic;
        zi    : in std_logic;
        cpa   : in std_logic;
        cpb   : in std_logic;
        zsoma : in std_logic;
        csoma : in std_logic;
        csad  : in std_logic;
        cont : in integer;
        p : in integer
        --rst_a : in std_logic
-- não esqueça de colocar o ; no final da linha que declara o clk :)
);
end entity;
-- Não altere o nome da entidade! Como você quem irá instanciar, neste caso podes
-- mudar o nome da arquitetura, embora isso não seja necessário. 
-- A arquitetura será estrutural, composta por instâncias de componentes auxiliares.

architecture structure OF sad_bo is
    --ABS
    signal A,B,pa, pb, sab : unsigned(bits_per_sample * parallel_samples - 1 downto 0);
    signal muxs14 : std_logic_vector(6 + bits_per_sample -1 downto 0);
    signal soma, saad,k : unsigned(6 + bits_per_sample -1 downto 0);
    signal sab14 : unsigned(6 + bits_per_sample -1 downto 0);
    signal saisoma15 : unsigned(6 + bits_per_sample downto 0);
    --CONTADOR
    signal muxs7,i: std_logic_vector(6 downto 0);
    signal j: unsigned(6 downto 0);
    signal entSoma: unsigned(5 downto 0);
    signal next_j : unsigned(6 downto 0);
    signal saisoma : std_logic_vector(6 downto 0) := (others => '0');
begin
        --CONTADOR
        
        MUX7: entity work.mux_2to1(behavior)
generic map (N => 7)
port map (sel=> zi, in_0=>saisoma, in_1=> (others => '0'), y=> muxS7);


        CONTi : entity work.unsigned_register(behavior)
        generic map(N => 7)
    port map(clk => clk, enable => ci, d => unsigned(muxS7), q => next_j);
        
        SOMA7: entity work.unsigned_adder(arch)
        generic map(N => 6)
    port map(input_a => entSoma, input_b => to_unsigned(1, 6), sum => j);
        
... (60 linhas)
Recolher
sad_bo.vhdl
7 KB

kauãn
Clique para ver anexo

kauãn — 18:52
SAD, BC E BO


Conversar em #vhdl
﻿




para selecionar
Lista de membros para vhdl (canal)
ENGINE and ring, 1 membroENGINE and ring — 1

Zeppa fiufiu Grêmio
DJ, 1 membroDJ — 1

DJ CAESAR
APP
Ouvindo m!help
Offline, 5 membrosOffline — 5

DiSueco

gugaboing

kauãn

NoPants

Tab
;
--------------------------------------------------
--	Author:      Ismael Seidel (entidade)
--	Created:     May 1, 2025
--
--	Project:     Exercício 6 de INE5406
--	Description: Contém a descrição da entidade `sad_bo`, que representa o
--               bloco operativo (BO) do circuito para cálculo da soma das
--               diferenças absolutas (SAD - Sum of Absolute Differences).
--               Este bloco implementa o *datapath* principal do circuito e
--               realiza operações como subtração, valor absoluto e acumulação
--               dos valores calculados. Além disso, também será feito aqui o
--               calculo de endereçamento e do sinal de controle do laço de
--               execução (menor), que deve ser enviado ao bloco de controle (i.e.,
--               menor será um sinal de status gerado no BO).
--               A parametrização é feita por meio do tipo
--               `datapath_configuration_t` definido no pacote `sad_pack`.
--               Os parâmetros incluem:
--               - `bits_per_sample`: número de bits por amostra; (uso obrigatório)
--               - `samples_per_block`: número total de amostras por bloco; (uso 
--                  opcional, útil para definição do número de bits da sad e 
--                  endereço, conforme feito no top-level, i.e., no arquivo sad.vhdl)
--               - `parallel_samples`: número de amostras processadas em paralelo.
--                  (uso opcional)
--               A arquitetura estrutural instanciará os componentes necessários
--               à implementação completa do bloco operativo.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sad_pack.all;



-- Bloco Operativo (BO) do circuito SAD.
-- Responsável pelo processamento aritmético dos dados de entrada, incluindo
-- subtração, cálculo de valor absoluto e soma acumulada.
-- Totalmente parametrizável por meio do tipo `datapath_configuration_t`.
entity sad_bo is
	generic(
		bits_per_sample   : positive := 8; -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		samples_per_block : positive := 64; -- número de amostras por bloco
		parallel_samples  : positive := 1 
	);
	port(
		clk : in std_logic;
		sample_ori, sample_can : in std_logic_vector(bits_per_sample * parallel_samples - 1 downto 0);
        address : out std_logic_vector(5 downto 0);
        sad : out std_logic_vector(6 + bits_per_sample -1 downto 0);
        menor : out std_logic;
        ci    : in std_logic;
        zi    : in std_logic;
        cpa   : in std_logic;
        cpb   : in std_logic;
        zsoma : in std_logic;
        csoma : in std_logic;
        csad  : in std_logic;
        cont : in integer;
        p : in integer
        --rst_a : in std_logic
		-- não esqueça de colocar o ; no final da linha que declara o clk :)
	);
end entity;
-- Não altere o nome da entidade! Como você quem irá instanciar, neste caso podes
-- mudar o nome da arquitetura, embora isso não seja necessário. 
-- A arquitetura será estrutural, composta por instâncias de componentes auxiliares.

architecture structure OF sad_bo is
    --ABS
    signal A,B,pa, pb, sab : unsigned(bits_per_sample * parallel_samples - 1 downto 0);
    signal muxs14 : std_logic_vector(6 + bits_per_sample -1 downto 0);
    signal soma, saad,k : unsigned(6 + bits_per_sample -1 downto 0);
    signal sab14 : unsigned(6 + bits_per_sample -1 downto 0);
    signal saisoma15 : unsigned(6 + bits_per_sample downto 0);
    --CONTADOR
    signal muxs7,i: std_logic_vector(6 downto 0);
    signal j: unsigned(6 downto 0);
    signal entSoma: unsigned(5 downto 0);
    signal next_j : unsigned(6 downto 0);
    signal saisoma : std_logic_vector(6 downto 0) := (others => '0');
begin
        --CONTADOR
        
        MUX7: entity work.mux_2to1(behavior)
		generic map (N => 7)
		port map (sel=> zi, in_0=>saisoma, in_1=> (others => '0'), y=> muxS7);


        CONTi : entity work.unsigned_register(behavior)
        generic map(N => 7)
	    port map(clk => clk, enable => ci, d => unsigned(muxS7), q => next_j);
        
        SOMA7: entity work.unsigned_adder(arch)
        generic map(N => 6)
	    port map(input_a => entSoma, input_b => to_unsigned(1, 6), sum => j);
        
        saisoma <= std_logic_vector(j);
        i <= std_logic_vector(next_j);
        menor <= NOT(i(6));
        address <= i(5 downto 0);
        entSoma <= unsigned(address);


        --FIM CONTADOR
        -- variaveis inciais que tem que ser unsigned : A, PA, B, PB, PAB, 
        --PABLO, SOMA, (VARIAVEIS MUX NAO SAO STD_LOGIC_VECTOR)
        A <= unsigned(sample_ori);
        B <= unsigned(sample_can);

        PAA : entity work.unsigned_register(behavior)
        generic map(N => bits_per_sample)
        port map(clk => clk, enable => cpa, d => A, q => pa);

        PBB : entity work.unsigned_register(behavior)    
        generic map(N => bits_per_sample)
        port map(clk => clk, enable => cpb, d => B, q => pb);
        
        SUB : entity work.absolute_difference(structure)
        generic map(N => bits_per_sample)
        port map(input_a => pa, input_b => pb, abs_diff => sab);
        
        sab14 <= resize(sab, 6 + bits_per_sample);
        
        SOMA14: entity work.unsigned_adder(arch)--error
        generic map(N => 6 + bits_per_sample )
	    port map(input_a => sab14, input_b => soma, sum => saisoma15);

        k <= saisoma15(6 + bits_per_sample -1 downto 0);
        --muxu14 <= std_logic_vector(k);

        MUX14: entity work.mux_2to1(behavior)
		generic map (N => 6 + bits_per_sample)
		port map (sel => zsoma, in_0 => std_logic_vector(k), in_1 => (others => '0'), y => muxS14);

        SOMA_REG : entity work.unsigned_register(behavior)
        generic map(N => 6 + bits_per_sample)
        port map(clk => clk, enable => csoma, d => unsigned(muxS14), q => soma);

        SAD_REG : entity work.unsigned_register(behavior)
        generic map(N => 6 + bits_per_sample)
        port map(clk => clk, enable => csad, d => soma, q => saad);

        sad <= std_logic_vector(saad);
        
    -- A arquitetura deve instanciar módulos para formar o datapath do SAD.
    -- Isso inclui, por exemplo:
    --   - subtratores
    --   - módulos de valor absoluto
    --   - acumuladores
    --   - registradores
    
    -- DICA: Melhor ainda do que instanciar diretamente os componentes listados acima,
    -- minha recomendação é a divisão do bloco operativo em dois submódulos, um que
    -- ficará responsável por calcular os endereços, e o outro que ficará responsável
    -- por calcular o valor da SAD.
end architecture structure;
sad_bo.vhdl
7 KB
