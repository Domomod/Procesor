LIBRARY ieee;  
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity licznikWGore is
	PORT(
		Clear : in std_logic;
		CLK : in std_logic;
		Count : in std_logic;
		Q : out std_logic_vector(1 downto 0 )
	);
end licznikWGore;

architecture behav of licznikWGore is
	signal licz : unsigned(1 downto 0);
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1'
		then
			if Clear = '1'
			then
				licz <= "00";
			elsif Count = '1' 
			then
				licz <= licz+1;
			end if;
		end if;
	end process;
	Q <= std_logic_vector(licz);
	
end behav;