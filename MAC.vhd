----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2022 10:58:07 AM
-- Design Name: 
-- Module Name: MAC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAC is
    Port ( input1 : in std_logic_vector(7 downto 0);
           input2 : in STD_LOGIC_vector(7 downto 0);
           cntrl : in STD_LOGIC;
           output : out STD_LOGIC_vector(15 downto 0);
           start: in std_logic);
end MAC;

architecture Behavioral of MAC is
signal accumulator: unsigned(15 downto 0):= to_unsigned(0,16);
begin
process(start)
    variable temp: unsigned(15 downto 0);
begin
if rising_edge(start) then 
    if cntrl = '1' then
        accumulator<= to_unsigned(0,16);        
    else
        temp:= unsigned(input1)*unsigned(input2);
        accumulator<= accumulator + temp;
    end if;
    output<= std_logic_vector(accumulator);
end if;
end process;
        


end Behavioral;
