library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;

-- two approaches for clk divider: NOR all bits, or use rollover flag

entity counter is
    generic (k : integer := 67108864; n : integer := 25);
    port(
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        load : in std_logic;
        start : in std_logic_vector(n-1 downto 0);
        up : in std_logic; -- up counter or down counter
        count : out std_logic_vector(n-1 downto 0);
        rollover : out std_logic
    );
end counter;

architecture beh of counter is
    signal current_count : std_logic_vector(n-1 downto 0);
begin
    process (clk, reset)
        if reset = '0' then
            current_count <= start;
        elsif load = '1' then
            current_count <= start;
        elsif rising_edge(clk) then
            if enable = '1' then
                if 'up' = '0' then
                    if current_count = '0' then
                        -- rollover to max value
                        current_count <= conv_std_logic_vector(k-1, n);
                    else   
                        current_count <= current_count - 1;
                    end if;
                else
                    if current_count =  conv_std_logic_vector(k-1, n) then
                        -- rollover to max value
                        current_count <= 0;
                    else   
                        current_count <= current_count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    count <= current_count;
    rollover <= '1' when (current_count = '0') else '0';
    -- above is high for one clock only
end beh;