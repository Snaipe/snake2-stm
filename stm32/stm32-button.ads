package STM32.Button is
   pragma Elaborate_Body;

   type Directions is (Clockwise, Counterclockwise);

   function Current_Direction return Directions;

end STM32.Button;
