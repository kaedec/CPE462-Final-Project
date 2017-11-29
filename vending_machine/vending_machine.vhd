LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.vending_machine_package.ALL;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITY vending_machine IS

	PORT(product_select: IN STD_LOGIC_VECTOR(17 DOWNTO 16);
		  coin_select: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  choose_product: IN STD_LOGIC;
		  choose_coin: IN STD_LOGIC;
		  reset: IN STD_LOGIC;
		  clock_50MHz: IN STD_LOGIC;
		  product_delivery: OUT STD_LOGIC;
		  p_name_abbrv: OUT STD_LOGIC_VECTOR(0 TO 6);
		  coin_display2, coin_display1, coin_display0: OUT STD_LOGIC_VECTOR(0 TO 6));
END vending_machine;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ARCHITECTURE vending_machine_arch OF vending_machine IS
--DECLARATIONS

--Product Information
CONSTANT product_list: PRODUCT_ARRAY := (

	Pepsi => ("00", 'P', 145),
	Gum => ("01", 'G', 85),
	Coffee => ("10", 'C', 195),
	Water => ("11", 'b', 135)

);
	
--Debounced Push Buttons
SIGNAL db_choose_product, db_choose_coin, db_reset: STD_LOGIC;

--State machines
SIGNAL machine_state: MCH_STATE;
SIGNAL product_state: PROD_STATE;
SIGNAL coin_state: C_STATE;

--Previous values for push buttons
SIGNAL old_choose_product, old_choose_coin: STD_LOGIC := '0';

--Costs
SIGNAL cost_amt: NATURAL RANGE 85 TO 195 := 85;
-------------------------------------------------------------------------------
--BEHAVIOR

BEGIN

--Debounce the push buttons
key3: debounce PORT MAP (choose_product, clock_50MHz, db_choose_product);
key2: debounce PORT MAP (choose_coin, clock_50MHz, db_choose_coin);
key0: debounce PORT MAP (reset, clock_50MHz, db_reset);
-------------------------------------------------------------------------------

PROCESS(clock_50MHz, reset)

BEGIN

IF(reset = '0') THEN
	machine_state <= Idle;
ELSIF(RISING_EDGE(clock_50MHz)) THEN
	
	old_choose_product <= db_choose_product;	--These two are used as dummies because
	old_choose_coin <= db_choose_coin;			--we cannot have signals depend on two "clock" 'EDGES
	

END IF;

END PROCESS;
-------------------------------------------------------------------------------
--p_name_abbrv <= dispSSD();
--coin_display2 <= dispSSD();
--coin_display1 <= dispSSD();
--coin_display0 <= dispSSD();
-------------------------------------------------------------------------------
END vending_machine_arch;