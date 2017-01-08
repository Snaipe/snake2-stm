with Ada.Unchecked_Conversion;

with STM32.Registers;   use STM32.Registers;
with STM32.GPIO;        use STM32.GPIO;

package body STM32.LEDs is

   function As_Word is new Ada.Unchecked_Conversion
     (Source => User_LED, Target => Word);

   procedure On (This : User_LED) is
   begin
      GPIOG.BSRR := As_Word (This);
   end On;

   procedure Off (This : User_LED) is
   begin
      GPIOG.BSRR := Shift_Left (As_Word (This), 16);
   end Off;

   procedure Toggle (This : User_LED) is
   begin
      GPIOG.ODR := GPIOG.ODR xor As_Word (This);
   end Toggle;

   All_LEDs_On  : constant Word := Green'Enum_Rep or Red'Enum_Rep;

   pragma Compile_Time_Error
     (All_LEDs_On /= 16#6000#,
      "Invalid representation for All_LEDs_On");

   All_LEDs_Off : constant Word := Shift_Left (All_LEDs_On, 16);

   procedure All_Off is
   begin
      GPIOG.BSRR := All_LEDs_Off;
   end All_Off;

   procedure All_On is
   begin
      GPIOG.BSRR := All_LEDs_On;
   end All_On;

   procedure Initialize is
      RCC_AHB1ENR_GPIOG : constant Word := 16#40#;
   begin
      --  Enable clock for GPIO-G
      RCC.AHB1ENR := RCC.AHB1ENR or RCC_AHB1ENR_GPIOG;

      --  Configure PG13-14
      GPIOG.MODER   (13 .. 14) := (others => Mode_OUT);
      GPIOG.OTYPER  (13 .. 14) := (others => Type_PP);
      GPIOG.OSPEEDR (13 .. 14) := (others => Speed_50MHz);
      GPIOG.PUPDR   (13 .. 14) := (others => Pull_Up);
   end Initialize;

begin
   Initialize;
end STM32.LEDs;
