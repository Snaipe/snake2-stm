pragma Restrictions (No_Elaboration_Code);

with Interfaces;

package STM32 is

   type Word      is new Interfaces.Unsigned_32;  -- for shift/rotate
   type Half_Word is new Interfaces.Unsigned_16;  -- for shift/rotate
   type Byte      is new Interfaces.Unsigned_8;   -- for shift/rotate

   type Bits_1  is mod 2**1 with Size => 1;
   type Bits_2  is mod 2**2 with Size => 2;
   type Bits_4  is mod 2**4 with Size => 4;

   type Bits_32x1 is array (0 .. 31) of Bits_1 with Pack, Size => 32;
   type Bits_16x2 is array (0 .. 15) of Bits_2 with Pack, Size => 32;
   type Bits_8x4  is array (0 ..  7) of Bits_4 with Pack, Size => 32;

   --  Define address bases for the various system components

   Peripheral_Base : constant := 16#4000_0000#;

   APB1_Peripheral_Base : constant := Peripheral_Base;
   APB2_Peripheral_Base : constant := Peripheral_Base + 16#0001_0000#;
   AHB1_Peripheral_Base : constant := Peripheral_Base + 16#0002_0000#;
   AHB2_Peripheral_Base : constant := Peripheral_Base + 16#1000_0000#;

   GPIOA_Base           : constant := AHB1_Peripheral_Base + 16#0000#;
   GPIOB_Base           : constant := AHB1_Peripheral_Base + 16#0400#;
   GPIOC_Base           : constant := AHB1_Peripheral_Base + 16#0800#;
   GPIOD_Base           : constant := AHB1_Peripheral_Base + 16#0C00#;
   GPIOG_Base           : constant := AHB1_Peripheral_Base + 16#1800#;

   FLASH_Base           : constant := AHB1_Peripheral_Base + 16#3C00#;
   RCC_Base             : constant := AHB1_Peripheral_Base + 16#3800#;

   PWR_Base             : constant := APB1_Peripheral_Base + 16#7000#;

   USART1_Base          : constant := APB2_Peripheral_Base + 16#1000#;
   SYSCFG_Base          : constant := APB2_Peripheral_Base + 16#3800#;
   EXTI_Base            : constant := APB2_Peripheral_Base + 16#3C00#;

end STM32;
