LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

entity procImplementacja is
	PORT(
		Din : in std_logic_vector(15 downto 0);
		ResetN : in std_logic;
		Run : in  std_logic;
		CLK : in std_logic;
		Done : buffer std_logic;
		BusWires : buffer std_logic_vector(15 downto 0);
		KrokPrzetwarzaniaOUT : out std_logic_vector (1 downto 0);
		Rmuxtest : out std_logic_vector(7 downto 0);
		IRwartosc : out std_logic_vector(7 downto 0)
	);
end procImplementacja;

architecture behav of procImplementacja is
--COMPONENTS--
component rejestrN is
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
end component;

component dekoder3do8 is
	PORT(
		W : in std_logic_vector(2 downto 0);
		En : in std_logic;
		Y : out std_logic_vector(7 downto 0)
	);
end component;

component licznikWGore is
	PORT(
		Clear : in std_logic;
		CLK : in std_logic;
		Count : in std_logic;
		Q : out std_logic_vector(1 downto 0 )
	);
end component;

component multiplekser is
	GENERIC(
		Rozmiar : integer := 16;
		LiczbaWejsc : integer := 10
	);
	PORT(
		MUX : in std_logic_vector(LiczbaWejsc - 1 downto 0);
		Wej : in std_logic_vector(LiczbaWejsc*Rozmiar - 1 downto 0);
		Q : out std_logic_vector(Rozmiar - 1 downto 0)
	);
end component;

component SumatorSubtraktorNbit is
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
end component;

--Signals--
signal ResetIR, LoadXreg, LoadYreg, Ain, AddSub, Gin, Gmux, Wysoki, Clear, Count, IRin, DinMux : std_logic;
signal X, Xreg, Y, Yreg, Rin, Rmux : std_logic_vector(7 downto 0);
signal KrokPrzetwarzania : std_logic_vector (1 downto 0);
signal IRout : std_logic_vector(7 downto 0);
signal Aout, SumOut, Gout, R0, R1, R2, R3, R4, R5, R6, R7  : std_logic_vector(15 downto 0);
signal I : std_logic;
signal TypInstrukcji : std_logic_vector(1 downto 0);

--Typy Instrukcji--
constant mv :std_logic_vector := "00";
constant mvi :std_logic_vector := "01";
constant add :std_logic_vector := "10";
constant sub :std_logic_vector := "11";


begin
	Wysoki <= '1';
	Clear <= Done or ResetN;
	ResetIR <= Done;
	
	TypInstrukcji <= IRout(1 downto 0);
	
	ukladKontroli : process(CLK, KrokPrzetwarzania, TypInstrukcji, X, Y)
	begin
	--Wartosci poczatkowe
	Done <= '0';
	Gmux <= '0';
	Dinmux <= '0';
	Rmux <= (others => '0');
	Rin <= (others => '0');
	Ain <= '0';
	AddSub <= '0';
	Gin <= '0';
	Count <= '0';
	IRin <= '0';
	
		
		case KrokPrzetwarzania is
			when "00" =>
				IRin <= '1';
				Count <= Run;
			when "01" =>
				case TypInstrukcji is
					when mv =>
						Rin <= X;
						Rmux <= Y;
						Done <= '1';
					when mvi =>
						Dinmux <= '1';
						Rin <= X;
						Done <= '1';
						
					-- w tym korku add i sub dzialaja tak samo
					when others =>
						Rmux <= X;
						Ain <= '1';
						Count <= '1';
				end case;
				--

			
			when "10" =>
				case TypInstrukcji is
					when add =>
						Rmux <= Y;
						Gin <= '1';
						Count <= '1';
					when sub =>
						Rmux <= Y;
						Gin <= '1';
						AddSub <= '1';
						Count <= '1';
					when others =>
						--nic
				end case;
				--
			when "11" =>
				case TypInstrukcji is
					when add | sub =>
						Gmux <= '1';
						Rin <= X;
						Done <= '1';
					when others =>
						--nic
				end case;
		end case;
	end process;
	
	--Multiplekser--
	multi : multiplekser
		PORT MAP(
			MUX => DinMux & Rmux & Gmux,
			Wej => Din & R7 & R6 & R5 & R4 & R3 & R2 & R1 & R0 & Gout, 
			Q => BusWires
		);
	--Układ sumujący--
	A : rejestrN
		PORT MAP(
			BusWires, Ain, '0', CLK, Aout
		);
	SumSub : SumatorSubtraktorNbit
		PORT MAP(
			A => Aout,
			B => BusWires,
			AddSub => AddSub,
			Overflow => open,
			Z => SumOut,
			CLK => CLK
		);
	G : rejestrN 
		PORT MAP(
			SumOut, Gin, '0', CLK, Gout
		);
	
	--Rejestr instrukcji--
	IR : rejestrN
		GENERIC MAP(
			8
		)
		PORT MAP(
			Din(10 downto 8) & Din(6 downto 4) & Din(1 downto 0), IRin, '0', CLK, IRout
		);
	
	--Licznik--
	licznik : licznikWGore 
		PORT MAP(
			Clear, CLK, Count, KrokPrzetwarzania
		);
	
	--Dekodery operandow X i Y--
	dekoderX : dekoder3do8
		PORT MAP(
			IRout(4 downto 2), Wysoki, X
		);
	dekoderY : dekoder3do8
		PORT MAP(
			IRout(7 downto 5), Wysoki, Y
		);
	
	--Pamiec procesora--
	reg_0 : rejestrN
		PORT MAP (
			BusWires, Rin(0), '0', CLK, R0
		);
	reg_1 : rejestrN
		PORT MAP (
			BusWires, Rin(1), '0', CLK, R1
		);
	reg_2 : rejestrN
		PORT MAP (
			BusWires, Rin(2), '0', CLK, R2
		);
	reg_3 : rejestrN
		PORT MAP (
			BusWires, Rin(3), '0', CLK, R3
		);
	reg_4 : rejestrN
		PORT MAP (
			BusWires, Rin(4), '0', CLK, R4
		);
	reg_5 : rejestrN
		PORT MAP (
			BusWires, Rin(5), '0', CLK, R5
		);
	reg_6 : rejestrN
		PORT MAP (
			BusWires, Rin(6), '0', CLK, R6
		);
	reg_7 : rejestrN
		PORT MAP (
			BusWires, Rin(7), '0', CLK, R7
		);
		
	KrokPrzetwarzaniaOUT <= KrokPrzetwarzania;
	Rmuxtest <= Rin;
	IRwartosc <= IRout;
end behav;