-- Trzeba powiadomić Quartusa o używaniu biblioteczek
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library altera; 
use altera.altera_primitives_components.all;
	
-- Deklaruję układ, nazwa źle dobrana bo jest to zarówno sumator jak i przerzutniki DFF.
entity SumatorNbit is
	generic(
		N : integer
	);
	port(
		Ain: in std_logic_vector(N-1 downto 0);
		Bin: in std_logic_vector(N-1 downto 0);
		Cin: in std_logic;
		Y: out std_logic_vector(N-1 downto 0);
		Cout: out std_logic
	);
end entity;

-- Definuję strukturę układu sumatora 8 bitowego
architecture arch of SumatorNbit is
	-- Oznajmiam że będę korzystał z sum1bit			
	component sum1bit 
		port(
				a : in std_logic;
				b : in std_logic;
				c_in : in std_logic;
				Y : out std_logic;
				c_out : out std_logic
			);
	end component;
	
	-- Sygnały do połączenia carry out-ów między sumatorami
	signal c : std_logic_vector(N-2 downto 0);
	
	-- Rozpoczynam opis działania układu
	begin
		--Układ składa się z 8 sumatorów podłączonych szeregowo
		
		SumFirst : sum1bit PORT MAP (
			Ain(0),
			Bin(0),
			Cin,
			Y(0),
			c(0)
		);
		
		PosrednieSumatory: for ii in 1 to N-2 generate
			Sum : sum1bit PORT MAP (
				Ain(ii),
				Bin(ii),
				c(ii-1),
				Y(ii),
				c(ii)
			);
		end generate PosrednieSumatory;
		
		SumLast : sum1bit PORT MAP (
			Ain(N-1),
			Bin(N-1),
			c(N-2),
			Y(N-1),
			Cout
		);

end arch;