library ieee;
use ieee.std_logic_1164.all;

-- implementation of a 7 seg display driver with 4-bit input
entity bcd7seg is
	port ( 
			clk : in std_logic;
			bcd	: in std_logic_vector(3 downto 0);
			hex : out std_logic_vector(0 to 6)
		);
end bcd7seg;

architecture beh of bcd7seg is
begin
	hex <= "0000001" when (bcd = "0000") else
			"1001111" when (bcd = "0001") else 
			"0010010" when (bcd = "0010") else 
			"0000110" when (bcd = "0011") else 
			"1001100" when (bcd = "0100") else 
			"0100100" when (bcd = "0101") else 
			"1100000" when (bcd = "0110") else 
			"0001111" when (bcd = "0111") else 
			"0000000" when (bcd = "1000") else 
			"0001100" when (bcd = "1001") else
            "1111111";
end beh;