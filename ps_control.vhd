--
-- control unit. simply implements the truth table for a small set of
-- instructions 
--
-- Name: Ria Gupte
-- GT ID: 902758920
-- GT username: rgupte3
-- Changes: this module takes in instruction from mem and ex, opcode for ex and generates the stall signal. PART E

Library IEEE;
use IEEE.std_logic_1164.all;

entity control is
port(opcode, opcode_ex: in std_logic_vector(5 downto 0);
	ex_wreg_addr : in std_logic_vector(4 downto 0);
	instruction, instruction_ex, instruction_mem : in std_logic_vector(31 downto 0);
     RegDst, MemRead, MemToReg, MemWrite, stall :out  std_logic;
     ALUSrc, RegWrite, Branch: out std_logic;
     ALUOp: out std_logic_vector(1 downto 0));
end control;

architecture behavioral of control is

signal rformat, lw, sw, beq , delay :std_logic; -- define local signals
				    -- corresponding to instruction
				    -- type 
 begin 
--
-- recognize opcode for each instruction type
-- these variable should be inferred as wires	 

	rformat 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';

--
-- implement each output signal as the column of the truth
-- table  which defines the control
-- Delay and stall are generated to determie if there is dependency between lw and ALU instruction. PART E.
--
 stall <= '1' when (Opcode ="000000" and opcode_ex ="100011" and delay ='1') else
 	  '0';
delay <= '1' when (instruction(25 downto 21) = ex_wreg_addr or instruction(20 downto 16)= ex_wreg_addr) else
	'0';

RegDst <= rformat;
ALUSrc <= (lw or sw) ;

MemToReg <= lw ;
RegWrite <= (rformat or lw);
MemRead <= lw ;
MemWrite <= sw;	   
Branch <= beq;

ALUOp(1 downto 0) <=  rformat & beq; -- note the use of the concatenation operator
				     -- to form  2 bit signal

end behavioral;
 