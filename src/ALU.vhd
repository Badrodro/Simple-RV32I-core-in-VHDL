library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is
    Port ( 
    source1: in unsigned(31 downto 0);
    source2: in unsigned(31 downto 0);
    aluOP: in std_logic_vector(3 downto 0); -- used to select which operation the ALU need to make
    
    aluResult: out std_logic_vector(31 downto 0); -- output result from the ALU
    zero: out std_logic -- Zero FLAG
    
    );
end ALU;

architecture Behavioral of ALU is

signal s_result: unsigned(31 downto 0);

begin

process(source1,source2,aluOP)

variable distance: integer;-- distance need to be an integer because the function shit_left/right takes only integer

begin
    distance := to_integer(source2(4 downto 0));
    case aluOP is 
        when "0000" => -- ADD operation
            s_result <= source1 + source2;
            
        when "0001" => -- SUB operation
            s_result <= source1 - source2;
            
        when "0010" => -- AND operation
            s_result <= source1 and source2;
            
        when "0011" => -- OR operation
            s_result <= source1 or source2;
            
        when "0100" => -- XOR operation
            s_result <= source1 xor source2;
            
        when "0101" => -- SLL (shift left logical) where source1 is left-shifted by the 5 LSB of source2 (5 because source1 is 32 bits long)
            s_result <= shift_left(source1,distance);
            
        when "0110" => -- SRL (shift right logical) where source1 is right-shifted by the 5 LSB of source2
            s_result <= shift_right(source1,distance);
            
        when "0111" => -- SRA (shift right arithmetic) source1 is signed, the value will depend on the MSB, if the MSB is 1 we fill empty spaces with 1s otherwise with 0s. ex: 100, ASR >> 1 will give 110 and with ASR 2>> will give 111
            s_result <= unsigned(shift_right(signed(source1),distance));
            
        when  "1000" => -- SLT (set less than)
            if signed(source1) < signed(source2) then
                s_result <= to_unsigned(1,32); -- the value '1' in 32 bit-long bus target (000...1)
            else
                s_result <= (others => '0');
            end if;
            
         when "1001" => --SLTU((set less than unsigned)
            if source1 < source2 then
                s_result <= to_unsigned(1,32);
            else
                s_result <= (others => '0');
            end if;
            
         when others =>
                s_result <= (others => '0');
         end case;
end process;
                
aluResult <= std_logic_vector(s_result);             
zero <= '1' when unsigned(s_result) = 0 else '0';             
                
end Behavioral;
