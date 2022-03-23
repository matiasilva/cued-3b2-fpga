library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;

-- two approaches for clk divider: NOR all bits, or use rollover flag

entity up_counter is
    generic (k : integer := 0; n : integer := 26);
    port(
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        start : in std_logic_vector(n-1 downto 0);
        count : out std_logic_vector(n-1 downto 0);
        rollover : out std_logic
    );
end up_counter;

architecture beh of up_counter is
    signal current_count : std_logic_vector(n-1 downto 0);
begin
    process (clk, reset)
        if reset = '0' then
            current_count <= start;
        elsif rising_edge(clk) then
            if enable = '1' then
                if current_count =  conv_std_logic_vector(k, n) then
                    -- rollover to max value
                    current_count <= 0;
                else   
                    current_count <= current_count + 1;
                end if;
            end if;
        end if;
    end process;

    count <= current_count;
    rollover <= '1' when (current_count = '0') else '0';
    -- above is high for one clock only
end beh;