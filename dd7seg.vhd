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
	seg2 <= "0000001" WHEN (bcd = "0000") ELSE
			"1001111" WHEN (bcd = "0001") ELSE 
			"0010010" WHEN (bcd = "0010") ELSE 
			"0000110" WHEN (bcd = "0011") ELSE 
			"1001100" WHEN (bcd = "0100") ELSE 
			"0100100" WHEN (bcd = "0101") ELSE 
			"1100000" WHEN (bcd = "0110") ELSE 
			"0001111" WHEN (bcd = "0111") ELSE 
			"0000000" WHEN (bcd = "1000") ELSE 
			"0001100" WHEN (bcd = "1001") ELSE
			"0000001" WHEN (bcd = "1010") ELSE
			"1001111" WHEN (bcd = "1011") ELSE
			"0010010" WHEN (bcd = "1100") ELSE
			"0000110" WHEN (bcd = "1101") ELSE
			"0001100" WHEN (bcd = "1110") ELSE
			"1001100" WHEN (bcd = "1111");
	seg1 <= "1001111" WHEN ((bcd(3) AND (bcd(1) OR bcd(2))) = '1') ELSE
			"0000001";
			-- simple logic function true for bcd > decimal 10
end beh;