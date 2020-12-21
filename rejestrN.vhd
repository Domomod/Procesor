LIBRARY ieee;  
USE ieee.std_logic_1164.all;  

entity rejestrN is
	GENERIC(
		N : integer := 16
	);
	PORT(
		R : in std_logic_vector(n-1 downto 0);
		Rin : in std_logic;
		Reset: in std_logic;
		CLK : in std_logic;
		Q : buffer std_logic_vector(n-1 downto 0)
	);
end rejestrN;

architecture behav of rejestrN is
begin
	process(CLK)
	begin
		if (CLK'event and CLK ='1') then
			if (Rin = '1') then
				Q<=R;
			elsif (Reset = '1') then
				Q<=(others => '0');
			end if;
		end if;
	end process;
end behav;