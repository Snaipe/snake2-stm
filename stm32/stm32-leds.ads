with STM32;  use STM32;

package STM32.LEDs is
   pragma Elaborate_Body;

   type User_LED is (Green, Red);

   for User_LED use
     (Green  => 16#2000#,
      Red    => 16#4000#);

   --  As a result of the representation clause, avoid iterating directly over
   --  the type since that will require an implicit lookup in the generated 
   --  code of the loop.  Such usage seems unlikely so this direct 
   --  representation is reasonable, and efficient.

   for User_LED'Size use Word'Size;
   --  we convert the LED values to Word values in order to write them to
   --  the register, so the size must be the same

   LED3 : User_LED renames Green;
   LED4 : User_LED renames Red;

   procedure On  (This : User_LED) with Inline;
   procedure Off (This : User_LED) with Inline;
   procedure Toggle (This : User_LED) with Inline;

   procedure All_Off with Inline;
   procedure All_On  with Inline;

end STM32.LEDs;
