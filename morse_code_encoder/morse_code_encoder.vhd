library ieee;
use ieee.std_logic_1164.all;

-- top level morse code encoder
entity mce is 
    port(
        clk : in std_logic;
        reset : in std_logic;
        request : in std_logic;
        letter : in std_logic_vector(2 downto 0);
        led : out std_logic
    );
end mce;

architecture beh of mce is
    -- build an enumerated type for the state machine 
	type state_type is (a, b, c, d); 
    -- register to hold the current state 
    signal state : state_type;
    signal halfs_clk : std_logic;
    signal code_length : std_logic_vector(2 downto 0)
    -- register to hold current letter in morse code
    -- 0 represents dot, 1 represents dash
    signal code : std_logic_vector(3 downto 0)

begin
    -- core logic
    process(clk, reset)
        if reset = '0' then
            state <= a;
        elsif rising_edge(clk) then
            case state is
                when a =>
                    
            end case;
        end if;
    end process;

	-- clock divider
	process (clk)
		variable count : integer; 
	begin
		if rising_edge(clk) then
            -- toggles every 0.25 s, so full cycle is 0.5s
			if count = 12500000 then
				s_toggle <= not s_toggle;
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process;
end beh;