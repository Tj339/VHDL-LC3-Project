------------------------------------------------------------
--File Name: OYEDELE_TB_LC3
--Teminijesu Oyedele
--Advanced Digital Design
--Spring 2023
-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity OYEDELE_TB_LC3 is
end OYEDELE_TB_LC3;


architecture TB1 of OYEDELE_TB_LC3 is

component LC3 is
	generic( P: INTEGER:=16;
		   MW: INTEGER:=9;
		   E: natural:=8);
	port(
		CLK: in std_logic;
		RST: in std_logic
	);
end component LC3;

signal CLKtb : std_logic;
signal RSTtb : std_logic;

begin

CLK_GEN: process
begin
while now <= 6000 us loop
CLKtb <='1'; wait for 5 ns; CLKtb <='0'; wait for 5 ns;
end loop;
wait;
end process;

Reset: process
begin
RSTtb  <='1','0' after 10 ns;
wait;
end process;


--------------------------------------do not change-----------------------------------------------
datap: LC3 port map ( CLK=>CLKtb, RST=>RSTtb);

end TB1;

configuration CFG_OYEDELE_TB_LC3 of OYEDELE_TB_LC3 is
for TB1
end for;
end CFG_OYEDELE_TB_LC3;