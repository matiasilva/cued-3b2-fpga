library ieee;
use ieee.std_logic_1164.all;

entity letter_decoder is
    port ( 
        letter : in std_logic_vector (2 downto 0) ;
        len    : out std_logic_vector (3 downto 0) ; 
        -- no dependence on clk, purely combinational
        data   : out std_logic_vector(3 downto 0)
    ) ; 
end letter_decoder ;

architecture beh of letter_decoder is
begin
    -- len will be shifted right
    -- # of 1s match length of code
    with letter select len <=
        '0011' when '000',
        '1111' when '001',
        '1111' when '010',
        '0111' when '011',
        '0001' when '100',
        '1111' when '101',
        '0111' when '110',
        '1111' when '111';
    
    with letter select data <=
        -- 1 is a dash, 0 is a dot
        '0010' when '000',
        '0001' when '001',
        '1010' when '010',
        '0100' when '011',
        '0000' when '100',
        '0010' when '101',
        '0110' when '110',
        '0000' when '111';
end beh ; -- beh