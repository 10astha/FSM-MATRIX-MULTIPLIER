library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register3 is
    Port( din: in std_logic_vector(15 downto 0);
          we: in std_logic;
          clock: in std_logic;
          dout: out std_logic_vector(15 downto 0));
end register3;

architecture working of register3 is
signal temp:std_logic_vector(15 downto 0) := (others=> '0');
begin
process(clock)
begin
    if rising_edge(clock) then
        if we ='0' then
            dout<=temp;
        else
            temp<=din;
        end if;
    end if;
end process;
             
end working;