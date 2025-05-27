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
		CFG : datapath_configuration_t := (
			bits_per_sample   => 8,  -- número de bits por amostra
			samples_per_block => 64, -- número total de amostras por bloco
			parallel_samples  => 1   -- paralelismo no processamento
		)
	);
	port(
		clk : in std_logic;
		sample_ori, sample_can : in std_logic_vector(7 downto 0);
        address : out std_logic_vector(5 downto 0);
        sad : out std_logic_vector(13 downto 0);
        menor : out std_logic;
        ci    : in std_logic;
        zi    : in std_logic;
        cpa   : in std_logic;
        cpb   : in std_logic;
        zsoma : in std_logic;
        csoma : in std_logic;
        csad  : in std_logic
        --rst_a : in std_logic;
		-- não esqueça de colocar o ; no final da linha que declara o clk :)
	);
end entity;
-- Não altere o nome da entidade! Como você quem irá instanciar, neste caso podes
-- mudar o nome da arquitetura, embora isso não seja necessário. 
-- A arquitetura será estrutural, composta por instâncias de componentes auxiliares.

architecture structure OF sad_bo is
    signal A,B,pa, pb, sab : unsigned(7 downto 0);
    signal muxs14,muxu14 : std_logic_vector(13 downto 0);
    signal sab14,soma, saad : unsigned(13 downto 0);
    signal intsoma : unsigned(14 downto 0);
    signal muxs7,i: std_logic_vector(6 downto 0);
    signal muxu7,j: unsigned(6 downto 0);
    signal entSoma,songoku: unsigned(5 downto 0);
    signal overflow : std_logic;
    signal next_j : unsigned(6 downto 0);
    signal saisoma : std_logic_vector(6 downto 0) := (others => '0');
begin
        --CONTADOR
        
        MUX7: entity work.mux_2to1(behavior)
		generic map (N => 7)
		port map (sel=> zi, in_0=>saisoma, in_1=> "0000000", y=> muxS7);

        muxu7 <= unsigned(muxS7);

        CONTi : entity work.unsigned_register(behavior)
        generic map(N => 7)
	    port map(clk => clk, enable => ci, d => muxu7, q => next_j);
        
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
        generic map(N => 8)
        port map(clk => clk, enable => cpa, d => A, q => pa);

        PBB : entity work.unsigned_register(behavior)    
        generic map(N => 8)
        port map(clk => clk, enable => cpb, d => B, q => pb);

        SUB : entity work.absolute_difference(structure)
        generic map(N => 8)
        port map(input_a => pa, input_b => pb, abs_diff => sab);
        
        sab14 <= resize(sab, 14);

        SOMA14: entity work.unsigned_adder(arch)
        generic map(N => 14)
	    port map(input_a => sab14, input_b => soma, sum => intsoma);

        soma <= intsoma(13 downto 0);
        overflow <= intsoma(14);
        muxu14 <= std_logic_vector(soma);

        MUX14: entity work.mux_2to1(behavior)
		generic map (N => 14)
		port map (sel => zsoma, in_0 => muxu14, in_1 => (others => '0'), y => muxS14);


        SOMA_REG : entity work.unsigned_register(behavior)
        generic map(N => 14)
        port map(clk => clk, enable => csoma, d => unsigned(muxS14), q => soma);

        SAD_REG : entity work.unsigned_register(behavior)
        generic map(N => 14)
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