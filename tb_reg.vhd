LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY tb_ROM_block IS
END tb_ROM_block;
ARCHITECTURE behavior OF tb_ROM_block IS
COMPONENT dist_mem_gen_0
PORT(
clk : IN STD_LOGIC;
a : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
qspo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;
COMPONENT dist_mem_gen_1
PORT(
clk : IN STD_LOGIC;
a : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
qspo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;
component register1
Port( 
    din: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clock: in std_logic;
    dout: out std_logic_vector(7 downto 0));
end component;
component register2
Port( 
    din: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clock: in std_logic;
    dout: out std_logic_vector(7 downto 0));
end component;
signal var: integer range 0 to 127:= 0;
signal clock : std_logic := '1';
signal q1,q2 : std_logic_vector(7 downto 0) := (others => '0');
signal w1,w2: std_logic;
signal d1,d2: std_logic_vector(7 downto 0);
signal o1,o2: std_logic_vector(7 downto 0);
signal a1, a2: std_logic_vector(13 downto 0);
-- Clock period definitions
constant clock_period : time := 10 ns;
BEGIN
-- Read image in VHDL
ROM1: dist_mem_gen_0 PORT MAP (
clk => clock,
qspo => q1,
a => a1);
ROM2:dist_mem_gen_1 port map(clk=> clock, a=> a2, qspo=> q2);
reg1: register1 port map(clock=>clock, din=>d1, dout=>o1, we=> w1);
reg2: register2 port map(clock=>clock, din=>d2, dout=>o2, we=> w2);

-- Clock process definitions
clock_process :process
begin
clock <= '1';
wait for clock_period/2;
clock <= '0';
wait for clock_period/2;
end process;
-- Stimulus process
stim_proc: process
variable add1, add2: integer range 0 to 16383;
variable counter: integer range 0 to 16383:=0;
begin
add1:= counter mod 128;
add2:= counter/ 128;
a1<= std_logic_vector(to_unsigned(add1 +var*128, 14));
a2<= std_logic_vector(to_unsigned(add2 + var, 14));
wait for 10 ns;
w1 <= '1';
w2<= '1';
d1 <= q1;
d2 <= q2;
wait for 10 ns;
w1<= '0';
w2<= '0';
var<= var +1;
if var = 128 then
    var<= 0;
    counter:= counter +1;
end if;
end process;
END;