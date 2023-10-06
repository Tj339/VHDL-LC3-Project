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
-------------------------------------------------------------------------------
--Don't Have AND, NOT & THE REST yet
-------------------------------------------------------------------------------

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
						next_state <= LOAD6;
				end case;

-------------------------------------------------------------------------------
--Don't Have S3A, S4 yet
-------------------------------------------------------------------------------

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


			


