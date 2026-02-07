library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Imm_gen is
    Port (
    instrIN: in std_logic_vector(31 downto 0);
    immType: in std_logic_vector(2 downto 0); -- 3 bits to select the TYPE of the immediate
    
    immOUT: out std_logic_vector(31 downto 0)
    
    
     );
end Imm_gen;

architecture Behavioral of Imm_gen is

begin

process(instrIN,immType)
begin
    case immType is -- to prevent latches we use '&' operator  (immOUT is filled from the MSB first)
        when "001" => -- I-TYPE
            immOUT <= (31 downto 12 => instrIN(31)) -- sign extension
            & instrIN(31 downto 20);  -- imm[11:0]
            
        when "010" => -- S-TYPE
            immOUT <= (31 downto 12 => instrIN(31))
            & instrIN(31 downto 25) -- imm[11:5]
            & instrIN(11 downto 7); -- imm[4:0]
            
        when "011" => -- B-TYPE
            immOUT <= (31 downto 12 => instrIN(31)) 
            & instrIN(7) -- imm[11] (isolated bit)
            & instrIN(30 downto 25) -- imm[10:5]
            & instrIN(11 downto 8) -- imm[4:1]
            & '0'; -- imm[0] (always 0 for half-word alignment)
        
        when "100" => -- U-type
            immOUT <= instrIN(31 downto 12) -- imm[31:12]
            & (11 downto 0 => '0'); 
        
        when "101" => -- J-type
            immOUT <= (31 downto 20 => instrIN(31)) 
            & instrIN(19 downto 12) -- imm[19:12]
            & instrIN(20) -- imm[11] (isolated bit)
            & instrIN(30 downto 21) -- imm[10:1]
            & '0';
 
        when others =>
            immOUT <= (others => '0');
            
     end case;
end process;



end Behavioral;
