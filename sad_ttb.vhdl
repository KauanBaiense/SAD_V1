--------------------------------------------------
-- Testbench para o circuito SAD
-- Autor: Ismael Seidel (adaptação)
-- Data: Junho 2025
-- Descrição: Testa o circuito SAD completo com 64 amostras de 8 bits
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.sad_pack.all;
use work.tsinais.all;

entity sad_ttb is
end entity sad_ttb;

architecture behavioral of sad_ttb is
    -- Constantes
    constant CLK_PERIOD : time := 10 ns;
    constant SAMPLES : integer := 64;
    constant BITS_PER_SAMPLE : integer := 8;
    
    -- Sinais do DUT (Device Under Test)
    signal clk : std_logic := '0';
    signal rst_a : std_logic := '0';
    signal enable : std_logic := '0';
    signal sample_ori : std_logic_vector(BITS_PER_SAMPLE-1 downto 0) := (others => '0');
    signal sample_can : std_logic_vector(BITS_PER_SAMPLE-1 downto 0) := (others => '0');
    signal read_mem : std_logic;
    signal address : std_logic_vector(5 downto 0);
    signal sad_value : std_logic_vector(13 downto 0);
    signal done : std_logic;
    
    -- Memórias de teste
    type mem_t is array (0 to SAMPLES-1) of std_logic_vector(BITS_PER_SAMPLE-1 downto 0);
    signal mem_a : mem_t;
    signal mem_b : mem_t;
    
    -- Sinais auxiliares
    signal sim_finished : boolean := false;
    signal expected_sad : unsigned(13 downto 0) := (others => '0');

begin
    -- Instanciação do DUT
    dut : entity work.sad
        generic map(
            bits_per_sample => BITS_PER_SAMPLE,
            samples_per_block => SAMPLES,
            parallel_samples => 1
        )
        port map(
            clk => clk,
            rst_a => rst_a,
            enable => enable,
            sample_ori => sample_ori,
            sample_can => sample_can,
            read_mem => read_mem,
            address => address,
            sad_value => sad_value,
            done => done
        );

    -- Geração de clock
    clk <= not clk after CLK_PERIOD/2 when not sim_finished else '0';

    -- Processo de teste
    test_process : process
        variable temp_sad : unsigned(13 downto 0) := (others => '0');
        variable diff : unsigned(BITS_PER_SAMPLE downto 0);
    begin
        -- Inicializa memórias com valores de teste
        for i in 0 to SAMPLES-1 loop
            -- Memória A: padrão alternado 0x55 e 0xAA
            if i mod 2 = 0 then
                mem_a(i) <= "01010101"; -- 0x55
            else
                mem_a(i) <= "10101010"; -- 0xAA
            end if;
            
            -- Memória B: padrão inverso ao da memória A
            if i mod 2 = 0 then
                mem_b(i) <= "10101010"; -- 0xAA
            else
                mem_b(i) <= "01010101"; -- 0x55
            end if;
            
            -- Calcula SAD esperada
            diff := unsigned('0' & mem_a(i)) - unsigned('0' & mem_b(i));
            if diff(BITS_PER_SAMPLE) = '1' then -- negativo
                diff := not diff(BITS_PER_SAMPLE-1 downto 0) + 1;
            end if;
            temp_sad := temp_sad + resize(diff, 14);
        end loop;
        expected_sad <= temp_sad;
        
        -- Reset inicial
        rst_a <= '1';
        wait for CLK_PERIOD * 2;
        rst_a <= '0';
        wait for CLK_PERIOD;
        
        -- Teste 1: Operação normal
        report "Iniciando teste 1: Operação normal";
        enable <= '1';
        wait until done = '1' for CLK_PERIOD * 200;
        
        -- Verifica resultado
        assert unsigned(sad_value) = expected_sad
            report "SAD calculada incorreta. Esperado: " & 
                   integer'image(to_integer(expected_sad)) & 
                   ", Obtido: " & integer'image(to_integer(unsigned(sad_value)))
            severity error;
        
        wait for CLK_PERIOD * 2;
        
        -- Teste 2: Reset durante operação
        report "Iniciando teste 2: Reset durante operação";
        enable <= '1';
        wait for CLK_PERIOD * 5;
        rst_a <= '1';
        wait for CLK_PERIOD;
        rst_a <= '0';
        wait until done = '1' for CLK_PERIOD * 200;
        
        -- Verifica resultado
        assert unsigned(sad_value) = expected_sad
            report "SAD após reset incorreta. Esperado: " & 
                   integer'image(to_integer(expected_sad)) & 
                   ", Obtido: " & integer'image(to_integer(unsigned(sad_value)))
            severity error;
        
        wait for CLK_PERIOD * 2;
        
        -- Teste 3: Dados aleatórios
        report "Iniciando teste 3: Dados aleatórios";
        temp_sad := (others => '0');
        
        -- Gera valores aleatórios
        for i in 0 to SAMPLES-1 loop
            mem_a(i) <= std_logic_vector(to_unsigned(i, BITS_PER_SAMPLE));
            mem_b(i) <= std_logic_vector(to_unsigned(SAMPLES-1-i, BITS_PER_SAMPLE));
            
            -- Calcula SAD esperada
            diff := unsigned('0' & mem_a(i)) - unsigned('0' & mem_b(i));
            if diff(BITS_PER_SAMPLE) = '1' then -- negativo
                diff := not diff(BITS_PER_SAMPLE-1 downto 0) + 1;
            end if;
            temp_sad := temp_sad + resize(diff, 14);
        end loop;
        expected_sad <= temp_sad;
        
        enable <= '1';
        wait until done = '1' for CLK_PERIOD * 200;
        
        -- Verifica resultado
        assert unsigned(sad_value) = expected_sad
            report "SAD com dados aleatórios incorreta. Esperado: " & 
                   integer'image(to_integer(expected_sad)) & 
                   ", Obtido: " & integer'image(to_integer(unsigned(sad_value)))
            severity error;
        
        -- Finaliza simulação
        sim_finished <= true;
        report "Simulação concluída com sucesso!";
        wait;
    end process test_process;

    -- Processo para fornecer dados das memórias
    mem_process : process(read_mem, address)
        variable addr : integer;
    begin
        if read_mem = '1' then
            addr := to_integer(unsigned(address));
            if addr < SAMPLES then
                sample_ori <= mem_a(addr);
                sample_can <= mem_b(addr);
            else
                sample_ori <= (others => '0');
                sample_can <= (others => '0');
            end if;
        else
            sample_ori <= (others => '0');
            sample_can <= (others => '0');
        end if;
    end process mem_process;

    -- Monitoramento do endereço
    monitor_process : process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' and read_mem = '1' then
                report "Lendo endereço: " & integer'image(to_integer(unsigned(address))) & 
                       " - MemA: " & integer'image(to_integer(unsigned(mem_a(to_integer(unsigned(address)))))) & 
                       ", MemB: " & integer'image(to_integer(unsigned(mem_b(to_integer(unsigned(address))))));
            end if;
        end if;
    end process monitor_process;

end architecture behavioral;