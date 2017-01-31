package Input is

   type State is (Idle, Pressed, Hold, Release);
   for State use (0, 1, 2, 3);

   type States is array (Natural range 0 .. 5) of State;

   Keys : States := ( others => Idle );

   procedure Update;
   procedure Update_State (S : in out State; IsTouched : Boolean);

   procedure Press(Key: in out State);

   procedure PressLeft;
   procedure PressRight;
   procedure PressUp;
   procedure PressDown;
   procedure PressPause;
   procedure PressStart;

end Input;
