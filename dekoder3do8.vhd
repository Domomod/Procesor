LIBRARY ieee;  
USE ieee.std_logic_1164.all;

entity dekoder3do8 is
	PORT(
		W : in std_logic_vector(2 downto 0);
		En : in std_logic;
		Y : out std_logic_vector(7 downto 0)
	);
end dekoder3do8;

architecture behav of dekoder3do8 is 
begin 
	process(W, En)
	begin
		if En = '1'
		then
			case W is
				when "000" => Y <= "10000000";
				when "001" => Y <= "01000000";
				when "010" => Y <= "00100000";
				when "011" => Y <= "00010000";
				when "100" => Y <= "00001000";
				when "101" => Y <= "00000100";
				when "110" => Y <= "00000010";
				when "111" => Y <= "00000001";
			end case;
		else
			Y <= "00000000";
		end if;
	end process;
end behav;