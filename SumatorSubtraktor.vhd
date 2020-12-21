library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity SumatorSubtraktorNbit is
	generic (
		Nbitow : integer :=16
	);
	port(
		A : in std_logic_vector(Nbitow - 1 downto 0);
		B : in std_logic_vector(Nbitow - 1 downto 0);
		AddSub : in std_logic;
		Overflow: out std_logic;
		Z : out std_logic_vector(Nbitow - 1 downto 0);
		CLK : in std_logic  
	);
end entity;

architecture arch of SumatorSubtraktorNbit is
	component sumatorNbit is
		generic (
			N : integer
		);
		port(
		Ain : in std_logic_vector(N - 1 downto 0);
		Bin : in std_logic_vector(N - 1 downto 0);
		Cin : in std_logic;
		Y : out std_logic_vector(N - 1 downto 0);
		Cout : out std_logic
		);
	end component;
	
	signal H, tempZ : std_logic_vector(Nbitow-1 downto 0);
	signal Cout : std_logic;
begin

			SUM : SumatorNbit 
			GENERIC MAP (
				Nbitow
			)	PORT MAP (
				A,
				H,
				AddSub,
				tempZ,
				Cout
		);

		WygenerujXOR: for ii in Nbitow - 1 downto 0 generate
			H(ii) <= B(ii) xor AddSub;
		end generate WygenerujXOR;
		
		Overflow <=  A(Nbitow -1) xor Cout xor H(Nbitow -1) xor tempZ(Nbitow -1);
		Z <= tempZ;
end arch;