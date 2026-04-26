Program ScreenSaverSortOf (Input, Output);

Uses Crt, Dos;

Var
   Ch        : Char;
   I         : Integer;

Procedure Cursor;
Var
   Regs : Registers;
Begin
     Regs.AH := $01;
     Regs.CH := $20;
     Regs.CL := $20;
     Intr($10, Regs);
End;

Begin
     Cursor;
End.
