library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- A testbench has no ports (it is an empty entity)
entity top_tb is
end top_tb;

architecture sim of top_tb is
    -- 1. Signal Declarations
    signal clk_tb     : std_logic := '0';
    signal reset_tb   : std_logic := '1';
    signal trap_tb    : std_logic; -- Monitor the trap signal for system termination
    signal testOUT_tb : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- 3. Unit Under Test (UUT) Instantiation
    uut: entity work.top
        port map (
            clk     => clk_tb,
            reset   => reset_tb,
            trap    => trap_tb, -- Mapping the trap signal for validation
            testOUT => testOUT_tb
        );

    -- 4. Clock Generation Process
    clk_process : process
    begin
        clk_tb <= '0'; wait for clk_period/2;
        clk_tb <= '1'; wait for clk_period/2;
    end process;

    -- 5. Intelligent Stimulus Process
    stim_proc: process
    begin        
        -- Initial reset sequence
        reset_tb <= '1';
        wait for 25 ns;
        reset_tb <= '0';

        -- Synchronization: wait for a system event (trap signal)
        -- This event-driven approach is preferred for research-grade verification
        wait until trap_tb = '1' for 2000 ns; 

        if trap_tb = '1' then
            assert false report "SUCCESS: SYSTEM instruction detected (ecall/ebreak). Clean program termination." severity note;
        else
            assert false report "ERROR: Simulation timeout! The processor failed to assert the TRAP signal." severity failure;
        end if;

        -- Stop simulation
        wait;
    end process;

end sim;
