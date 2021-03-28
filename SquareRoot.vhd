LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY root IS

    PORT (
        pClk : IN STD_LOGIC;
        ps48Num : IN unsigned(48 DOWNTO 0);
        ps48Res : OUT unsigned(17 DOWNTO 0);
        plDone : OUT STD_LOGIC
        );
END root;

ARCHITECTURE rtl OF root IS

    TYPE states_t IS (Idle, Pull, Check, Done);
    ATTRIBUTE enum_encoding : STRING;
    ATTRIBUTE enum_encoding OF states_t : TYPE IS "00 01 11 10";

    SIGNAL state : states_t := Idle;
    SIGNAL ss48Num : unsigned(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ss48ResTmp : unsigned(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ss48Rest : unsigned(47 DOWNTO 0) := (OTHERS => '0');

    SIGNAL siBitSel : INTEGER RANGE 0 TO 47;
    SIGNAL ss48Checker : unsigned(47 DOWNTO 0) := (OTHERS => '0');

BEGIN

    ss48Checker <= ss48ResTmp(ss48ResTmp'length - 3 DOWNTO 0) & unsigned("01");

    PROCESS (pClk)
    BEGIN
        IF Rising_Edge(pClk) THEN
            CASE state IS
                WHEN Idle =>

                    IF ps48Num /= ss48Num THEN

                        ss48ResTmp <= (OTHERS => '0');
                        ss48Rest <= (OTHERS => '0');
                        ss48Num <= ps48Num;
                        state <= Idle;
                        plDone <= '0';
                        siBitSel <= 46;

                    END IF;

                WHEN Pull =>

                    ss48Rest <= ss48Rest(ss48Rest'length - 3 DOWNTO 2) & ss48Num(siBitSel + 1 DOWNTO siBitSel);
                    state <= check;

                WHEN Check =>



                    IF ss48Checker <= ss48Rest THEN

                        ss48ResTmp <= ss48ResTmp(ss48ResTmp'length - 1 DOWNTO 1) & '1';
                        ss48Rest <= ss48Rest - ss48Checker;
                        
                    ELSE

                        ss48ResTmp <= ss48ResTmp(ss48ResTmp'length - 1 DOWNTO 1) & '0';

                    END IF;

                    IF siBitSel = 0 THEN

                        plDone <= '1';
                        ps48Res <= ss48ResTmp;
                        state <= Done;

                    ELSE

                        siBitSel <= siBitSel - 2;
                        state <= Check;

                    END IF;

                WHEN Done =>

                    state <= Idle;

            END CASE;
        END IF;
    END PROCESS;
END rtl;
