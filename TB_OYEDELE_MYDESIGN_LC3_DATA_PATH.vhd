-- Copyright 2021 by Howard University All rights reserved.
--
-- Manual Testbench for: Listing 4.1
-- Design: Digital Systems (218)
-- Name: TEMINIJESU OYEDELE 
--	
-- Date: 04/08/2023
--
-- Description: Test Bench for Digital Design Classes
-- For Homework 7
-- Digital Design Lab/Lecture (218)
--------------------------------------------------------------

LIBRARY IEEE;
USE work.CLOCKS.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
USE std.textio.all;
USE work.txt_util.all;

ENTITY TB_DATA_PATH IS
END;

ARCHITECTURE TESTBENCH OF TB_DATA_PATH IS


---------------------------------------------------------------
-- COMPONENTS
---------------------------------------------------------------

COMPONENT DATA_PATH 			-- In/out Ports
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9;
		   E: natural:=8);
	port(
		CLK: in std_logic;
		RST: in std_logic;
		MAR_EN: in std_logic;
		MDR_EN: in std_logic;
		MEM_EN: in std_logic;
		RD_WRT_EN: in std_logic;
		GATE_MDR: in std_logic;
		GATE_MARMUX: in std_logic;
		GATE_PC: in std_logic;
		GATE_ALU: in std_logic;
		REG16_EN: in std_logic;
		NZP_EN: in std_logic;
		PC_EN: in std_logic;
		REG_ARRAY_EN: in std_logic;
		ADDR1MUX_SEL: in std_logic;
		MARMUX_SEL: in std_logic;
		SR2MUX_SEL: in std_logic;
		ADDR2MUX_SEL: in std_logic_vector (1 downto 0);
		PCMUX_SEL: in std_logic_vector (1 downto 0);
		ALU_SEL: in std_logic_vector (1 downto 0);
		REG_ARRAY_DR: in std_logic_vector (2 downto 0);
		REG_ARRAY_SR1: in std_logic_vector (2 downto 0);
		REG_ARRAY_SR2: in std_logic_vector (2 downto 0);
		BUS_IN: in std_logic_vector (P-1 downto 0);
		MDR_IN: in std_logic_vector (P-1 downto 0);
		INSTRUCT_REG_OUT: out std_logic_vector (P-1 downto 0);
		NZP_OUT: out std_logic_vector (2 downto 0)
	);
END COMPONENT;

COMPONENT CLOCK
	port(CLK: out std_logic);
END COMPONENT;

---------------------------------------------------------------
-- Read/Write FILES
---------------------------------------------------------------


FILE in_file : TEXT open read_mode is 	"OYEDELE_DATA_PATH_INPUT.txt";
FILE exo_file : TEXT open read_mode is 	"OYEDELE_DATA_PATH_EXP_OUTPUT.txt";
FILE out_file : TEXT open  write_mode is  "OYEDELE_DATA_PATH_dataout.txt";
FILE xout_file : TEXT open  write_mode is "OYEDELE_DATA_PATH_TestOut.txt";

---------------------------------------------------------------
-- SIGNALS 
---------------------------------------------------------------

  SIGNAL CLK: STD_LOGIC;
  SIGNAL RST: STD_LOGIC:= 'X';
  SIGNAL MAR_EN: STD_LOGIC:= 'X';
  SIGNAL MDR_EN: STD_LOGIC:= 'X';
  SIGNAL MEM_EN: STD_LOGIC:= 'X';
  SIGNAL RD_WRT_EN: STD_LOGIC:= 'X';
  SIGNAL GATE_MDR: STD_LOGIC:= 'X';
  SIGNAL GATE_MARMUX: STD_LOGIC:= 'X';
  SIGNAL GATE_PC: STD_LOGIC:= 'X';
  SIGNAL GATE_ALU: STD_LOGIC:= 'X';
  SIGNAL REG16_EN: STD_LOGIC:= 'X';
  SIGNAL NZP_EN: STD_LOGIC:= 'X';
  SIGNAL PC_EN: STD_LOGIC:= 'X';
  SIGNAL REG_ARRAY_EN: STD_LOGIC:= 'X';
  SIGNAL ADDR1MUX_SEL: STD_LOGIC:= 'X';
  SIGNAL MARMUX_SEL: STD_LOGIC:= 'X';
  SIGNAL SR2MUX_SEL: STD_LOGIC:= 'X';
  SIGNAL ADDR2MUX_SEL: STD_LOGIC_VECTOR (1 downto 0):= "XX";
  SIGNAL PCMUX_SEL: STD_LOGIC_VECTOR (1 downto 0):= "XX";
  SIGNAL ALU_SEL: STD_LOGIC_VECTOR (1 downto 0):= "XX";
  SIGNAL REG_ARRAY_DR: STD_LOGIC_VECTOR (2 downto 0):= "XXX";
  SIGNAL REG_ARRAY_SR1: STD_LOGIC_VECTOR (2 downto 0):= "XXX";
  SIGNAL REG_ARRAY_SR2: STD_LOGIC_VECTOR (2 downto 0):= "XXX";
  SIGNAL BUS_IN: STD_LOGIC_VECTOR (15 downto 0):= "XXXXXXXXXXXXXXXX";
  SIGNAL MDR_IN: STD_LOGIC_VECTOR (15 downto 0):= "XXXXXXXXXXXXXXXX";	
  SIGNAL INSTRUCT_REG_OUT: STD_LOGIC_VECTOR (15 downto 0):= "XXXXXXXXXXXXXXXX";
  SIGNAL NZP_OUT : STD_LOGIC_VECTOR (2 downto 0):= "XXX";
  SIGNAL Exp_INSTRUCT_REG_OUT : STD_LOGIC_VECTOR (15 downto 0):= "XXXXXXXXXXXXXXXX";
  SIGNAL Exp_NZP_OUT : STD_LOGIC_VECTOR (2 downto 0):= "XXX";
  SIGNAL Test_Out_Q : STD_LOGIC_VECTOR (15 downto 0):= "XXXXXXXXXXXXXXXX";
  SIGNAL LineNumber: integer:=0;

---------------------------------------------------------------
-- BEGIN 
---------------------------------------------------------------

BEGIN

---------------------------------------------------------------
-- Instantiate Components 
---------------------------------------------------------------


U0: CLOCK port map (CLK);
InstOYEDELE_MYDESIGN_DATA_PATH: DATA_PATH port map (CLK,RST,MAR_EN,MDR_EN,MEM_EN,RD_WRT_EN,GATE_MDR,GATE_MARMUX,GATE_PC,GATE_ALU,REG16_EN,NZP_EN,PC_EN,REG_ARRAY_EN,ADDR1MUX_SEL,MARMUX_SEL,SR2MUX_SEL,ADDR2MUX_SEL,PCMUX_SEL,ALU_SEL,REG_ARRAY_DR,REG_ARRAY_SR1,REG_ARRAY_SR2,BUS_IN,INSTRUCT_REG_OUT,NZP_OUT);

---------------------------------------------------------------
-- PROCESS 
---------------------------------------------------------------
PROCESS

variable in_line, exo_line, out_line, xout_line : LINE;
variable comment, xcomment : string(1 to 128);
variable i : integer range 1 to 128;
variable simcomplete : boolean;


variable vRST   : std_logic:= 'X';
variable vMAR_EN   : std_logic:= 'X';
variable vMDR_EN   : std_logic:= 'X';
variable vMEM_EN   : std_logic:= 'X';
variable vRD_WRT_EN   : std_logic:= 'X';
variable vGATE_MDR   : std_logic:= 'X';
variable vGATE_MARMUX   : std_logic:= 'X';
variable vGATE_PC   : std_logic:= 'X';
variable vGATE_ALU   : std_logic:= 'X';
variable vREG16_EN   : std_logic:= 'X';
variable vNZP_EN   : std_logic:= 'X';
variable vPC_EN   : std_logic:= 'X';
variable vREG_ARRAY_EN   : std_logic:= 'X';
variable vADDR1MUX_SEL   : std_logic:= 'X';
variable vMARMUX_SEL   : std_logic:= 'X';
variable vSR2MUX_SEL   : std_logic:= 'X';
variable vADDR2MUX_SEL   : std_logic_vector(1 downto 0):= (OTHERS => 'X');
variable vPCMUX_SEL   : std_logic_vector(1 downto 0):= (OTHERS => 'X');
variable vALU_SEL   : std_logic_vector(1 downto 0):= (OTHERS => 'X');
variable vREG_ARRAY_DR   : std_logic_vector(2 downto 0):= (OTHERS => 'X');
variable vREG_ARRAY_SR1   : std_logic_vector(2 downto 0):= (OTHERS => 'X');
variable vREG_ARRAY_SR2   : std_logic_vector(2 downto 0):= (OTHERS => 'X');
variable vBUS_IN   : std_logic_vector(15 downto 0):= (OTHERS => 'X');
variable vMDR_IN   : std_logic_vector(15 downto 0):= (OTHERS => 'X');
variable vINSTRUCT_REG_OUT : std_logic_vector(15 downto 0):= "0000000000000000";
variable vNZP_OUT : std_logic_vector(2 downto 0):= "000";
variable vExp_INSTRUCT_REG_OUT : std_logic_vector(15 downto 0):= "0000000000000000";
variable vExp_NZP_OUT : std_logic_vector(2 downto 0):= "000";
variable vTest_Out_Q : std_logic_vector(15 downto 0):= "0000000000000000";
variable vlinenumber: integer;
BEGIN

simcomplete := false;

while (not simcomplete) LOOP
  
	if (not endfile(in_file) ) then
		readline(in_file, in_line);
	else
		simcomplete := true;
	end if;

	if (not endfile(exo_file) ) then
		readline(exo_file, exo_line);
	else
		simcomplete := true;
	end if;
	
	if (in_line(1) = '-') then  --Skip comments
		next;
	elsif (in_line(1) = '.')  then  --exit Loop
	  Test_Out_Q <= "ZZZZZZZZZZZZZZZZ";
		simcomplete := true;
	elsif (in_line(1) = '#') then        --Echo comments to out.txt
	  i := 1;
	  while in_line(i) /= '.' LOOP
		comment(i) := in_line(i);
		i := i + 1;
	  end LOOP;

	elsif (exo_line(1) = '-') then  --Skip comments
		next;
	elsif (exo_line(1) = '.')  then  --exit Loop
	  	  Test_Out_Q  <= "ZZZZZZZZZZZZZZZZ";
		   simcomplete := true;
	elsif (exo_line(1) = '#') then        --Echo comments to out.txt
	     i := 1;
	   while exo_line(i) /= '.' LOOP
		 xcomment(i) := exo_line(i);
		 i := i + 1;
	   end LOOP;

	
	  write(out_line, comment);
	  writeline(out_file, out_line);
	  
	  write(xout_line, xcomment);
	  writeline(xout_file, xout_line);

	  
	ELSE      --Begin processing


		read(in_line, vBUS_IN );
		BUS_IN  <= vBUS_IN;
		read(in_line, vMDR_IN );
		MDR_IN  <= vMDR_IN;
		read(in_line, vRST );
		RST  <= vRST;
		read(in_line, vMAR_EN );
		MAR_EN  <= vMAR_EN;
		read(in_line, vMDR_EN );
		MDR_EN  <= vMDR_EN;
		read(in_line, vMEM_EN );
		MEM_EN  <= vMEM_EN;
		read(in_line, vRD_WRT_EN );
		RD_WRT_EN  <= vRD_WRT_EN;
		read(in_line, vGATE_MDR );
		GATE_MDR  <= vGATE_MDR;
		read(in_line, vREG16_EN );
		REG16_EN  <= vREG16_EN;
		read(in_line, vADDR1MUX_SEL );
		ADDR1MUX_SEL  <= vADDR1MUX_SEL;
		read(in_line, vADDR2MUX_SEL );
		ADDR2MUX_SEL  <= vADDR2MUX_SEL;
		read(in_line, vMARMUX_SEL );
		MARMUX_SEL  <= vMARMUX_SEL;
		read(in_line, vGATE_MARMUX );
		GATE_MARMUX  <= vGATE_MARMUX;
		read(in_line, vPCMUX_SEL );
		PCMUX_SEL  <= vPCMUX_SEL;
		read(in_line, vPC_EN );
		PC_EN  <= vPC_EN;
		read(in_line, vGATE_PC );
		GATE_PC  <= vGATE_PC;
		read(in_line, vREG_ARRAY_EN );
		REG_ARRAY_EN  <= vREG_ARRAY_EN;
		read(in_line, vREG_ARRAY_DR);
		REG_ARRAY_DR  <= vREG_ARRAY_DR;
		read(in_line, vREG_ARRAY_SR1 );
		REG_ARRAY_SR1  <= vREG_ARRAY_SR1;
		read(in_line, vREG_ARRAY_SR2 );
		REG_ARRAY_SR2  <= vREG_ARRAY_SR2;
		read(in_line, vSR2MUX_SEL );
		SR2MUX_SEL  <= vSR2MUX_SEL;
		read(in_line, vALU_SEL );
		ALU_SEL  <= vALU_SEL;
		read(in_line, vGATE_ALU );
		GATE_ALU  <= vGATE_ALU;
		read(in_line, vNZP_EN );
		NZP_EN  <= vNZP_EN;




		read(exo_line, vexp_INSTRUCT_REG_OUT );
		read(exo_line, vexp_NZP_OUT );
		read(exo_line, vTest_Out_Q );

    vlinenumber :=LineNumber;
    
    write(out_line, vlinenumber);
    write(out_line, STRING'("."));
    write(out_line, STRING'("    "));

	

    CYCLE(1,CLK);
    
    Exp_INSTRUCT_REG_OUT      <= vexp_INSTRUCT_REG_OUT;
    Exp_NZP_OUT      <= vexp_NZP_OUT;
    
      
    if (Exp_INSTRUCT_REG_OUT = INSTRUCT_REG_OUT and Exp_NZP_OUT = NZP_OUT) then
      Test_Out_Q <= "0000000000000000";
    else
      Test_Out_Q <= "XXXXXXXXXXXXXXXX";
    end if;

		vINSTRUCT_REG_OUT 	:= INSTRUCT_REG_OUT;
		vNZP_OUT 	:= NZP_OUT;
		vTest_Out_Q:= Test_Out_Q;
          		
		write(out_line, vINSTRUCT_REG_OUT, left, 5);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line, vNZP_OUT, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line,vTest_Out_Q, left, 5);                           --ht is ascii for horizontal tab
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line, vexp_INSTRUCT_REG_OUT, left, 5);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line, vexp_NZP_OUT, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		writeline(out_file, out_line);
		print(xout_file,    str(LineNumber)& "." & "    " &    str(INSTRUCT_REG_OUT) &  "  " & str(NZP_OUT) & "          " &   str(Exp_INSTRUCT_REG_OUT)  & "  " & str(Exp_NZP_OUT) & "          " & str(Test_Out_Q) );

	
	END IF;
	LineNumber<= LineNumber+1;

	END LOOP;
	WAIT;
	
	END PROCESS;

END TESTBENCH;


CONFIGURATION cfg_tb_OYEDELE_DATA_PATH OF TB_DATA_PATH IS
	FOR TESTBENCH
		FOR InstOYEDELE_MYDESIGN_DATA_PATH: DATA_PATH
			use entity work.DATA_PATH(STRUCTURAL);
		END FOR;
	END FOR;
END;


