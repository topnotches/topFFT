LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE std.textio.ALL;

ENTITY Euler IS
    GENERIC (

        bits : INTEGER RANGE 2 TO 14 := 14

    );
    PORT (

        pClk : IN STD_LOGIC;
        pAddr : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
        ps18Real : OUT signed(17 DOWNTO 0);
        ps18Imag : OUT signed(17 DOWNTO 0)

    );
END Euler;

ARCHITECTURE rtl OF Euler IS
    TYPE as18Euler_t IS ARRAY(0 TO 2 ** bits - 1) OF signed(17 DOWNTO 0);

    IMPURE FUNCTION initRom(lReal : STD_LOGIC := '1') RETURN as18Euler_t IS

        FILE fRealROM : text OPEN read_mode IS "Real.txt";
        FILE fImagROM : text OPEN read_mode IS "Imag.txt";
        VARIABLE vTextLine : line;
        VARIABLE vTmp : as18Euler_t := (OTHERS => (OTHERS => '0'));

    BEGIN

        FOR i IN 0 TO 2 ** bits - 1 LOOP

            IF lReal = '1' THEN

                readline(fRealROM, vTextLine);
                bread(vTextLine, vTmp(i));

            ELSE

                readline(fImagROM, vTextLine);
                bread(vTextLine, vTmp(i));

            END IF;

        END LOOP;

        RETURN vTmp;

    END FUNCTION;

    SIGNAL sas18RealROM : as18Euler_t := initROM('1');
    SIGNAL sas18ImagROM : as18Euler_t := initROM('0');

BEGIN

    PROCESS (pClk)

    BEGIN

        IF rising_edge(pClk) THEN

            ps18Real <= sas18RealROM(pAddr);
            ps18Real <= sas18ImagROM(pAddr);

        END IF;

    END PROCESS;

END rtl;