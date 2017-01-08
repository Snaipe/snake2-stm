with System;

package STM32.Last_Chance_Handler is

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer);
   pragma Export (C, Last_Chance_Handler, "__gnat_last_chance_handler");
   pragma No_Return (Last_Chance_Handler);
   pragma Weak_External (Last_Chance_Handler);

end STM32.Last_Chance_Handler;
