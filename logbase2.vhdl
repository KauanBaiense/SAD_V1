library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sad_pack.all;


entity logbase2 is
	generic(
			bits_per_sample   : positive := 8; -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		samples_per_block : positive := 64; -- número de amostras por bloco
		parallel_samples  : positive := 1 
	);
    port ( 
        cont : out integer; -- contador de amostras
        P : out integer
    );
end entity;

architecture behavior of logbase2 is

begin
    process
        variable i     : integer := samples_per_block;
        variable count : integer := 0;
        begin 
        count := 0;
        while i /= 1 loop
            i := i / 2;
            count := count + 1;
        end loop;
        cont <= count;
        wait;
    end process;

    P <= cont +  (bits_per_sample * parallel_samples) - 1;
    
end architecture behavior;
