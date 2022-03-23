library ieee;
use ieee.std_logic_1164.all;

-- top level morse code encoder
entity mce is 
    port(
        50_clk : in std_logic;
        reset : in std_logic;
        request : in std_logic;
        letter : in std_logic_vector(2 downto 0);
        led : out std_logic
    );
end mce;

architecture beh of mce is
    -- build an enumerated type for the state machine 
	type state_type is (a, b, c, d, e); 
    -- register to hold the current state 
    signal state : state_type;
    signal halfs_clk : std_logic;

    -- 
    signal code_length : std_logic_vector(3 downto 0);
    signal code : std_logic_vector(3 downto 0);

    -- state change
    signal load_next_code : std_logic;

    -- morse encoding
    signal sel_letter : std_logic_vector(3 downto 0);
    signal sel_letter_len : std_logic_vector(3 downto 0)

    component up_counter
        port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            start : in std_logic_vector(n-1 downto 0);
            count : out std_logic_vector(n-1 downto 0);
            rollover : out std_logic
        );
    end component ;

    component letter_decoder
        port ( 
            letter : in std_logic_vector (2 downto 0) ;
            len    : out std_logic_vector (3 downto 0) ; 
            -- no dependence on clk, purely combinational
            data   : out std_logic_vector(3 downto 0)
        ) ; 
    end component ;

    component shiftltr
        port (
            clk  : in std_logic ;
            R    : in std_logic_vector(N-1 downto 0) ;
            L, E : in std_logic ;
            Q    : out std_logic_vector(N-1 downto 0)
        ) ;
    end component ;

begin
    -- pulses every 0.5s
    halfs_counter : counter
        generic map (k => 24999999, n => 26)
        port map (clk => 50_clk, reset => '1', enable => '1', start => (others => '0'), rollover => halfs_clk) ;

    -- always returns the length and code data corresponding to switch inputs
    decoder : letter_decoder
        port map (letter => letter, len => sel_letter_len, data => sel_letter) ;

    -- shift in new data upon request
    length_shifter : shiftltr
        port map (clk => halfs_clk, R => sel_letter_len, L => request, E => (state /= A), Q => code_length)

    code_shifter : shiftltr
        port map (clk => halfs_clk, R => sel_letter, L => request, E => (state /= A), Q => code)

    -- core logic
    process(halfs_clk, reset)
        if reset = '0' then
            state <= a;
        elsif rising_edge(halfs_clk) then
            case state is
                when a =>
                    if request = '0' then
                        state <= b ;
                    else
                        state <= a ;
                    end if ;
                when b =>
                    if code(0) = '0' then
                        state <= e ;
                    else
                        state <= c ;
                    end if ;
                when c =>
                    state <= d ;
                when d =>
                    state <= e ;
                when e =>
                    if code_length(0) = '1' then
                        state <= b ;
                    else
                        state <= a ;
                    end if ;
            end case ;
        end if;
    end process;

    -- output depends solely on state
    process (state)
    begin
        case state is
            when a | e =>
                led <= '0' ; 
            when others =>
                led <= '1' ;
        end case ; 
    end process ; 
end beh;