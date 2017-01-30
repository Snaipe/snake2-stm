with STM32F4.LCD;

package Touch is

   type Touch_State is record
      Touch_Detected : Boolean;
      X : STM32F4.LCD.Width;
      Y : STM32F4.LCD.Height;
   end record;

   function Get_Touch_State return Touch_State;

end Touch;
