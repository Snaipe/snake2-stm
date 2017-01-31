package Input is

   type State is (Idle, Pressed, Hold, Release);
   for State use (0, 1, 2, 3);

   type States is array (Natural range 0 .. 5) of State;

   type Buttons is (ButLeft, ButRight, ButUp, ButDown, ButPause, ButStart);

   Keys : States := ( others => Idle );

   function Is_Pressed (S : State) return Boolean is (S = Hold or S = Pressed);

   procedure Update (IsTouched : Boolean);
   procedure Update_State (S : in out State; IsTouched : Boolean);

   function Get (B : Buttons) return State;

   procedure Press(Key: in out State);

   procedure PressLeft;
   procedure PressRight;
   procedure PressUp;
   procedure PressDown;
   procedure PressPause;
   procedure PressStart;

end Input;
