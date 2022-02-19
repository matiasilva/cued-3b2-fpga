library ieee;
use ieee.std_logic_1164.all;

-- implementation of a double-digit 7 seg display driver with 4-bit input
entity dd7seg is
	port ( 
			clk : in std_logic;
			bcd	: in std_logic_vector(3 downto 0);
			seg1 : out std_logic_vector(0 to 6)
			seg2 :  out std_logic_vector(0 to 6)
		);
end dd7seg;

architecture beh of dd7seg is
begin
	seg2 <= "0000001" when (bcd = "0000") else
			"1001111" when (bcd = "0001") else 
			"0010010" when (bcd = "0010") else 
			"0000110" when (bcd = "0011") else 
			"1001100" when (bcd = "0100") else 
			"0100100" when (bcd = "0101") else 
			"1100000" when (bcd = "0110") else 
			"0001111" when (bcd = "0111") else 
			"0000000" when (bcd = "1000") else 
			"0001100" when (bcd = "1001") else
			"0000001" when (bcd = "1010") else
			"1001111" when (bcd = "1011") else
			"0010010" when (bcd = "1100") else
			"0000110" when (bcd = "1101") else
			"0001100" when (bcd = "1110") else
			"1001100" when (bcd = "1111");
	seg1 <= "1001111" when ((bcd(3) and (bcd(1) or bcd(2))) = '1') else
			"0000001";
			-- simple logic function true for bcd > decimal 10
end beh;