LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
PACKAGE vending_machine_package IS
-------------------------------------------------------------------------------
--States; real-world names for easy understanding
	TYPE MCH_STATE IS (Idle, Cancel, UserTransaction, Delivery);
-------------------------------------------------------------------------------
	TYPE PROD_STATE IS (Pepsi, Gum, Coffee, Water);
-------------------------------------------------------------------------------
	TYPE C_STATE IS (Dime, Quarter, Dollar);
-------------------------------------------------------------------------------
--Record Information
--Records are similar to structs in C or dictionaries in Python
	TYPE PRODUCT_INFO IS RECORD
		Product_Select: STD_LOGIC_VECTOR(17 DOWNTO 16);
		Abbreviation: CHARACTER;
		Price: NATURAL RANGE 85 TO 195;
	END RECORD;
-------------------------------------------------------------------------------
--	TYPE PRODUCT_ARRAY IS ARRAY (PROD_STATE) OF PRODUCT_INFO;
-------------------------------------------------------------------------------
--Used for debouncing switches
	COMPONENT debounce IS
		PORT(btn, clk: IN STD_LOGIC;
				debounced: OUT STD_LOGIC);
	END COMPONENT;
-------------------------------------------------------------------------------
	COMPONENT money_indexer IS
		PORT(input: IN NATURAL RANGE 0 TO 999;
			out_h, out_t, out_o: OUT NATURAL RANGE 0 TO 10);
	END COMPONENT;
-------------------------------------------------------------------------------
--Seven-Segment Display logic
	FUNCTION dispSSD (SIGNAL S: NATURAL) RETURN STD_LOGIC_VECTOR;
-------------------------------------------------------------------------------
	FUNCTION dispSSD_A (SIGNAL S: CHARACTER) RETURN STD_LOGIC_VECTOR;
-------------------------------------------------------------------------------
--Custom edge checker w/o 'EDGE attribute, also checks for ='0' because these
--push buttons are all active low
	FUNCTION button_pressed (SIGNAL old_btn, btn: STD_LOGIC) RETURN BOOLEAN;
-------------------------------------------------------------------------------
END vending_machine_package;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
PACKAGE BODY vending_machine_package IS
-------------------------------------------------------------------------------
	FUNCTION dispSSD (SIGNAL S: NATURAL) RETURN STD_LOGIC_VECTOR IS
	
	VARIABLE F: STD_LOGIC_VECTOR(0 TO 6);
	
	BEGIN
	
	CASE S IS
		WHEN 0 => F := "0000001";
		WHEN 1 => F := "1001111";
		WHEN 2 => F := "0010010";
		WHEN 3 => F := "0000110";
		WHEN 4 => F := "1001100";
		WHEN 5 => F := "0100100";
		WHEN 6 => F := "0100000";
		WHEN 7 => F := "0001111";
		WHEN 8 => F := "0000000";
		WHEN 9 => F := "0000100";
		WHEN 10 => F := "1111110";
		WHEN OTHERS => F := "0110110";
	END CASE;
	
	RETURN F;
	END FUNCTION dispSSD;
-------------------------------------------------------------------------------
	FUNCTION dispSSD_A (SIGNAL S: CHARACTER) RETURN STD_LOGIC_VECTOR IS

	VARIABLE F: STD_LOGIC_VECTOR(0 TO 6);
	
	BEGIN
	
	CASE S IS
		WHEN 'P' => F := "0011000";
		WHEN 'G' => F := "0100000";
		WHEN 'C'	=> F := "0110001";
		WHEN 'b' => F := "1100000";
		WHEN 'I' => F := "1111110";
		WHEN OTHERS => F := "0110110";
	END CASE;
	
	RETURN F;
	END FUNCTION dispSSD_A;
-------------------------------------------------------------------------------
	FUNCTION button_pressed (SIGNAL old_btn, btn: STD_LOGIC) RETURN BOOLEAN IS
	
	BEGIN
	
	IF (old_btn /= btn AND btn='0') THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
	
	END FUNCTION button_pressed;
-------------------------------------------------------------------------------
END vending_machine_package;