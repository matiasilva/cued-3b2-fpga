library ieee;
use ieee.std_logic_1164.all;

entity shiftltr is
    generic ( N : integer := 4 ) ;
    port (
        clk  : in std_logic ;
        R    : in std_logic_vector(N-1 downto 0) ;
        L, E : in std_logic ;
        Q    : out std_logic_vector(N-1 downto 0)
    ) ;
end shiftltr ;

architecture beh of shiftltr is
begin
    shift : process
    begin
        if rising_edge(clk) then
            if L = '1' then
                Q <= R ;
            else
                if E = '1' then
                    movbits : for i in 0 to N-2 loop
                        Q(i) <= Q(i+1) ; 
                    end loop ;
                    Q(N-1) <= '0' ;
                    -- fill reg with 0s
                end if ;
            end if ;
        end if ;
    end process shift ;
end beh ; 