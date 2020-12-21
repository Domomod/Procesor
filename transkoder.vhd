LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY transkoder IS
	PORT (Wej: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Wyj: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END transkoder;

ARCHITECTURE strukturalna OF transkoder IS

--do uzupelnienia

BEGIN

	WITH Wej SELECT
		Wyj <= "1000000" WHEN "0000", --0
				 "1111001" WHEN "0001", --1
				 "0100100" WHEN "0010", --2
				 "0110000" WHEN "0011", --3
				 "0011001" WHEN "0100", --4
				 "0010010" WHEN "0101", --5
				 "0000010" WHEN "0110", --6
				 "1111000" WHEN "0111", --7
				 "0000000" WHEN "1000", --8		 
				 "0010000" WHEN "1001", --9
				 "0001000" WHEN "1010", --10 A
				 "0000011" WHEN "1011", --11 b
				 "1000110" WHEN "1100", --12 C
				 "0100001" WHEN "1101", --13 d
				 "0000110" WHEN "1110", --14 E
				 "0001110" WHEN "1111"; --15 F

END strukturalna;