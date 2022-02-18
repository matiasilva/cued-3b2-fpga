library ieee;
use ieee.std_logic_1164.all;

entity counter7seg is
    port(
        clk_main : in std_logic;
        reset : in std_logic;
        hex0 : out std_logic_vector(6 downto 0)
    );
end counter7seg;

architecture beh of counter7seg is
    signal one_second : std_logic;
    signal ten_second : std_logic;
    signal bcd0 : std_logic_vector(3 downto 0);

    component counter
        port (
            clk : in std_logic;
            enable : in std_logic;
            reset : in std_logic;
            load : in std_logic;
            up : in std_logic;
            start : in std_logic_vector(n-1 downto 0);
            count : out std_logic_vector(n-1 downto 0);
            rollover : out std_logic
        );
    end component;

    component bcd7seg
        port ( 
            clk : in std_logic;
            bcd	: in std_logic_vector(3 downto 0);
            hex : out std_logic_vector(0 to 6)
        );
    end component;
    
begin
    slow_clk : counter 
        generic map (n => 25; k => 50000000) -- counts from 49999999 to 0
        port map (clk => clk_main, reset => '1', enable=> '1', start => (others => '0'), up => '0', rollover => one_second);

    second_counter : counter
        generic map (n => 4; k => 10) -- counts from 0 to 9
        port map (clk => clk_main, reset => '1', enable=> one_second, start => (others => '0'), up => '1', count => bcd0);

    display : bcd7seg
        port map (clk => clk_main, bcd => bcd0, hex => hex0);
end beh;