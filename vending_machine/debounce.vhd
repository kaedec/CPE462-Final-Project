LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--This is a simple component that accepts a push button input and the clock
--and outputs the debounced form of the push button.  This is used for
--the 3 push buttons used in the project.
--
--The switches on the FPGA are not quite fully debounced, so this code had
--to be written.  It uses a 10ms timer that is always incrementing.  The
--counter resets to 0 if there is a change in the push button signal (it
--is still "bouncing").  After 10ms of no change, the debounced signal
--takes on the value of the real button's.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
ENTITY debounce IS

	PORT(btn, clk: IN STD_LOGIC;
			debounced: OUT STD_LOGIC);
END debounce;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ARCHITECTURE debounce_arch OF debounce IS

SIGNAL slow_clk: STD_LOGIC := '0';
CONSTANT divider: INTEGER := 250000; --100Hz (10ms)

BEGIN

PROCESS(clk, btn)

VARIABLE clk_count: INTEGER := 0;
VARIABLE clk_check: STD_LOGIC := '0';
VARIABLE old_btn: STD_LOGIC := '1';

BEGIN
	IF (btn /= old_btn) THEN
		clk_count := 0;
		old_btn := btn;
	ELSE
		IF(clk'EVENT AND clk='1') THEN
		clk_count := clk_count + 1;
			IF(clk_count = divider AND btn = old_btn) THEN
				debounced <= btn;
			END IF;
		END IF;
	END IF;
END PROCESS;

END debounce_arch;