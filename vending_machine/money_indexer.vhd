LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.vending_machine_package.ALL;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--This is a simple component that accepts 1 3-digit (base 10) number as an
--input and outputs those digits as 3 separate 1-digit (base 10) numbers.
--This is used for the 7-segment displays in the main code.
--
--The function used for the SSDs was modified to take an input of 10, and
--display that as a dash for idle state and when invalid coins are inserted.
--
--In the main code, the value that is passed to this function is assigned a
--999 whenever a dash is desired to be displayed; if the input is not 999,
--then it performs its usual function as an "indexer" into the integers.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
ENTITY money_indexer IS

	PORT(input: IN INTEGER RANGE 0 TO 999;
			out_h, out_t, out_o: OUT NATURAL RANGE 0 TO 10);
END money_indexer;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ARCHITECTURE money_indexer_arch OF money_indexer IS
BEGIN

	out_h <= 10 WHEN (input=999) ELSE
				input MOD 1000 / 100;

	out_t <= 10 WHEN (input=999) ELSE
				input MOD 100 / 10;

	out_o <= 10 WHEN (input=999) ELSE
				input MOD 10 / 1;

END money_indexer_arch;