library ieee;
use ieee.std_logic_1164.all;

entity Lab12 is
    port 
    (
        GPIO : in std_logic_vector(35 downto 0);
        SW : in std_logic_vector(9 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(7 downto 0);
        HEX1 : out std_logic_vector(7 downto 0);
        HEX2 : out std_logic_vector(7 downto 0);
        HEX3 : out std_logic_vector(7 downto 0);
        HEX4 : out std_logic_vector(7 downto 0);
        HEX5 : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of Lab12 is

component reg is
    port 
    (
        clk : in std_logic;
        enable : in std_logic;
        D : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0)
    );
end component;

component inc_reg is
    port 
    (
        clk : in std_logic;
        reset : in std_logic;
        inc : in std_logic;
        enable : in std_logic;
        D : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0)
    );
end component;

component ALU is
    port 
    (
        fn : in std_logic_vector(1 downto 0);
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        equal : out std_logic
    );
end component;

component ROM is
    port 
    (
        clk : in std_logic;
        addr : in std_logic_vector(3 downto 0);
        rdata : out std_logic_vector(3 downto 0)
    );
end component;

component micro_code is
    port 
    (
        clk : in std_logic;
        reset : in std_logic;
        instr : in std_logic_vector(3 downto 0);
        en_IR : out std_logic;
        en_OP : out std_logic;
        en_A : out std_logic;
        en_PC : out std_logic;
        inc_PC : out std_logic;
        fn : out std_logic_vector(1 downto 0);
        flag : in std_logic
    );
end component;

component hex_encoder is
    port 
    (
        binary : in std_logic_vector(3 downto 0);
        HEX : out std_logic_vector(6 downto 0)
    );
end component;

component z_flag is
    port (
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic;
        Q      : out std_logic
    );
end component;

signal s_IR : std_logic;
signal s_OP : std_logic;
signal s_A : std_logic;
signal s_PC : std_logic;
signal s_inc_PC : std_logic;
signal s_fn : std_logic_vector(1 downto 0);
signal s_eq : std_logic;
signal s_flag : std_logic;
signal s_instr : std_logic_vector(3 downto 0);
signal s_oper : std_logic_vector(3 downto 0);
signal s_acc : std_logic_vector(3 downto 0);
signal s_alu : std_logic_vector(3 downto 0);
signal data : std_logic_vector(3 downto 0);
signal addr : std_logic_vector(3 downto 0);

begin

IR: reg port map(GPIO(0), s_IR, data, s_instr);
OP: reg port map(GPIO(0), s_OP, data, s_oper);
A: reg port map(GPIO(0), s_A, s_alu, s_acc);
PC: inc_reg port map(GPIO(0), SW(0), s_inc_PC, s_PC, data, addr);
ALU1: ALU port map(s_fn, s_oper, s_acc, s_alu, s_eq);
ROM1: ROM port map(GPIO(0), addr, data);
FSM1: micro_code port map(GPIO(0), SW(0), s_instr, s_IR, s_OP, s_A, s_PC, s_inc_PC, s_fn, s_flag);

-- Z-flag port map
ZFLAG: z_flag port map(GPIO(0), s_A, s_eq, s_flag);

HD1: hex_encoder port map(s_acc, HEX0(6 downto 0));
HD2: hex_encoder port map(s_alu, HEX1(6 downto 0));
HD3: hex_encoder port map(s_oper, HEX2(6 downto 0));
HD4: hex_encoder port map(s_instr, HEX3(6 downto 0));
HD5: hex_encoder port map(data, HEX4(6 downto 0));
HD6: hex_encoder port map(addr, HEX5(6 downto 0));

LEDR(0) <= s_A;
LEDR(1) <= s_OP;
LEDR(2) <= s_IR;
LEDR(3) <= s_PC;
LEDR(4) <= s_inc_PC;
LEDR(5) <= s_fn(0);
LEDR(6) <= s_fn(1);
LEDR(7) <= s_eq;
LEDR(8) <= s_flag; -- Z-flag output

end structural;

-- Z-Flag D Flip-Flop

library ieee;
use ieee.std_logic_1164.all;

entity z_flag is
    port (
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic;
        Q      : out std_logic
    );
end entity;

architecture behavioral of z_flag is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behavioral;

-- HEX display encoder

library ieee;
use ieee.std_logic_1164.all;

entity hex_encoder is
    port 
    (
        binary : in std_logic_vector(3 downto 0);
        HEX : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of hex_encoder is

begin

    process(binary)
    begin
        case binary is
            when "0000" => HEX <= "1000000";
            when "0001" => HEX <= "1111001";
            when "0010" => HEX <= "0100100";
            when "0011" => HEX <= "0110000";
            when "0100" => HEX <= "0011001";
            when "0101" => HEX <= "0010010";
            when "0110" => HEX <= "0000010";
            when "0111" => HEX <= "1111000";
            when "1000" => HEX <= "0000000";
            when "1001" => HEX <= "0011000";
            when "1010" => HEX <= "0001000";
            when "1011" => HEX <= "0000011";
            when "1100" => HEX <= "1000110";
            when "1101" => HEX <= "0100001";
            when "1110" => HEX <= "0000110";
            when "1111" => HEX <= "0001110";
        end case;
    end process;

end behavioral;

-- Register

library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port 
    (
        clk : in std_logic;
        enable : in std_logic;
        D : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioral of reg is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;

end behavioral;

-- Incrementing Register

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity inc_reg is
    port 
    (
        clk : in std_logic;
        reset : in std_logic;
        inc : in std_logic;
        enable : in std_logic;
        D : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioral of inc_reg is

    signal sig_Q : std_logic_vector(3 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            sig_Q <= "0000";
        elsif rising_edge(clk) then
            if enable = '1' then
                sig_Q <= D;
            elsif inc = '1' then
                sig_Q <= sig_Q + '1';
            end if;
        end if;
    end process;
    
    Q <= sig_Q;

end behavioral;

-- ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
    port 
    (
        fn : in std_logic_vector(1 downto 0);
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        equal : out std_logic
    );
end entity;

architecture behavioral of ALU is

begin

    process(fn, A, B)
    begin
        case fn is
            when "00" => Q <= A;  -- port A is the operand register
            when "01" => Q <= B;  -- port B is the accumulator register
            when "10" => Q <= A + B;
            when "11" => Q <= NOT A;  -- the CPU only issues 3 functions,
        end case;
        if A = B then
            equal <= '1';
        else
            equal <= '0';
        end if;
    end process;        

end behavioral;

-- Finite state machine

library ieee;
use ieee.std_logic_1164.all;

entity micro_code is
    port 
    (
        clk : in std_logic;
        reset : in std_logic;
        instr : in std_logic_vector(3 downto 0);
        en_IR : out std_logic;
        en_OP : out std_logic;
        en_A : out std_logic;
        en_PC : out std_logic;
        inc_PC : out std_logic;
        fn : out std_logic_vector(1 downto 0);
        flag : in std_logic
    );
end entity;

architecture behavioral of micro_code is

    type state_type is (
        rst, fetch_in, fetch_pc, decode, fetch_op, 
        load_acc, add_acc, cmp_acc, test_flag, incr_pc
    );
    signal state : state_type;

    attribute syn_encoding : string;
    attribute syn_encoding of state_type : type is "safe";

begin

    -- State transition process
    process(clk, reset)
    begin
        if reset = '1' then
            state <= rst;
        elsif rising_edge(clk) then
            case state is
                when rst =>
                    state <= fetch_in;

                when fetch_in =>
                    state <= decode;

                when decode =>
                    case instr is
                        when "1101" => -- LDA
                            state <= fetch_op;
                        when "1000" => -- ADDA
                            state <= fetch_op;
                        when "1100" => -- CMPA
                            state <= fetch_op;
                        when "0100" => -- BRA
                            state <= fetch_pc;
                        when "0001" => -- BEQ
                            state <= test_flag;
                        when others =>
                            state <= rst;
                    end case;

                when fetch_op =>
                    case instr is
                        when "1101" => -- LDA
                            state <= load_acc;
                        when "1000" => -- ADDA
                            state <= add_acc;
                        when "1100" => -- CMPA
                            state <= cmp_acc;
                       when others =>
                           state <= rst;
                    end case;

                when load_acc =>
                    state <= fetch_in;

                when add_acc =>
                    state <= fetch_in;

                when cmp_acc =>
                    state <= fetch_in;

                when fetch_pc =>
                    state <= fetch_in;

                when test_flag =>
                    if flag = '1' then
                        state <= fetch_pc;
                    else
                        state <= incr_pc;
                    end if;

                when incr_pc =>
                    state <= fetch_in;

                when others =>
                    state <= rst;
            end case;
        end if;
    end process;

    -- Output logic process
    process(state)
    begin
        -- Default outputs
--        en_IR   <= '0';
--        en_OP   <= '0';
--        en_A    <= '0';
--        en_PC   <= '0';
--        inc_PC  <= '0';
--        fn      <= "00";

        case state is
            when rst =>
			en_IR   <= '0';
        en_OP   <= '0';
        en_A    <= '0';
        en_PC   <= '0';
        inc_PC  <= '0';
        fn      <= "00";
		  
            when fetch_in =>
                en_IR   <= '1';
					 en_op	<= '0';
					 en_A		<= '0';
					 en_PC	<= '0';
                inc_PC  <= '1';
					 fn <= "00";

            when decode =>
                en_IR   <= '0';
					 en_op	<= '0';
					 en_A		<= '0';
					 en_PC	<= '0';
                inc_PC  <= '0';
					 fn <= "00";

            when fetch_op =>
                en_IR   <= '0';
                en_OP   <= '1';
					 en_A		<= '0';
					 en_PC	<= '0';
                inc_PC  <= '1';
					 fn <= "00";
            when load_acc =>
                en_IR   <= '0';
					 en_op	<= '0';
                en_A    <= '1';
					 en_PC	<= '0';
                inc_PC  <= '0';
					 fn <= "00";
            when add_acc =>
                en_IR   <= '0';
					 en_op	<= '0';
                en_A    <= '1';
					 en_PC	<= '0';
                inc_PC  <= '0';
                fn      <= "10";

            when cmp_acc =>
                en_IR   <= '0';
					 en_op	<= '0';
					 en_A		<= '1';
					 en_PC	<= '0';
                inc_PC  <= '0';
					 fn <= "01";
            when fetch_pc =>
                en_IR   <= '0';
					 en_op	<= '0';
					 en_A		<= '0';
                en_PC   <= '1';
					 inc_PC	<= '0';
					 fn <= "00";

            when test_flag =>
			en_IR   <= '0';
        en_OP   <= '0';
        en_A    <= '0';
        en_PC   <= '0';
        inc_PC  <= '0';
        fn      <= "00";

            when incr_pc =>
				en_IR   <= '0';
				en_OP   <= '0';
				en_A    <= '0';
				en_PC   <= '0';
            inc_PC  <= '1';
				fn <= "00";

            when others =>
			en_IR   <= '0';
        en_OP   <= '0';
        en_A    <= '0';
        en_PC   <= '0';
        inc_PC  <= '0';
        fn      <= "00";
                null;
        end case;
    end process;

end behavioral;

-- ROM

library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port 
    (
        clk : in std_logic;
        addr : in std_logic_vector(3 downto 0);
        rdata : out std_logic_vector(3 downto 0)
    );
end entity;



architecture behavioral of ROM is
begin
process(addr)
begin
    case addr is
                                                when "0000" => rdata <= "1101";
                                                when "0001" => rdata <= "0100";
                                                when "0010" => rdata <= "1000";
                                                when "0011" => rdata <= "0001";
                                                when "0100" => rdata <= "1100";
                                                when "0101" => rdata <= "1001";
                                                when "0110" => rdata <= "0001";
                                                when "0111" => rdata <= "1010";
                                                when "1000" => rdata <= "0100";
                                                when "1001" => rdata <= "0010";
                                                when "1010" => rdata <= "1101";
                                                when "1011" => rdata <= "0010";
                                                when "1100" => rdata <= "1000";
                                                when "1101" => rdata <= "0011";
                                                when "1110" => rdata <= "0100";
                                                when "1111" => rdata <= "1100";
                                end case;

end process;
end behavioral;
