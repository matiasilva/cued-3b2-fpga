library ieee;
use ieee.std_logic_1164.all;

-- top level traffic light controller
entity tlc is 
  port(  
	  clk  : in std_logic;
	  request : in std_logic;
	  reset  : in std_logic;
	  leds  : out  std_logic_vector(4 downto 0)
	  hex0 : out std_logic_vector(0 to 6)
	  hex1 : out std_logic_vector(0 to 6)
  ); 
end tlc; 

architecture tlc_arch of tlc is 
  -- build an enumerated type for the state machine 
	type state_type is (g, y, r, w); 
  -- register to hold the current state 
	signal state : state_type;
  -- second toggle clock
	signal s_toggle : std_logic;
  -- register to hold current second count
	signal bcd : std_logic_vector(3 downto 0);

	component dd7seg is
		port(
			clk : in std_logic;
			bcd	: in std_logic_vector(3 downto 0);
			hex0 : out std_logic_vector(0 to 6)
			hex1 :  out std_logic_vector(0 to 6)
		);
	end component;

begin 
	-- instantiate 7 seg driver
	d1 : dd7seg port map(clk => s_toggle, bcd => bcd, hex0 => hex0, hex1 => hex1);
	
	-- logic to advance to the next state
	process (clk, reset)
		variable count : integer; 

		begin
			if reset = '0' then
				state <= g;
			elsif rising_edge(clk) then
				case state is
					when g=>
						if request = '0' then
							state <= y;
							count := 0;
						end if;
					when y=>
						-- define time constants
						-- (50mhz clk means 50000000 cycles/s) 
						if count = 250000000 then
							state <= r;
							count := 0;
						else
							count := count + 1;
						end if;
					when r=>
						if count = 500000000 then
							state <= w;
							count := 0;
						else
							count := count + 1;
						end if;
					when w=>
						if count = 500000000 then
							state <= g;
							count := 0;
						else
							count := count + 1;
						end if;
				end case;
			end if;
	end process; 

  -- output depends solely on the current state
	process (state)
	begin
		case state is
			when g =>
				leds <= "10001";
				bcd <= "0000"
			when w =>
				leds <= "10001";
				bcd  <= "1010";
			when y =>
				leds <= "10010";
				bcd <= "0101";
			when r =>
				leds <= "01100";
				bcd <= "1010";
		end case;
	end process;

	-- clock divider
	process (clk)
		variable count : integer; 
	begin
		if rising_edge(clk) then
			if count = 50000000 then
				s_toggle <= not s_toggle;
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process;

	-- decrementer
	process (s_toggle)
	begin
		if s_toggle'event = '1' then
			if bcd = "0000" then
				bcd <= "0000"
			else
				bcd <= bcd - 1;
			end if;
		end if;
	end process;
end tlc_arch; 