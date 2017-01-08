with Ada.Interrupts.Names;
with Ada.Real_Time;     use Ada.Real_Time;
with STM32;             use STM32;
with STM32.Registers;   use STM32.Registers;
with STM32.GPIO;        use STM32.GPIO;

package body STM32.Button is

   protected Button is
      pragma Interrupt_Priority;

      function Current_Direction return Directions;

   private
      procedure Interrupt_Handler;
      pragma Attach_Handler
         (Interrupt_Handler,
          Ada.Interrupts.Names.EXTI0_Interrupt);

      Direction : Directions := Clockwise;  -- arbitrary
      Last_Time : Time := Clock;
   end Button;

   Debounce_Time : constant Time_Span := Milliseconds (500);

   protected body Button is

      function Current_Direction return Directions is
      begin
         return Direction;
      end Current_Direction;

      procedure Interrupt_Handler is
         Now : constant Time := Clock;
      begin
         --  Clear interrupt
         EXTI.PR (0) := 1;

         --  Debouncing
         if Now - Last_Time >= Debounce_Time then
            if Direction = Counterclockwise then
               Direction := Clockwise;
            else
               Direction := Counterclockwise;
            end if;

            Last_Time := Now;
         end if;
      end Interrupt_Handler;

   end Button;

   function Current_Direction return Directions is
   begin
      return Button.Current_Direction;
   end Current_Direction;

   procedure Initialize is
      RCC_AHB1ENR_GPIOA : constant Word := 16#01#;
   begin
      --  Enable clock for GPIO-A
      RCC.AHB1ENR := RCC.AHB1ENR or RCC_AHB1ENR_GPIOA;

      --  Configure PA0
      GPIOA.MODER (0) := Mode_IN;
      GPIOA.PUPDR (0) := No_Pull;

      --  Select PA for EXTI0
      SYSCFG.EXTICR1 (0) := 0;

      --  Interrupt on rising edge
      EXTI.FTSR (0) := 0;
      EXTI.RTSR (0) := 1;
      EXTI.IMR (0) := 1;
   end Initialize;

begin
   Initialize;
end STM32.Button;
