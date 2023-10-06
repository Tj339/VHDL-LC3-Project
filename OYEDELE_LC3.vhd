library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity LC3 is
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9;
		   E: natural:=8);
	port(
		CLK: in std_logic;
		RST: in std_logic
	);
end LC3;

architecture STRUCTURAL of LC3 is



component mar
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (MW-1 downto 0)
	);
end component;

component mdr
	generic(P: integer:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A1: in std_logic_vector (P-1 downto 0);
		OP_A2: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (P-1 downto 0)
	);
end component;

component ram
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
end component;

component OYEDELE_gate_mdr
	generic(P: integer:=16);
	port(
		EN: in std_logic;
		mdr_in: in std_logic_vector (P-1 downto 0);
		Gate_mdr_out: out std_logic_vector (P-1 downto 0)
	);
end component;

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

component sext5
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (4 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component sext6
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (5 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component sext9
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (8 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component sext11
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (10 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component zext8
	generic( P: INTEGER:=16);
	port(
		OP_A: in std_logic_vector (7 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component nzp
	generic( P: INTEGER:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector (2 downto 0)
	);
end component;

component mux2
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic;
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component mux3
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B,OP_C: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;


component mux4
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B,OP_C: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component ADDER
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component ALU
	generic( P: INTEGER:=16);
	port(
		OP_A,OP_B: in std_logic_vector (P-1 downto 0);
		OP_S: in std_logic_vector (1 downto 0);
		OP_Q: out std_logic_vector(P-1 downto 0)
	);
end component;

component pc_counter
	generic( P: INTEGER:=16);
	port(
		CLK: in std_logic;
		EN: in std_logic;
		RST: in std_logic;
		OP_A: in std_logic_vector (P-1 downto 0);
		OP_Q1: out std_logic_vector (P-1 downto 0);
		OP_Q2: out std_logic_vector (P-1 downto 0)
	);
end component;

component register_array
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
end component;

component LC3_FSM
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
end component;

SIGNAL MAR_EN : std_logic;
SIGNAL MDR_EN : std_logic;
SIGNAL MEM_EN : std_logic;
SIGNAL RD_WRT_EN : std_logic;
SIGNAL GATE_MDR : std_logic;
SIGNAL GATE_MARMUX : std_logic;
SIGNAL GATE_PC : std_logic;
SIGNAL GATE_ALU : std_logic;
SIGNAL REG16_EN : std_logic;
SIGNAL NZP_EN : std_logic;
SIGNAL PC_EN : std_logic;
SIGNAL REG_ARRAY_EN : std_logic;
SIGNAL ADDR1MUX_SEL : std_logic;
SIGNAL MARMUX_SEL : std_logic;
SIGNAL SR2MUX_SEL : std_logic;
SIGNAL ADDR2MUX_SEL : std_logic_vector (1 downto 0);
SIGNAL PCMUX_SEL : std_logic_vector (1 downto 0);
SIGNAL ALU_SEL : std_logic_vector (1 downto 0);
SIGNAL REG_ARRAY_DR : std_logic_vector (2 downto 0);
SIGNAL REG_ARRAY_SR1 : std_logic_vector (2 downto 0);
SIGNAL REG_ARRAY_SR2 : std_logic_vector (2 downto 0);



SIGNAL S_NZP_OUT : std_logic_vector (2 downto 0);
SIGNAL S_MAR_OUT : std_logic_vector (MW-1 downto 0);
SIGNAL S_MDR_OUT: std_logic_vector (P-1 downto 0);
SIGNAL S_MARMUX_OUT: std_logic_vector (P-1 downto 0);
SIGNAL S_PC_OUT: std_logic_vector (P-1 downto 0);
SIGNAL S_ALU_OUT: std_logic_vector (P-1 downto 0);
SIGNAL S_MEM_OUT: std_logic_vector (P-1 downto 0);
SIGNAL S_Gate_BUS: std_logic_vector (P-1 downto 0);
SIGNAL S_REG16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_SEXT5TO16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_SEXT6TO16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_SEXT9TO16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_SEXT11TO16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_ZEXT8TO16_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_ADDR2MUX_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_ADDR1MUX_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_ADDER_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_PCMUX_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_PC_PLUS_OUT : std_logic_vector (P-1 downto 0);
SIGNAL S_REG_FILE_OUT1 : std_logic_vector (P-1 downto 0);
SIGNAL S_REG_FILE_OUT2 : std_logic_vector (P-1 downto 0);
SIGNAL S_SR2MUX_OUT : std_logic_vector (P-1 downto 0);

begin

	Inst1_mar: mar generic map(P,MW) port map(CLK,MAR_EN,RST,S_Gate_BUS,S_MAR_OUT);
	Inst2_ram: ram generic map(P,MW) port map(CLK,MEM_EN,RD_WRT_EN,S_MAR_OUT,S_MDR_OUT,S_MEM_OUT);
	Inst3_mdr: mdr generic map(P) port map(CLK,MDR_EN,RST,S_MEM_OUT,S_Gate_BUS,S_MDR_OUT);
	Inst4_gate_mdr: OYEDELE_gate_mdr generic map(P) port map(GATE_MDR,S_MDR_OUT,S_Gate_BUS);
	Inst5_instruction_reg: reg16 generic map(P) port map(CLK,REG16_EN,RST,S_Gate_BUS,S_REG16_OUT);
	Inst6_sext5: sext5 generic map(P) port map(S_REG16_OUT(4 downto 0),S_SEXT5TO16_OUT);
	Inst7_sext6: sext6 generic map(P) port map(S_REG16_OUT(5 downto 0),S_SEXT6TO16_OUT);
	Inst8_sext9: sext9 generic map(P) port map(S_REG16_OUT(8 downto 0),S_SEXT9TO16_OUT);
	Inst9_sext11: sext11 generic map(P) port map(S_REG16_OUT(10 downto 0),S_SEXT11TO16_OUT);
	Inst10_zext8: zext8 generic map(P) port map(S_REG16_OUT(7 downto 0),S_ZEXT8TO16_OUT);
	Inst11_addr2mux: mux4 generic map(P) port map(S_SEXT11TO16_OUT,S_SEXT9TO16_OUT,S_SEXT6TO16_OUT,ADDR2MUX_SEL,S_ADDR2MUX_OUT);
	Inst12_addr1mux: mux2 generic map(P) port map(S_REG_FILE_OUT1,S_PC_PLUS_OUT,ADDR1MUX_SEL,S_ADDR1MUX_OUT);
	Inst13_adder: ADDER generic map(P) port map(S_ADDR2MUX_OUT,S_ADDR1MUX_OUT,S_ADDER_OUT);
	Inst14_marmux: mux2 generic map(P) port map(S_ZEXT8TO16_OUT,S_ADDER_OUT,MARMUX_SEL,S_MARMUX_OUT);
	Inst15_gate_marmux: OYEDELE_gate_mdr generic map(P) port map(GATE_MARMUX,S_MARMUX_OUT,S_Gate_BUS);
	Inst16_pcmux: mux3 generic map(P) port map(S_Gate_BUS,S_ADDER_OUT,S_PC_PLUS_OUT,PCMUX_SEL,S_PCMUX_OUT);
	Inst17_pc: pc_counter generic map(P) port map(CLK,PC_EN,RST,S_PCMUX_OUT,S_PC_OUT,S_PC_PLUS_OUT);
	Inst18_gate_pc: OYEDELE_gate_mdr generic map(P) port map(GATE_PC,S_PC_OUT,S_Gate_BUS);
	Inst19_reg_file: register_array generic map(P,E) port map(CLK,RST,REG_ARRAY_EN,S_Gate_BUS,REG_ARRAY_DR,REG_ARRAY_SR1,REG_ARRAY_SR2,S_REG_FILE_OUT1,S_REG_FILE_OUT2);
	Inst20_sr2mux: mux2 generic map(P) port map(S_SEXT5TO16_OUT,S_REG_FILE_OUT2,SR2MUX_SEL,S_SR2MUX_OUT);
	Inst21_alu: ALU generic map(P) port map(S_REG_FILE_OUT1,S_SR2MUX_OUT,ALU_SEL,S_ALU_OUT);
	Inst22_gate_alu: OYEDELE_gate_mdr generic map(P) port map(GATE_ALU,S_ALU_OUT,S_Gate_BUS);
	Inst23_nzp: nzp generic map(P) port map(CLK,NZP_EN,RST,S_Gate_BUS,S_NZP_OUT);
	Inst24_fsm: LC3_FSM generic map(P) port map(CLK,RST,S_REG16_OUT,S_NZP_OUT,REG16_EN,MARMUX_SEL,REG_ARRAY_EN,PC_EN,MAR_EN,MDR_EN,NZP_EN,RD_WRT_EN,GATE_PC,GATE_MARMUX,GATE_ALU,GATE_MDR,ADDR2MUX_SEL,ADDR1MUX_SEL,REG_ARRAY_SR1,REG_ARRAY_SR2,REG_ARRAY_DR,SR2MUX_SEL,PCMUX_SEL,ALU_SEL,MEM_EN);


		
end STRUCTURAL;