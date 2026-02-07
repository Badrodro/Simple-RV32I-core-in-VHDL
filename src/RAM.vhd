library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RAM is
    Port (
    clk: in std_logic;
    we: in std_logic;
    addr: in std_logic_vector(31 downto 0); -- the adress where we want to write/read
    
    dataIN: in std_logic_vector(31 downto 0); -- the data we want to write
    dataOUT: out std_logic_vector(31 downto 0) -- the data we want to readt



);
end RAM;

architecture Behavioral of RAM is
type ram_type is array (0 to 1023) of std_logic_vector(31 downto 0);
signal s_ram: ram_type := (others =>(others => '0'));
begin

-- write and read logic
process(clk)
begin
    if rising_edge(clk) then
        if we = '1' then
            s_ram(to_integer(unsigned(addr(11 downto 2)))) <= dataIN;
        end if;
        dataOUT <= s_ram(to_integer(unsigned(addr(11 downto 2))));
    end if;
end process;


end Behavioral;
