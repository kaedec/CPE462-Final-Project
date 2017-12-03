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

--Clock Information
CONSTANT divider: INTEGER := 25000000; --1 second clock

--Product Information
--PRODUCT_SELECT, ABBREVIATION, PRICE
CONSTANT Pepsi: PRODUCT_INFO :=
	("00", 'P', 145);
CONSTANT Gum: PRODUCT_INFO :=
	("01", 'G', 85);
CONSTANT Coffee: PRODUCT_INFO :=
	("10", 'C', 195);
CONSTANT Water: PRODUCT_INFO :=
	("11", 'b', 135);

--Debounced Push Buttons
SIGNAL db_choose_product, db_choose_coin, db_reset: STD_LOGIC;

--State machines
SIGNAL machine_state: MCH_STATE;
SIGNAL product_state: PROD_STATE;
SIGNAL coin_state: C_STATE;

--Previous values for push buttons
SIGNAL old_choose_product, old_choose_coin, old_reset: STD_LOGIC := '0';

--Costs
SIGNAL cost_amt: NATURAL RANGE 85 TO 195 := 85;
SIGNAL paid_amt: INTEGER RANGE 0 TO 999 := 0;
SIGNAL return_amt: INTEGER RANGE 0 TO 999 := 0;
SIGNAL price_disp: INTEGER RANGE 0 TO 999 := 0;

--Hex Display Signals
SIGNAL hex5: CHARACTER;
SIGNAL hex2, hex1, hex0: NATURAL RANGE 0 TO 10;

--Product Delivery LED
SIGNAL dLed: STD_LOGIC := '0';
-------------------------------------------------------------------------------
--BEHAVIOR

BEGIN

--Debounce the push buttons
key3: debounce PORT MAP (choose_product, clock_50MHz, db_choose_product);
key2: debounce PORT MAP (choose_coin, clock_50MHz, db_choose_coin);
key0: debounce PORT MAP (reset, clock_50MHz, db_reset);

--Index into price for display
indexing: money_indexer PORT MAP (price_disp, hex2, hex1, hex0);

-------------------------------------------------------------------------------

PROCESS(clock_50MHz, reset)

--For time counting
VARIABLE count: NATURAL := 0;
VARIABLE delivery_count: NATURAL := 0;

VARIABLE temp_price_disp: INTEGER RANGE 0 TO 999 := 0;
VARIABLE transaction_time: STD_LOGIC := '0';

BEGIN

IF(RISING_EDGE(clock_50MHz)) THEN
	
	old_choose_product <= db_choose_product;	--These are used as dummies because we
	old_choose_coin <= db_choose_coin;			--cannot have signals depend on two "clock" 'EDGES
	old_reset <= db_reset;
	
	cASE machine_state IS
-------------------------------------------------------------------------------
		WHEN Idle =>
		
			paid_amt <= 0;
			
			IF(button_pressed(old_choose_product, db_choose_product)) THEN
				CASE product_select IS
					WHEN Pepsi.product_select =>
						hex5 <= Pepsi.abbreviation;
						cost_amt <= Pepsi.price;
						price_disp <= Pepsi.price;

					WHEN Gum.product_select =>
						hex5 <= Gum.abbreviation;
						cost_amt <= Gum.price;
						price_disp <= Gum.price;

					WHEN Coffee.product_select =>
						hex5 <= Coffee.abbreviation;
						cost_amt <= Coffee.price;
						price_disp <= Coffee.price;

					WHEN Water.product_select =>
						hex5 <= Water.abbreviation;
						cost_amt <= Water.price;
						price_disp <= Water.price;

				END CASE;
				machine_state <= UserTransaction;
			ELSE
				hex5 <= 'I';
				price_disp <= 999;
			END IF;
-------------------------------------------------------------------------------
		WHEN Cancel =>
			count := count+1;
			
			price_disp <= paid_amt;
			
			IF(count = divider*10) THEN
				count := 0;
				machine_state <= Idle;
			END IF;
-------------------------------------------------------------------------------
		WHEN UserTransaction =>
		
			IF(button_pressed(old_reset, db_reset)) THEN
				machine_state <= Cancel;
			END IF;
			
			IF(paid_amt >= cost_amt) THEN
				machine_state <= Delivery;
			END IF;
			
			IF(button_pressed(old_choose_coin, db_choose_coin)) THEN
				CASE coin_select IS
				
					WHEN "00" => -- Invalid
						IF(price_disp /= 999) THEN
							temp_price_disp := price_disp;
							price_disp <= 999;
							transaction_time := '1';
						END IF;
						
					WHEN "01" => -- Dime
						paid_amt <= paid_amt + 10;
						price_disp <= price_disp - 10;
						
					WHEN "10" => -- Qaurter
						paid_amt <= paid_amt + 25;
						price_disp <= price_disp - 25;
						
					WHEN "11" => -- Dollar
						paid_amt <= paid_amt + 100;
						price_disp <= price_disp - 100;
						
				END CASE;
				
			END IF;
			
			IF(transaction_time = '1') THEN
				count := count+1;
				IF(count = divider*10) THEN
					count := 0;
					price_disp <= temp_price_disp;
					transaction_time := '0';
				END IF;
			END IF;
-------------------------------------------------------------------------------
		WHEN Delivery =>
			
			price_disp <= paid_amt - cost_amt;
			
			count := count+1;
			IF(count=divider*2) THEN
			
				dLed <= NOT dLed;
				count := 0;
				delivery_count := delivery_count+1;
				
				IF(delivery_count=10) THEN
					delivery_count := 0;
					
					machine_state <= Idle;
				END IF;
			END IF;
-------------------------------------------------------------------------------
	END CASE;

END IF;

END PROCESS;
-------------------------------------------------------------------------------
--Concurrent output declarations
p_name_abbrv <= dispSSD_A(hex5);
coin_display2 <= dispSSD(hex2);
coin_display1 <= dispSSD(hex1);
coin_display0 <= dispSSD(hex0);
product_delivery <= dLed;
-------------------------------------------------------------------------------
END vending_machine_arch;