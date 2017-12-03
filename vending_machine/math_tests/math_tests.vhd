LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY math_tests IS
END math_tests;

ARCHITECTURE math_tests_arch OF math_tests IS
BEGIN
PROCESS
BEGIN
--  REPORT "145 			 / 100	= " & integer'image(145 mod 1000 / 100);
--  REPORT "145 mod 100 / 10		= " & INTEGER'IMAGE(145 mod 100 / 10);
--  REPORT "145 mod 10 			= " & INTEGER'IMAGE(145 mod 10 / 1);
--  REPORT " 85 			 / 100	= " & INTEGER'IMAGE(85 mod 1000 / 100);
--  REPORT " 85 mod 100 / 10		= " & INTEGER'IMAGE(85 mod 100 / 10);
--  REPORT " 85 mod 10				= " & INTEGER'IMAGE(85 mod 10 / 1);
--  REPORT "195			 / 100	= " & INTEGER'IMAGE(195 mod 1000 / 100);
--  REPORT "195 mod 100 / 10		= " & INTEGER'IMAGE(195 mod 100 / 10);
--  REPORT "195 mod 10				= " & INTEGER'IMAGE(195 mod 10 / 1);
--  REPORT "135			 / 100	= " & INTEGER'IMAGE(135 mod 1000/ 100);
--  REPORT "135 mod 100 / 10		= " & INTEGER'IMAGE(135 mod 100 / 10);
--  REPORT "135 mod 10				= " & INTEGER'IMAGE(135 mod 10 / 1);


--https://stackoverflow.com/a/25850139
  report "  9  mod   5  = " & integer'image(9 mod 5);
  report "  9  rem   5  = " & integer'image(9 rem 5);
  report "  9  mod (-5) = " & integer'image(9 mod (-5));
  report "  9  rem (-5) = " & integer'image(9 rem (-5));
  report "(-9) mod   5  = " & integer'image((-9) mod 5);
  report "(-9) rem   5  = " & integer'image((-9) rem 5);
  report "(-9) mod (-5) = " & integer'image((-9) mod (-5));
  report "(-9) rem (-5) = " & integer'image((-9) rem (-5));
END PROCESS;
END math_tests_arch;