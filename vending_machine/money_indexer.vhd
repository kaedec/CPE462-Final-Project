LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.vending_machine_package.ALL;

ENTITY money_indexer IS

	PORT(input: IN NATURAL RANGE 0 TO 999;
			out_h, out_t, out_o: OUT NATURAL RANGE 0 TO 10);
END money_indexer;

ARCHITECTURE money_indexer_arch OF money_indexer IS
BEGIN
	out_h <= input MOD 1000 / 100;
	out_t <= input MOD 100 / 10;
	out_o <= input MOD 10 / 1;
END money_indexer_arch;