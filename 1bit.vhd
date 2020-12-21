library ieee;
use ieee.std_logic_1164.all;

entity sum1bit is
	port(
		a : in std_logic;
		b : in std_logic;
		c_in : in std_logic;
		Y : out std_logic;
		c_out : out std_logic
	);
end entity;

architecture arch of sum1bit is 

begin
	
	Y <= a xor b xor c_in;
	c_out <= (a and b) or ((a xor b) and c_in);

end arch;