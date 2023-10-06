---------------------------------------------------------------
--TEMINIJESU OYEDELE COMPONENT FILE
---------------------------------------------------------------
---------------------------------------------------------------
--MAR COMPONENT
---------------------------------------------------------------
library ieee;
use work.all;
use ieee.std_logic_1164.all;

entity mar is
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (MW-1 downto 0)
	);
end mar;

architecture mar_reg of mar is

SIGNAL sQ : std_logic_vector (MW-1 downto 0);

begin

mar_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				sQ <= (others=>'Z');
			elsif(EN='1')then
				sQ <= OP_A(MW-1 downto 0);
			else
				sQ <= sQ;
			end if;
		end if;
	end process mar_clk;

OP_Q <= sQ;
		
end mar_reg;


---------------------------------------------------------------
--MDR COMPONENT
---------------------------------------------------------------
library ieee;
use work.all;
use ieee.std_logic_1164.all;

entity mdr is
	generic( P: INTEGER:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A1: in std_logic_vector (P-1 downto 0);
		OP_A2: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (P-1 downto 0)
	);
end mdr;

architecture mdr_reg of mdr is

SIGNAL sQ : std_logic_vector (P-1 downto 0);

begin

mdr_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				sQ <= (others=>'Z');
			elsif(EN='1')then
				sQ <= OP_A1;
			elsif(EN='0')then
				sQ <= OP_A2;
			else
				sQ <= sQ;
			end if;
		else
			sQ <= sQ;
		end if;
	end process mdr_clk;

OP_Q <= sQ;
		
end mdr_reg;


---------------------------------------------------------------
--RAM COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ram is
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9);
	port(
		CLK: in std_logic;
		MEM_EN: in std_logic;
		Read_Write_EN: in std_logic;
		MEM_WR_RD_ADD: in std_logic_vector (MW-1 downto 0);
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (P-1 downto 0)
	);
end ram;

architecture ram_arch of ram is

TYPE data_array IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL data: data_array(0 to (2**MW - 1)) := (
"0010000000010010", "0010001000010010", "0001111000000001",
"0101110000000001", "1001101111111111", "0011111000001001",
"0011101000001001", "0000000000000000", "0000000000000000",
"0000000000000000", "0000000000000000", "0000000000000000",
"0000000000000000", "0000000000000000", "0000000000000000",
"0000000000000000", "0000000000000000", "0000000000000000",
"0000000000000000", "0000000000000101", "0000000000000011", others => "0000000000000000");
SIGNAL sQ : std_logic_vector (P-1 downto 0);

begin

ram_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(MEM_EN='1')then
				if(Read_Write_EN='1')then
					data(to_integer(unsigned(MEM_WR_RD_ADD))) <= OP_A;
					sQ <= (others=>'Z');
				else
					sQ <= data(to_integer(unsigned(MEM_WR_RD_ADD)));
				end if;
			else
				sQ <= (others=>'Z');
			end if;
		else
			sQ <= sQ;
			data <= data;
		end if;
	end process ram_clk;

OP_Q <= sQ;
		
end ram_arch;



---------------------------------------------------------------
--GATE MDR COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity OYEDELE_gate_mdr is
	generic(P: integer:=16);
	port(
		EN: in std_logic;
		mdr_in: in std_logic_vector (P-1 downto 0);
		Gate_mdr_out: out std_logic_vector(P-1 downto 0)
	);
end OYEDELE_gate_mdr;


architecture gate_mdr_arch of OYEDELE_gate_mdr is

SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= mdr_in WHEN (EN = '1') ELSE
			(others => 'Z');
		Gate_mdr_out <= sQ;
		
end gate_mdr_arch;


---------------------------------------------------------------
--INSTRUCTION REGISTER COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg16 is
	generic(P: integer:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (P-1 downto 0)
	);
end reg16;

architecture register16 of reg16 is

SIGNAL sQ : std_logic_vector (P-1 downto 0);

begin

reg_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				sQ <= (others=>'0');
			elsif(EN='1')then
				sQ <= OP_A;
			else
				sQ <= sQ;
			end if;
		else
			sQ <= sQ;
		end if;
	end process reg_clk;

OP_Q <= sQ;
		
end register16;


---------------------------------------------------------------
--SIGN EXTENDER 5TO16 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sext5 is
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (4 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end sext5;


architecture sext5to16 of sext5 is

SIGNAL sONES : STD_LOGIC_VECTOR(P-6 DOWNTO 0) := (OTHERS => '1');
SIGNAL sZEROS : STD_LOGIC_VECTOR(P-6 DOWNTO 0) := (OTHERS => '0');
SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= sONES(P-6 DOWNTO 0) & OP_A(4 DOWNTO 0) WHEN OP_A(4) = '1' ELSE
			sZEROS(P-6 DOWNTO 0) & OP_A(4 DOWNTO 0);
		OP_Q <= sQ;
		
end sext5to16;


---------------------------------------------------------------
--SIGN EXTENDER 6TO16 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sext6 is
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (5 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end sext6;


architecture sext6to16 of sext6 is

SIGNAL sONES : STD_LOGIC_VECTOR(P-7 DOWNTO 0) := (OTHERS => '1');
SIGNAL sZEROS : STD_LOGIC_VECTOR(P-7 DOWNTO 0) := (OTHERS => '0');
SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= sONES(P-7 DOWNTO 0) & OP_A(5 DOWNTO 0) WHEN OP_A(5) = '1' ELSE
			sZEROS(P-7 DOWNTO 0) & OP_A(5 DOWNTO 0);
		OP_Q <= sQ;
		
end sext6to16;


---------------------------------------------------------------
--SIGN EXTENDER 9TO16 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sext9 is
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (8 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end sext9;


architecture sext9to16 of sext9 is

SIGNAL sONES : STD_LOGIC_VECTOR(P-10 DOWNTO 0) := (OTHERS => '1');
SIGNAL sZEROS : STD_LOGIC_VECTOR(P-10 DOWNTO 0) := (OTHERS => '0');
SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= sONES(P-10 DOWNTO 0) & OP_A(8 DOWNTO 0) WHEN OP_A(8) = '1' ELSE
			sZEROS(P-10 DOWNTO 0) & OP_A(8 DOWNTO 0);
		OP_Q <= sQ;
		
end sext9to16;


---------------------------------------------------------------
--SIGN EXTENDER 11TO16 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sext11 is
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (10 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end sext11;


architecture sext11to16 of sext11 is

SIGNAL sONES : STD_LOGIC_VECTOR(P-12 DOWNTO 0) := (OTHERS => '1');
SIGNAL sZEROS : STD_LOGIC_VECTOR(P-12 DOWNTO 0) := (OTHERS => '0');
SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= sONES(P-12 DOWNTO 0) & OP_A(10 DOWNTO 0) WHEN OP_A(10) = '1' ELSE
			sZEROS(P-12 DOWNTO 0) & OP_A(10 DOWNTO 0);
		OP_Q <= sQ;
		
end sext11to16;



---------------------------------------------------------------
--ZERO EXTENDER 8TO16 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity zext8 is
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (7 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end zext8;


architecture zext8to16 of zext8 is

SIGNAL sZEROS : STD_LOGIC_VECTOR(P-9 DOWNTO 0) := (OTHERS => '0');
SIGNAL sQ : STD_LOGIC_VECTOR(P-1 DOWNTO 0);

begin
		sQ <= sZEROS(P-9 DOWNTO 0) & OP_A(7 DOWNTO 0); 
		OP_Q <= sQ;
		
end zext8to16;



---------------------------------------------------------------
--NZP COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity nzp is
	generic( P: INTEGER:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (2 downto 0)
	);
end nzp;

architecture nzp_reg of nzp is

SIGNAL sQ : std_logic_vector (2 downto 0);
SIGNAL sZEROS : std_logic_vector (P-1 downto 0) := (OTHERS => '0');

begin

nzp_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				sQ <= (others=>'0');
			elsif(EN='1')then
				if(OP_A(P-1)='1')then
					sQ <= "100";
				elsif(OP_A=sZEROS)then
					sQ <= "010";
				else
					sQ <= "001";
				end if;
			else
				sQ <= sQ;
			end if;
		else
			sQ <= sQ;
		end if;
	end process nzp_clk;

OP_Q <= sQ;
		
end nzp_reg;




---------------------------------------------------------------
--MUX 2TO1 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic;
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end mux2;


architecture mux2to1 of mux2 is
begin
	OP_Q <= OP_A when (OP_S='0') else
		OP_B;
end mux2to1;



---------------------------------------------------------------
--MUX 3TO1 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B,OP_C: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end mux3;


architecture mux3to1 of mux3 is
begin
	OP_Q <= OP_A when (OP_S="00") else
		OP_B when (OP_S="01") else
		OP_C;
end mux3to1;



---------------------------------------------------------------
--MUX 4TO1 COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B,OP_C: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end mux4;


architecture mux4to1 of mux4 is

SIGNAL sZEROS : std_logic_vector (P-1 downto 0) := (OTHERS => '0');

begin
	OP_Q <= OP_A when (OP_S="00") else
		OP_B when (OP_S="01") else
		OP_C when (OP_S="10") else
		sZEROS;
end mux4to1;



---------------------------------------------------------------
--ADDER COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ADDER is
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end ADDER;


architecture COMB_ADDER of ADDER is

SIGNAL sQ: std_logic_vector (P-1 downto 0);

begin
	sQ <= OP_A + OP_B;
	OP_Q <= sQ;
end COMB_ADDER;



---------------------------------------------------------------
--ALU COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ALU is
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end ALU;


architecture ASAN of ALU is

SIGNAL sQ: std_logic_vector (P-1 downto 0);

begin
	sQ <= (OP_A + OP_B) when (OP_S = "00") else
		(OP_B - OP_A) when (OP_S = "01") else
		OP_A and OP_B when (OP_S = "10") else
		not OP_A;
	OP_Q <= sQ;
end ASAN;



---------------------------------------------------------------
--PC COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pc_counter is
	generic( P: INTEGER:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q1: out std_logic_vector (P-1 downto 0);
		OP_Q2: out std_logic_vector (P-1 downto 0)
	);
end pc_counter;

architecture program_counter_arch of pc_counter is

SIGNAL sQ1 : std_logic_vector (P-1 downto 0);
SIGNAL sQ2 : std_logic_vector (P-1 downto 0) := (others=>'0');

begin

count_clk: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				sQ1 <= (others=>'0');
				sQ2 <= "0000000000000001";
			elsif(EN='1')then
				sQ1 <= OP_A;
				sQ2 <= sQ2 + '1';
			else
				sQ1 <= sQ1;
				sQ2 <= sQ2;
			end if;
		else
			sQ1 <= sQ1;
			sQ2 <= sQ2;
		end if;
	end process count_clk;

OP_Q1 <= sQ1;
OP_Q2 <= sQ2;
		
end program_counter_arch;



---------------------------------------------------------------
--REG FILE COMPONENT
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_array is
	generic( P: INTEGER:=16;
		   E: natural:=8 );
	port(
		CLK: in std_logic;
		RST: in std_logic;
		LD_REG: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		DR: in std_logic_vector (2 downto 0);
		SR1: in std_logic_vector (2 downto 0);
		SR2: in std_logic_vector (2 downto 0);
		OP_Q1: out std_logic_vector (P-1 downto 0);
		OP_Q2: out std_logic_vector (P-1 downto 0)
	);
end register_array;

architecture reg_array of register_array is

TYPE regary IS ARRAY(E-1 DOWNTO 0) OF STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL sEN : std_logic_vector (E-1 downto 0);
SIGNAL sFF: regary;

component reg16
	generic(P: integer:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (P-1 downto 0)
	);
end component;

begin

p0: process(DR, LD_REG)

	begin

		sEN <= (sEN'range=>'0');
		sEN(to_integer(unsigned(DR))) <= LD_REG;
	end process;

g0: FOR j IN 0 TO (E-1) GENERATE
	regho: reg16
		generic map(P) port map (CLK,sEN(j),RST,OP_A,sFF(j));
	
end generate;

OP_Q1 <= sFF(to_integer(unsigned(SR1)));
OP_Q2 <= sFF(to_integer(unsigned(SR2)));
		
end reg_array;

---------------------------------------------------------------
--FSM COMPONENT
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity LC3_FSM is
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9;
		   E: natural:=8);
	port(
		CLK: in std_logic;
		RST: in std_logic;
		INSTRUCT_REG_OUT: in std_logic_vector (P-1 downto 0);
		NZP_OUT: in std_logic_vector (2 downto 0);
		REG16_EN: out std_logic;
		MARMUX_SEL: out std_logic;
		REG_ARRAY_EN: out std_logic;
		PC_EN: out std_logic;
		MAR_EN: out std_logic;
		MDR_EN: out std_logic;
		NZP_EN: out std_logic;
		RD_WRT_EN: out std_logic;
		GATE_PC: out std_logic;
		GATE_MARMUX: out std_logic;
		GATE_ALU: out std_logic;
		GATE_MDR: out std_logic;
		ADDR2MUX_SEL: out std_logic_vector (1 downto 0);
		ADDR1MUX_SEL: out std_logic;
		REG_ARRAY_SR1: out std_logic_vector (2 downto 0);
		REG_ARRAY_SR2: out std_logic_vector (2 downto 0);
		REG_ARRAY_DR: out std_logic_vector (2 downto 0);
		SR2MUX_SEL: out std_logic;
		PCMUX_SEL: out std_logic_vector (1 downto 0);
		ALU_SEL: out std_logic_vector (1 downto 0);
		MEM_EN: out std_logic
	);
end LC3_FSM;

architecture BEH of LC3_FSM is

type LC3_STATE_TYPE is (S0,S1,S2A,S2B,S2C,S2D,S2E,S3,ADD_AND_NOT,LOAD1,LOAD2,LOAD3,LOAD4,STORE1,STORE2,STORE3,LOOP_TO_S1);

signal cpu_state :LC3_STATE_TYPE;
signal next_state :LC3_STATE_TYPE;

constant ADD :std_logic_vector(3 downto 0) := "0001";
constant ANDL :std_logic_vector(3 downto 0) := "0101";
constant BR :std_logic_vector(3 downto 0) := "0000";
constant JMP :std_logic_vector(3 downto 0) := "1100";
constant JSR :std_logic_vector(3 downto 0) := "0100";
constant LD :std_logic_vector(3 downto 0) := "0010";
constant LDI :std_logic_vector(3 downto 0) := "1010";
constant LDR :std_logic_vector(3 downto 0) := "0110";
constant LEA :std_logic_vector(3 downto 0) := "1110";
constant NOTL :std_logic_vector(3 downto 0) := "1001";
constant RTI :std_logic_vector(3 downto 0) := "1000";
constant ST :std_logic_vector(3 downto 0) := "0011";
constant STI :std_logic_vector(3 downto 0) := "1011";
constant STR :std_logic_vector(3 downto 0) := "0111";
constant TRAP :std_logic_vector(3 downto 0) := "1111";

begin

nextstatelogic: process(CLK)

	begin

		if(CLK='1' and CLK 'event)then

			if(RST='1')then
				cpu_state <= S0;
			else
				cpu_state <= next_state;
			end if;
		end if;
	end process nextstatelogic;

FSM: process(INSTRUCT_REG_OUT,NZP_OUT,cpu_state,next_state)

variable TRAPVECTOR :std_logic_vector(7 downto 0);
variable OPCODE :std_logic_vector(3 downto 0);
variable PC_OFFSET :std_logic_vector(10 downto 0);
variable SR1IN :std_logic_vector(2 downto 0);
variable SR2IN :std_logic_vector(2 downto 0);
variable DRIN :std_logic_vector(2 downto 0);
variable IR_5 :std_logic;
variable IMMEDIATE :std_logic_vector(4 downto 0);
variable BASEREG :std_logic_vector(2 downto 0);

	begin
		case cpu_state is
			when S0=>
				REG16_EN <= '0';
				MARMUX_SEL <= '0';
				REG_ARRAY_EN <= '0';
				PC_EN <= '0';
				MAR_EN <= '0';
				MDR_EN <= '0';
				NZP_EN <= '0';
				RD_WRT_EN <= '0';
				GATE_PC <= '0';
				GATE_MARMUX <= '0';
				GATE_ALU <= '0';
				GATE_MDR <= '0';
				ADDR2MUX_SEL <= (others=>'0');
				ADDR1MUX_SEL <= '0';
				REG_ARRAY_SR1 <= (others=>'0');
				REG_ARRAY_SR2 <= (others=>'0');
				REG_ARRAY_DR <= (others=>'0');
				SR2MUX_SEL <= '0';
				PCMUX_SEL <= (others=>'0');
				ALU_SEL <= (others=>'0');
				MEM_EN <= '0';
				next_state <= S1;
	
			when S1=>
				GATE_MARMUX <= '0';
				GATE_ALU <= '0';
				GATE_MDR <= '0';
				NZP_EN <= '0';
				PC_EN <= '0';
				MAR_EN <= '1';
				GATE_PC <= '1';
				--PCMUX_SEL <= "00";
				MEM_EN <= '0';
				MDR_EN <= '0';
				next_state <= S2A;

			when S2A=>
				next_state <= S2B;

			when S2B=>
				MEM_EN <= '1';
				GATE_PC <= '0';
				MAR_EN <= '0';
				RD_WRT_EN <= '0';
				next_state <= S2C;

			when S2C=>
				MEM_EN <= '0';
				MDR_EN <= '1';
				next_state <= S2D;


			when S2D=>
				--MDR_EN <= '0';
				GATE_MDR <= '1';
				REG16_EN <= '1';
				NZP_EN <= '1';
				next_state <= S2E;
	
			when S2E=>
				GATE_MDR <= '0';
				REG16_EN <= '0';
				NZP_EN <= '0';
				next_state <= S3;

			when S3=>
				OPCODE := INSTRUCT_REG_OUT(15 downto 12);
				IR_5 := INSTRUCT_REG_OUT(5);
				DRIN := INSTRUCT_REG_OUT(11 downto 9);
				SR1IN := INSTRUCT_REG_OUT(8 downto 6);
				SR2IN := INSTRUCT_REG_OUT(2 downto 0);
				IMMEDIATE := INSTRUCT_REG_OUT(4 downto 0);
				BASEREG := INSTRUCT_REG_OUT(8 downto 6);
				PC_OFFSET := INSTRUCT_REG_OUT(10 downto 0);

				case OPCODE is
					when ADD=>
						if(IR_5 <= '0') then
							REG16_EN <= '0';
							REG_ARRAY_EN <='1';
							NZP_EN <= '1';
							GATE_MDR <= '0';
							GATE_ALU <= '1';
							REG_ARRAY_SR1 <= SR1IN;
							REG_ARRAY_SR2 <= SR2IN;
							REG_ARRAY_DR <= DRIN;
							SR2MUX_SEL <= '1';
							ALU_SEL <= "00";
							next_State <= ADD_AND_NOT;
						else
							REG16_EN <= '0';
							REG_ARRAY_EN <='1';
							NZP_EN <= '1';
							GATE_MDR <= '0';
							GATE_ALU <= '1';
							REG_ARRAY_SR1 <= SR1IN;
							REG_ARRAY_DR <= DRIN;
							SR2MUX_SEL <= '0';
							ALU_SEL <= "00";
							next_State <= ADD_AND_NOT;
						end if;

					when ANDL=>
						if(IR_5 <= '0') then
							REG16_EN <= '0';
							REG_ARRAY_EN <='1';
							NZP_EN <= '1';
							GATE_MDR <= '0';
							GATE_ALU <= '1';
							REG_ARRAY_SR1 <= SR1IN;
							REG_ARRAY_SR2 <= SR2IN;
							REG_ARRAY_DR <= DRIN;
							SR2MUX_SEL <= '1';
							ALU_SEL <= "10";
							next_State <= ADD_AND_NOT;
						else
							REG16_EN <= '0';
							REG_ARRAY_EN <='1';
							NZP_EN <= '1';
							GATE_MDR <= '0';
							GATE_ALU <= '1';
							REG_ARRAY_SR1 <= SR1IN;
							REG_ARRAY_DR <= DRIN;
							SR2MUX_SEL <= '0';
							ALU_SEL <= "10";
							next_State <= ADD_AND_NOT;
						end if;

					when NOTL=>
						REG16_EN <= '0';
						REG_ARRAY_EN <='1';
						NZP_EN <= '1';
						GATE_MDR <= '0';
						GATE_ALU <= '1';
						REG_ARRAY_SR1 <= SR1IN;
						REG_ARRAY_DR <= DRIN;
						ALU_SEL <= "11";
						next_State <= ADD_AND_NOT;

					when LD=>
						REG16_EN <= '0';
						NZP_EN <= '0';
						PC_EN <= '0';
						GATE_MDR <= '0';
						GATE_ALU <= '0';
						GATE_PC <= '0';
						ADDR1MUX_SEL <= '1';
						ADDR2MUX_SEL <= "01";
						MARMUX_SEL <= '1';
						GATE_MARMUX <= '1';
						MAR_EN <= '1';
						MEM_EN <= '0';
						RD_WRT_EN <= '0';
						MDR_EN <= '0';
						next_state <= LOAD1;

					when ST=>
						REG16_EN <= '0';
						NZP_EN <= '0';
						PC_EN <= '0';
						GATE_MDR <= '0';
						GATE_ALU <= '0';
						GATE_PC <= '0';
						REG_ARRAY_SR1 <= DRIN;
						ADDR1MUX_SEL <= '1';
						ADDR2MUX_SEL <= "01";
						MARMUX_SEL <= '1';
						GATE_MARMUX <= '1';
						MAR_EN <= '1';
						MEM_EN <= '0';
						RD_WRT_EN <= '0';
						MDR_EN <= '0';
						next_state <= STORE1;

					when others=>
						next_state <= LOOP_TO_S1;
				end case;

			when ADD_AND_NOT=>
				REG_ARRAY_EN <='0';
				next_state <= LOOP_TO_S1;

			when LOAD1=>
				next_state <= LOAD2;

			when LOAD2=>
				MAR_EN <= '0';
				GATE_MARMUX <= '0';
				MEM_EN <= '1';
				RD_WRT_EN <= '0';
				next_state <= LOAD3;

			when LOAD3=>
				MEM_EN <= '0';
				MDR_EN <= '1';
				next_state <= LOAD4;


			when LOAD4=>
				--MDR_EN <= '0';
				GATE_MDR <= '1';
				REG_ARRAY_EN <= '1';
				REG_ARRAY_DR <= DRIN;
				next_state <= LOOP_TO_S1;

			when STORE1=>
				ADDR1MUX_SEL <= '0';
				ADDR2MUX_SEL <= "11";
				MARMUX_SEL <= '1';
				GATE_MARMUX <= '1';
				MDR_EN <= '0';
				MAR_EN <= '0';
				next_state <= STORE2;

			when STORE2=>
				MAR_EN <= '0';
				MEM_EN <= '1';
				RD_WRT_EN <= '1';
				next_state <= STORE3;

			when STORE3=>
				MEM_EN <= '0';
				RD_WRT_EN <= '0';
				next_state <= LOOP_TO_S1;

			when LOOP_TO_S1=>
				GATE_MDR <= '0';
				REG_ARRAY_EN <= '0';
				REG_ARRAY_DR <= (others=>'0');
				PCMUX_SEL <= "10";
				PC_EN <= '1';
				next_state <= S1;

		end case;

	end process FSM;
end BEH;


			



		
		
		
		
		