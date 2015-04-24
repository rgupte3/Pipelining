-- ECE 3056: Architecture, Concurrency and Energy in Computation
-- Pipelined MIPS Processor VHDL Behavioral Mode--
--
--
-- Instruction fetch behavioral model. Instruction memory is
-- provided within this model. IF increments the PC,  
-- and writes the appropriate output signals. 
--
-- Name: Ria Gupte
-- GT ID: 902758920
-- GT username: rgupte3
-- Changes: Changing of next_PC mux. controlled my PCSrc and stall. PART A

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fetch is 
--

port(instruction  : out std_logic_vector(31 downto 0);
	  PC_out       : out std_logic_vector (31 downto 0);
	  Branch_PC    : in std_logic_vector(31 downto 0);
	  clock, reset, PCSource, stall:  in std_logic);
end fetch;

architecture behavioral of fetch is 
TYPE INST_MEM IS ARRAY (0 to 10) of STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL iram : INST_MEM := (
 X"8c0b0008", -- lw $11, 8($0)
 X"8c0a0004", -- lw $10, 4($0)
 X"8c080000", -- lw $8, 0($0)
 X"01a86820", -- add $13, $13, $8
 X"01aa6820", -- add $13, $13, $10
 X"01ab6820", -- add $13, $13, $11
 X"ac0d000c", -- sw $13, 12($0)
 X"1000FFF8",   -- beq $0, $0, -8 
 X"00000000",   --  nop
 X"00000000",   --  nop
 X"00000000"    -- nop
                     
   );
   
   SIGNAL PC, Next_PC : STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN 						
-- access instruction pointed to by current PC
-- and increment PC by 4. This is combinational
		             
Instruction <=  iram(CONV_INTEGER(PC(4 downto 2)));  -- since the instruction
                                                     -- memory is indexed by integer
PC_out<= (PC + 4) when stall='0' else
	PC;			
   
-- compute value of next PC
-- PART A: stall was added to the control  of the mux, when stall is 1, the value is PC

Next_PC <=  (PC + 4)    when PCSource = '0' and stall='0' else
            Branch_PC    when PCSource = '1' and stall ='0' else
		PC when stall ='1' else
            X"CCCCCCCC";
			   
-- update the PC on the next clock			   
	PROCESS
		BEGIN
			WAIT UNTIL (rising_edge(clock));
			IF (reset = '1') THEN
				PC<= X"00000000" ;
			ELSE 
				PC <= Next_PC;    -- cannot read/write a port hence need to duplicate info
			 end if; 
			 
	END PROCESS; 
   
   end behavioral;


	
