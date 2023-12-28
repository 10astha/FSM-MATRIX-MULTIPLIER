----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2022 22:15:26
-- Design Name: 
-- Module Name: tbmac - Behavioral
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

entity tbmac is 
end tbmac;

architecture Behavioral of tbmac is
component mac
port( input1 : in std_logic_vector(7 downto 0);
           input2 : in STD_LOGIC_vector(7 downto 0);
           cntrl : in STD_LOGIC;
           output : out STD_LOGIC_vector(15 downto 0);
           start: in std_logic);
end component;
--input
signal start : std_logic := '0';
signal input1: std_logic_vector(7 downto 0):= (others => '0');
signal input2: std_logic_vector(7 downto 0):= (others => '0');
signal cntrl : std_logic := '0';
--output
signal output : std_logic_vector(15 downto 0) :=(others => '0');
begin
Multiplier: MAC port map(start=>start,input1=>input1,input2=>input2, output=> output,cntrl=>cntrl);
input1 <= std_logic_vector(to_unsigned(2,8));
input2 <= std_logic_vector(to_unsigned(2,8));
process(start)
begin
start<= not(start) after 10 ns;
end process;
end Behavioral;
