LIBRARY ieee;  
USE ieee.std_logic_1164.all;

entity multiplekser is
	GENERIC(
		Rozmiar : integer := 16;
		LiczbaWejsc : integer := 10
	);
	PORT(
		MUX : in std_logic_vector(LiczbaWejsc - 1 downto 0);
		Wej : in std_logic_vector(LiczbaWejsc*Rozmiar - 1 downto 0);
		Q : out std_logic_vector(Rozmiar - 1 downto 0)
	);
end multiplekser;

architecture behav of multiplekser is 
	signal Wyj : std_logic_vector(Rozmiar -1 downto 0);
begin 
	process(MUX, Wej)
	begin
		Wyj <= (others => '0');
		for i in LiczbaWejsc - 1 downto 0 loop
			if MUX(i) = '1' then
				Wyj <= Wej((i+1) * Rozmiar -1 downto i * Rozmiar);
			end if;
		end loop;
	end process;
	Q <= Wyj;
end behav;