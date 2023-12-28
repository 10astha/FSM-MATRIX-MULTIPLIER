library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_FSM is
    Port ( clk: in std_logic;
    sw : IN STD_LOGIC_vector(13 downto 0):= (others=> '0');
    led : out STD_LOGIC_vector(15 downto 0));
end Control_FSM;

architecture Behavioral of Control_FSM is
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
COMPONENT dist_mem_gen_2
PORT(
clk : IN STD_LOGIC;
a : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
d : in std_logic_vector(15 downto 0);
we : in std_logic; 
qspo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END COMPONENT;
component MAC
port(
    input1: in std_logic_vector(7 downto 0);
    input2 : in STD_LOGIC_vector(7 downto 0);
    cntrl : in STD_LOGIC;
    output : out STD_LOGIC_vector(15 downto 0);
    start: in std_logic);
end component;
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
component register3
Port( 
    din: in std_logic_vector(15 downto 0);
    we: in std_logic;
    clock: in std_logic;
    dout: out std_logic_vector(15 downto 0));
end component;
type state is (sROM, sRAM, sMAC, sComplete);
signal cntrl: std_logic;
signal current_state: state:= sROM;
signal a1,a2,aRAM : std_logic_vector(13 downto 0);
signal q1,q2, o1,o2: std_logic_vector(7 downto 0);
signal RAMwe,w1, w2,w3: std_logic:= '0';
signal dRAM, qRAM,d3, o3: std_logic_vector( 15 downto 0);
signal i1,i2, d1,d2: std_logic_vector(7 downto 0);
signal output: std_logic_vector(15 downto 0):= (others=> '0');
signal start: std_logic:='0';
begin
ROM1:dist_mem_gen_0 port map(clk=> clk, a=> a1, qspo=> q1);
ROM2:dist_mem_gen_1 port map(clk=> clk, a=> a2, qspo=> q2);
RAM:dist_mem_gen_2 port map(clk=> clk, a=> aRAM, qspo=> qRAM, we=> RAMwe, d=> dRAM);
Multiplier: MAC port map(start=>start,input1=>i1,input2=>i2, output=> output,cntrl=>cntrl);
reg1: register1 port map(clock=>clk, din=>d1, dout=>o1, we=> w1);
reg2: register2 port map(clock=>clk, din=>d2, dout=>o2, we=> w2);
reg3: register3 port map(clock=>clk, din=>d3, dout=>o3, we=> w3);
clock_process :process
variable var: integer range 0 to 127:= 0;
variable add1, add2: integer range 0 to 16383;
variable counter: integer range 0 to 16383:=0;
begin
if current_state = sComplete then
    RAMwe<= '0';
    aRAM<= sw;
    wait for 60 ns;
    led<= qRAM;      
elsif current_state = sROM then
    add1:= counter mod 128;
    add2:= counter/ 128;
    a1<= std_logic_vector(to_unsigned(add1 + var*128, 14));
    a2<= std_logic_vector(to_unsigned(add2 + var, 14));
    wait for 60 ns;
    w1<= '1';
    d1<= q1;   
    w2<= '1';
    d2<=q2;
    current_state<= sMAC;
    wait for 10 ns;
elsif current_state = sMAC then
    w1<= '0';
    w2<= '0';
    wait for 10 ns;
    i1<= o1;
    i2<= o2;
    start<= '1';
    var:= var +1;
    wait for 10ns;
    if var= 128 then
        current_state<= sRAM;
        var:= 0;
        w3<= '1';
        d3<= output;               
    else 
        current_state<= sROM;
    end if;
    wait for 10 ns;
    start<= '0';
elsif current_state = sRAM then
    w3<= '0';
    wait for 10 ns;
    RAMwe<= '1';
    aRAM<= std_logic_vector(to_unsigned(counter, 14)); 
    dRAM<= o3;
    wait for 60 ns;
    RAMwe<= '0';
    counter:= counter +1;
    if counter< 16384 then
        current_state<= sROM;
        cntrl<= '1';
        cntrl<= '0' after 20 ns;
    else
        current_state<= sComplete;
    end if; 
wait for 10ns;
end if;            
end process;
end Behavioral;
