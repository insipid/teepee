Program Centipede_My_Version;

{ This version of Centipede, the age-old arcade classic, is very      }
{ blatantly a copy of the game Bugs!                                  }

{ /// My Centipede  - Programmed by |>rew /\mato \\\                  }

{ Last Updated : 26 / 4 / 96 }

Uses
    Crt, Dos;

Const                           { Defaults  }
     Trees        = 50;         {   50      }
     ETrees       = 10;         {   10      }
     StartInColor = True;       {   True    }
     StartDelay   = 100;        {   100     }
     S_BetterShot = False;      {   False   }
     S_Sound      = False;      {   False   }
     S_Demo       = False;      {   False   }
     S_Bugs       = 20;         {   20      } { Practical Max - 47 }
     S_Shots      = 30;         {   15      }
     S_Invinc     = False;      {   False   }
     MaxObjs      = 50;         {   50      }
     Bomber_E     = True;       {   True    }
     Spider_E     = True;       {   False   }
     Bugs_E       = True;       {   True    }
     Shots_E      = True;       {   True    }
     YLimit       = 20;         {   20      }
     CanQuit      = True;       {   True    }
     DemoBreak    = False;      {   False   }
     SpiderDelay  = 15;         {   15      }
     Delay_E      = True;       {   True    }
     Pods_E       = True;       {   True    }
     MaxPods      = 3;          {   3       }
     S_Pods       = 0;          {   0       }

Type
    ObjectRec = Record
                      X, Y       : Byte;
                      OldX, OldY : Byte;
                      DX, DY     : ShortInt;
                      Data       : Byte;
                End;

    SpiderRec = Record
                      X, Y       : Byte;
                      OldX, OldY : Byte;
                      DX, DY     : ShortInt;
                      Data       : Byte;
                      TX, TY     : Byte;
                      Turns      : Byte;
                End;

    ObjectArray = Array[1..MaxObjs] of ObjectRec;

    ScreenArray = Array[1..80, 1..24] of Byte;
    {  1 - Player         }
    {  2 - Bug            }
    {  3 - Tree 1         }
    {  4 - Tree 2         }
    {  5 - Tree 3         }
    {  6 - Tree 4         }
    {  8 - Bomber         }
    {  9 - Spider         }
    { 10 - Exploding Tree }
    { 11 - Pod            }

    SoundType   = (ShortWave);

Var
   Player         : ObjectRec;
   Bug            : ObjectArray;
   Screen         : ScreenArray;
   Bugs           : Byte;
   Shots          : Byte;
   Shot           : ObjectArray;
   I, J, K        : Integer;
   L, M, N        : Integer;
   Op             : Byte;
   Ch             : Char;
   GameOver       : ShortInt;
   FuncKey        : Boolean;
   H1, M1, S1, C1 : Word;
   H2, M2, S2, C2 : Word;
   AutoFire       : Boolean;
   Score          : LongInt;
   InColor        : Boolean;
   TimeDelay      : Integer;
   BetterShot     : Boolean;
   IsSound        : Boolean;
   Turn           : Integer;
   HiScore        : LongInt;
   HiScorer       : String[10];
   Time           : Integer;
   Demo           : Boolean;
   Bomber         : ObjectRec;
   Spider         : SpiderRec;
   Invinc         : Boolean;
   C_Bugs         : Byte;
   C_Shots        : Byte;
   Tracking       : Byte;
   TX, TY         : ShortInt;
   Track          : Byte;
   ShownScore     : Integer;
   ExtraDelay     : Byte;
   Pods           : Byte;
   PodsAvail      : Byte;
   PodShot        : Boolean;
   Pod            : ObjectArray;
   OldScore       : LongInt;
   PodScore       : LongInt;

{$I CURSOR.BLK}

Function _Str(Value2Str : Integer) : String;
Var
   Temp : String;
Begin
     Str(Value2Str, Temp);
     _Str := Temp;
End;

Procedure Flush;
Begin
     If KeyPressed Then
        Repeat
              Ch := Readkey;
        Until Not KeyPressed;
End;

Procedure AddTrees;
Begin
     If InColor Then TextColor(Green);
     For I := 1 to Trees do
         Begin
              Repeat
                    J := Random(47) + 2;
                    K := Random(21) + 2;
                    {J := I + 1;
                    K := 3;}
              Until Screen[J, K] = 0;
              Screen[J, K] := 3;
              GotoXY(J, K);
              Write(#5);
         End;
     TextColor(LightGray);
End;

Procedure AddExplodingTrees;
Begin
     If InColor Then TextColor(LightGreen);
     For I := 1 to ETrees do
         Begin
              Repeat
                    J := Random(43) + 4;
                    K := Random(16) + 2;
              Until Screen[J, K] = 0;
              Screen[J, K] := 10;
              GotoXY(J, K);
              Write(#5);
         End;
     TextColor(LightGray);
End;

Procedure InitBugs;
Begin
     For I := 1 to C_Bugs do
         Begin
             {Bug[I].X := (I + 38);
              Bug[I].OldX := Bug[I].X;
              Bug[I].Y := 1;
              Bug[I].OldY := 1;
              Bug[I].DX := -1;
              Bug[I].DY := 0;
              Screen[(I + 38), 1] := 2;
              GotoXY((I + 38), 1);}

             {If I <= 47 Then J := I
                 Else J := ((I Mod 48) + 1);
              J := ((2 + C_Bugs - J));
              K := ((I Div 47) + 1);}

              J := (2 + C_Bugs - I);
              K := 1;

              Bug[I].X := J;
              Bug[I].OldX := J;
              Bug[I].Y := K;
              Bug[I].OldY := K;
              Bug[I].DX := 1;
              Bug[I].DY := 0;
              Screen[J, K] := 2;
              GotoXY(J, K);
              Write(#148);
              Bug[I].Data := 1;
         End;
      Bugs := C_Bugs;
End;

Procedure Init;
Begin
     For I := 1 to 80 do
         For J := 1 to 24 do
             Screen[I, J] := 0;

     Player.X := 25;
     Player.Y := 23;
     Player.OldX := 25;
     Player.OldY := 23;
     Player.DX := 0;
     Player.DY := 0;
     Screen[25, 23] := 1;
     GotoXY(25, 23);
     If InColor Then TextColor(Yellow);
     Write(#127);

     For I := 1 to C_Shots do
         Shot[I].Data := 0;

     AddTrees;
     AddExplodingTrees;
     If Bugs_E Then InitBugs;

     GameOver := 0;
     FuncKey  := False;
     Shots    := 0;
     Bugs     := C_Bugs;
     AutoFire := False;
     Score    := 0;
     Turn     := 0;
     Time     := 0;
     Bomber.Data := 0;
     Spider.Data := 0;
     Tracking := 0;
     ShownScore := 0;
     ExtraDelay := 1;
     Pods := 0;
     PodsAvail := S_Pods;
     PodShot := False;
     For I := 1 to MaxPods Do
         Pod[I].Data := 0;
     OldScore := 0;
     PodScore := 10000;
End;

Procedure DrawScreen;
Var
   Line : String[30];
Begin
     TextColor(LightGray);
     If InColor Then TextColor(LightBlue);
     For I := 1 to 23 do
         Begin
              GotoXY(1,I);
              {Write(#219);}
              Write(#186);
              GotoXY(49,I);
              Write(#186);
         End;
     Line := '';
     For I := 1 to 30 do
         Line := Concat(Line, #177);
     If InColor Then TextColor(LightGray);
     For I := 1 to 23 do
         Begin
              GotoXY(50,I);
              Write(Line);
         End;
   
    {For I := 2 to 12 do
         Begin
              GotoXY((I + 58), 4);
              Write('Ä');
              GotoXY((I + 58), 6);
              Write('Ä');
         End;
     GotoXY(59,4);
     Write('Ú');
     GotoXY(59,5);
     Write('³');
     GotoXY(59,6);
     Write('À');
     GotoXY(71,4);
     Write('¿');
     GotoXY(71,5);
     Write('³');
     GotoXY(71,6);
     Write('Ù'); }
     If HiScore <> 0 Then
        Begin
             I := (((30 - (13 + Length(_Str(HiScore)))) Div 2) + 50);
             GotoXY(I,8);
             If InColor Then TextColor(White) Else TextColor(LightGray);
             Write('High Score : ',HiScore);
        End;
End;

Procedure ShowScore(Target, Value : Integer);
Var
   Disp    : Char;
   Value_S : String;
   Space   : String;
Begin
     Case Target of
          1 : Disp := #5;
          2 : Disp := #6;
          3 : Disp := #3;
          4 : Disp := #4;
          5 : Disp := #148;
          8 : Disp := #157;
          9 : Disp := #15;
     End;
     GotoXY(60,5);
     If InColor Then
        Case Target of
                      1..4 : TextColor(Green);
                      5    : TextColor(LightCyan);
                      8    : TextColor(Red);
                      9    : TextColor(Magenta);
        End;
     If ((Target <> 0) and (Time <= 10)) or (Value > ShownScore) Then
        Begin
             ShownScore := Value;
             Str(Value, Value_S);
             Space := '';
             For K := 1 to (6 - Length(Value_S)) do
                 Space := Concat(Space, ' ');
             Write(' ',Disp);
             If InColor Then TextColor(White);
             Write(' - ',Space,Value_S);
             Inc(Score, Value);
             Case Target Of
                           1..4 : Time := 10;
                           5    : Time := 30;
                           8    : Time := 40;
                           9    : Time := 40;
             End;
        End
     Else
         If Target = 0 Then {Write('           ');}
            Begin
                 ShownScore := 0;
                 TextColor(LightGray);
                 For K := 1 to 11 do
                     Write(#177);
            End;
End;

Procedure MakeSound(Sound2Make : SoundType);
Var
   Q, R : Integer;
Begin
     If IsSound Then
     Case Sound2Make Of
                       ShortWave : Begin
                                        For Q := 1 to 2 do
                                            Begin
                                                 For R := 700 to 801 do
                                                     Begin
                                                          Sound(R);
                                                          Delay(1);
                                                          Inc(R, 2);
                                                     End;
                                                 For R := 800 downto 699 do
                                                     Begin
                                                          Sound(R);
                                                          Delay(1);
                                                          Dec(R, 2);
                                                     End;
                                            End;
                                        NoSound;
                                   End;
     End;
End;

Procedure KillPod(Pod2KillX, Pod2KillY : Byte);
Begin
     M := 0;
     L := 0;
     Repeat
           Inc(L);
           If (Pod[L].Data <> 0) And
              (Pod[L].X = Pod2KillX) And
              (Pod[L].Y = Pod2KillY) Then M := 1;
     Until (M = 1) Or (L = MaxPods);
     If M = 1 Then
        Begin
             Pod[L].Data := 0;
             Screen[Pod2KillX, Pod2KillY] := 0;
             GotoXY(Pod2KillX, Pod2KillY);
             Write(' ');
        End;
     Dec(Pods);
End;

Procedure MoveBugs;
Begin
     For I := 1 to C_Bugs do
         Begin
              If Bug[I].Data <> 0 Then
              With Bug[I] do
                   Begin
                        OldX := X;
                        OldY := Y;
                        X := X + DX;
                        Y := Y + DY;
                        If (X < 2) or (X > 48) or (Screen[X, Y] <> 0) Then
                           Begin
                                If Screen[X, Y] = 1 Then GameOver := 1;
                                If Screen[X, Y] = 11 Then
                                   Begin
                                        KillPod(X, Y);
                                   End;
                                DX := -DX;
                                X := OldX;
                                If Screen[X, (Y + 1)] = 0 Then Y := Y + 1;
                           End;
                        If (Y > 23) Then
                           Begin
                                If X > 48 Then X := 48;
                                If X <  2 Then X := 2;
                                Y := 1;
                           End;
                        If InColor Then TextColor(LightCyan);
                        GotoXY(OldX, OldY);
                        Write(' ');
                        GotoXY(X, Y);
                        Write(#148);
                        Screen[OldX, OldY] := 0;
                        Screen[X, Y] := 2;
                        If IsSound Then
                           Begin
                                Sound((Y * 50) + 800);
                                Delay(1);
                                NoSound;
                           End;
                   End;
         End;
End;

Procedure MovePlayer;
Begin
     With Player Do
          Begin
               OldX := X;
               OldY := Y;
               X := X + DX;
               Y := Y + DY;
               If (X < 2) or (X > 48)
                  or (Screen[X, Y] <> 0)
                  or (Y < YLimit) or (Y > 23) Then
               Begin
                    If (Screen[X, Y] = 2) or
                       (Screen[X, Y] = 8) or
                       (Screen[X, Y] = 9) Then GameOver := 1;
                    X := OldX;
                    Y := OldY;
                    If (X <  2) or (X > 48)
                    or (Y < YLimit) or (Y > 23) Then
                       Begin
                            DX := 0;
                            DY := 0;
                       End;
               End;
               If Screen[OldX, OldY] <= 1 Then
                  Begin
                       GotoXY(OldX, OldY);
                       Write(' ');
                  End;
               If Screen[OldX, OldY] = 1 Then Screen[OldX, OldY] := 0;
               If InColor Then TextColor(Yellow);
               GotoXY(X, Y);
               Write(#127);
               Screen[X, Y] := 1;
          End;
End;

Procedure KillShot(ShotX, ShotY : Integer);
Var
   Q : Integer;
Begin
     For Q := 1 to C_Shots Do
         If (Shot[Q].X = ShotX) and (Shot[Q].Y = ShotY) and (Shot[Q].Data <> 0) Then
            Begin
                 Shot[Q].Data := 0;
                 Dec(Shots);
            End;
End;

Procedure MoveShots;
Var
   CheckHit, IsHit : Boolean;
   X2, Y2, X3, Y3  : Byte;

Begin
     For I := 1 to C_Shots do
         Begin
              If Shot[I].Data <> 0 Then
                 Begin
                      With Shot[I] do
                           Begin
                                OldX := X;
                                OldY := Y;
                                X := X + DX;
                                Y := Y + DY;
                                GotoXY(OldX, OldY);
                                If Shot[I].Data = 2 Then  { If just fired }
                                   Shot[I].Data := 1
                                Else
                                    Write(' ');
                                If Not BetterShot Then
                                   Begin
                                        CheckHit := (Screen[X, Y] <> 0);
                                        IsHit := (Screen[X, Y] = 2);
                                   End
                                Else
                                    Begin
                                         For J := 1 to C_Bugs do
                                             Begin
                                                  If (((Bug[J].OldX - OldX) * (Bug[J].OldX - X) < 0) and
                                                      ((Bug[J].OldY - OldY) * (Bug[J].OldY - Y) < 0)) Then
                                                        Begin
                                                             CheckHit := True;
                                                             IsHit    := True;
                                                             X2 := Bug[J].OldX;
                                                             Y2 := Bug[J].OldY;
                                                        End
                                                  Else
                                                      If (((Bug[J].X - OldX) * (Bug[J].X - X) < 0) and
                                                          ((Bug[J].Y - OldY) * (Bug[J].Y - Y) < 0)) Then
                                                                 Begin
                                                                      CheckHit := True;
                                                                      IsHit := True;
                                                                      X2 := Bug[J].X;
                                                                      Y2 := Bug[J].Y;
                                                                 End
                                                          Else
                                                              Begin
                                                                   CheckHit := (Screen[X, Y] <> 0);
                                                                   IsHit    := (Screen[X, Y]  = 2);
                                                              End;
                                             End;
                                    End;
                                If CheckHit Then
                                   Begin
                                        If IsHit Then
                                           Begin
                                                If (IsHit) and (Not Screen[X, Y] = 2) Then
                                                   Begin
                                                        X3 := X2;
                                                        Y3 := Y2;
                                                   End
                                                Else
                                                    Begin
                                                         X3 := X;
                                                         Y3 := Y;
                                                    End;
                                                Screen[X3, Y3] := 3;
                                                Data := 0;
                                                Dec(Shots);
                                                GotoXY(X3, Y3);
                                                If InColor Then TextColor(Green);
                                                Write(#5);
                                                For J := 1 to C_Bugs do
                                                    Begin
                                                         If (Bug[J].X = X3) and
                                                            (Bug[J].Y = Y3) and
                                                            (Bug[J].Data <> 0) Then
                                                             Begin
                                                                  Bug[J].Data := 0;
                                                                  Dec(Bugs);
                                                             End;
                                                    End;
                                                ShowScore(5, 100);
                                                Tracking := 0;
                                           End
                                        Else
                                            If (Screen[X, Y] >= 3) and (Screen[X, Y] <= 6) Then
                                               Begin
                                                    Inc(Screen[X, Y]);
                                                    If Screen[X, Y] > 6 Then
                                                       Begin
                                                            Screen[X, Y] := 0;
                                                            GotoXY(X, Y);
                                                            Write(' ');
                                                       End;
                                                    GotoXY(X, Y);
                                                    If InColor Then TextColor(Green);
                                                    Case Screen[X, Y] of
                                                         4 : Write(#6);
                                                         5 : Write(#3);
                                                         6 : Write(#4);
                                                    End;
                                                    Data := 0;
                                                    Dec(Shots);
                                                    { Inc(Score, 10); }
                                                    Case Screen[X, Y] of
                                                         4 : ShowScore(1,10);
                                                         5 : ShowScore(2,10);
                                                         6 : ShowScore(3,10);
                                                         0 : ShowScore(4,10);
                                                    End;
                                               End
                                            Else
                                                Begin
                                                     If Screen[X, Y] = 8 Then
                                                        Begin
                                                             Screen[X, Y] := 0;
                                                             GotoXY(X, Y);
                                                             Write(' ');
                                                             Data := 0;
                                                             Bomber.Data := 0;
                                                             Dec(Shots);
                                                             ShowScore(8, 200);
                                                             MakeSound(ShortWave);
                                                             Tracking := 0;
                                                        End;
                                                     If Screen[X, Y] = 9 Then
                                                        Begin
                                                             Screen[X, Y] := 0;
                                                             GotoXY(X, Y);
                                                             Write(' ');
                                                             Data := 0;
                                                             Spider.Data := 0;
                                                             Dec(Shots);
                                                             ShowScore(9, 500);
                                                             Tracking := 0;
                                                        End;
                                                     If Screen[X, Y] = 10 Then
                                                        Begin
                                                             Screen[X, Y] := 3;
                                                             Data := 0;
                                                             Dec(Shots);
                                                             For L := -2 to 2 do
                                                                 For M := -2 to 2 do
                                                                     Begin
                                                                          If (Abs(L * M) = 4) or
                                                                             (Abs(L * M) = 1) or
                                                                             (Abs(L * M) = 0) Then
                                                                             Begin
                                                                                  Screen[(X + L),(Y + M)] := 3;
                                                                                  GotoXY((X + L),(Y + M));
                                                                                  KillShot((X + L),(Y + M));
                                                                                  If InColor Then TextColor(Green);
                                                                                  Write(#5);
                                                                             End;
                                                                     End;
                                                        End;
                                                     If Screen[X, Y] = 11 Then KillShot(X, Y);
                                                     If Screen[X, Y] = 1 Then KillShot(X, Y);
                                                End;
                                   End
                                Else
                                    Begin
                                         If Y >= 1 Then
                                            Begin
                                                 GotoXY(X, Y);
                                                 If InColor Then TextColor(Yellow);
                                                 Write(#24);
                                            End
                                         Else
                                             Begin
                                                  Data := 0;
                                                  GotoXY(OldX, OldY);
                                                  Write(' ');
                                                  Dec(Shots);
                                             End;
                                    End;
                           End;
                 End;
         End;
End;

Procedure FireShot;
Begin
     If Shots < C_Shots Then
         Begin
              Inc(Shots);
              For I := 1 to C_Shots do
                  If Shot[I].Data = 0 Then J := I;
              With Shot[J] do
                   Begin
                        If Not PodShot Then
                           Begin
                                X := Player.X;
                                Y := Player.Y;
                           End
                        Else
                            Begin
                                 X := Pod[K].X;
                                 Y := Pod[K].Y;
                            End;
                        OldX := X;
                        OldY := Y;
                        DX := 0;
                        DY := -1;
                        Data := 2;
                   End;
              If IsSound Then
                 Begin
                      Sound(100);
                      Delay(10);
                      NoSound;
                 End;
         End;
End;

Procedure StartBomber;
Begin
     Repeat
           I := Random(47) + 2;
           J := Random(12) + 1;
     Until Screen[I, J] = 0;
     With Bomber do
          Begin
               Data := 1;
               X    := I;
               Y    := J;
               OldX := I;
               OldY := J;
               DX   := 0;
               DY   := 1;
          End;
     Screen[I, J] := 8;
     GotoXY(I, J);
     If InColor Then TextColor(Red);
     Write(#157);
End;

Procedure MoveBomber;
Begin
     With Bomber Do
          Begin
               OldX := X;
               OldY := Y;
               X := X + DX;
               Y := Y + DY;
               Screen[OldX, OldY] := 0;
               GotoXY(OldX, OldY);
               Write(' ');
               If Screen[X, Y] = 2 Then
                  Begin
                       X := OldX;
                       Y := OldY;
                       Data := 0;
                       Screen[OldX, OldY] := 3;
                       GotoXY(OldX, OldY);
                       If InColor Then TextColor(Green);
                       Write(#5);
                  End;
               If ((Random(100) + 1) > 60) Then
                  Begin
                       Screen[OldX, OldY] := 3;
                       GotoXY(OldX, OldY);
                       If InColor Then TextColor(Green);
                       Write(#5);
                  End;
               If (X < 2) or (X > 48) or (Y < 1) or (Y > 23) Then
                  Begin
                       X := OldX;
                       Y := OldY;
                       Screen[X, Y] := 0;
                       GotoXY(X, Y);
                       Write(' ');
                       Data := 0;
                  End;
               If Screen[X, Y] = 1 Then GameOver := 1;
               If Data <> 0 Then
                  Begin
                       Screen[X, Y] := 8;
                       GotoXY(X, Y);
                       If InColor Then TextColor(Red);
                       Write(#157);
                       If IsSound Then
                          Begin
                               Sound((23 - Y) * 100 + 700);
                               Delay(1);
                          End;
                  End;
          End;
End;

Procedure StartSpider;
Begin
     Repeat
           I := Random(100) - 49;               { Chooses 2      }
           If I = 0 Then I := 1;                {     or 48      }
           I := ((I div Abs(I)) * 2);           {                }
           I := Trunc(((I + 2) * 12.5) - I);    {                }
           J := Random(6) + 15;
     Until Screen[I, J] = 0;
     With Spider Do
          Begin
               X    := I;
               Y    := J;
               OldX := I;
               OldY := J;
               DX   := ((I - 47) div Abs(I - 47));
               DY   := 0;
               Data := 1;
               Screen[X, Y] := 9;
               GotoXY(X, Y);
               If InColor Then TextColor(Magenta);
               Write(#15);
          End;
End;

Procedure MoveSpider;
Begin
     With Spider Do
          Begin
               OldX := X;
               OldY := Y;
               X := X + DX;
               Y := Y + DY;
               Screen[OldX, OldY] := 0;
               GotoXY(OldX, OldY);
               Write(' ');
               Dec(Turns);
               If (((Screen[X, Y] >= 3) And (Screen[X, Y] <= 6)) or (Screen[X, Y] = 11)) And
                  (DX <> 0) And (DY <> 0) Then
                      Begin
                           If (Screen[OldX, Y] = 0) Then
                              If (Screen[X, OldY] = 0) Then
                                 If ((Random(100) + 1) > 50) Then
                                    X := OldX
                                 Else
                                     Y := OldY
                              Else
                                  X := OldX
                           Else
                               If (Screen[X, OldY] = 0) Then
                                  Y := OldY;
                      End;
               If (X < 2) or (X > 48)
               or (Y < 10) or (Y > 23)
               or ((Screen[X, Y] >= 3) and (Screen[X, Y] <= 6))
               or (Screen[X, Y] = 11) Then
                  Begin
                       If Screen[X, Y] = 11 Then
                          KillPod(X, Y);
                       X  := OldX;
                       Y  := OldY;
                       If (X < 2)  or (X > 48) Then DX := -1 * DX;
                       If (Y < 10) or (Y > 23) Then DY := -1 * DY;
                       Data := 1;
                       Turns := SpiderDelay;
                       TX := X;
                       TY := Y;
                  End;
               If (Data <> 2) and (Turns <= 0) Then
                  Begin
                       Data := 2;
                       TX   := Player.X;
                       TY   := Player.Y;
                  End;
               If (TX - X) <> 0 Then
                  DX := ((TX - X) Div Abs(TX - X))
               Else
                   DX := 0;
               If (TY - Y) <> 0 Then
                  DY := ((TY - Y) Div Abs(TY - Y))
               Else
                   DY := 0;
               If (X = TX) and (Y = TY) and (Data = 2) Then
                  Begin
                       Data := 1;
                       Turns := SpiderDelay;
                  End;
               If Screen[X, Y] = 1 Then GameOver := 1;
               Screen[X, Y] := 9;
               GotoXY(X, Y);
               If InColor Then TextColor(Magenta);
               Write(#15);
          End;
End;

Procedure DoPause;
Begin
     Flush;
     Repeat Until KeyPressed;
End;

Procedure MaskScreen;
Begin
     For I := 2 to 48 Do
         For J := 1 to 23 Do
             Begin
                  If Screen[I, J] <> 0 Then
                     Begin
                          TextColor(LightGray);
                          GotoXY(I, J);
                          Write('X');
                     End;
             End;
End;

Procedure ReDrawScreen;
Begin
     For I := 2 to 49 Do
         For J := 1 to 23 Do
             Begin
                  If InColor Then
                     Case Screen[I, J] of
                                         1 : TextColor(Yellow);
                                         2 : TextColor(LightCyan);
                                      3..6 : TextColor(Green);
                                         8 : TextColor(Red);
                                         9 : TextColor(Magenta);
                                         10 : TextColor(LightGreen);
                                         11 : TextColor(Brown);
                     End
                  Else
                      TextColor(LightGray);
                  Case Screen[I, J] of
                                      1 : Ch := #127;
                                      2 : Ch := #148;
                                      3 : Ch := #5;
                                      4 : Ch := #6;
                                      5 : Ch := #3;
                                      6 : Ch := #4;
                                      8 : Ch := #157;
                                      9 : Ch := #15;
                                     10 : Ch := #5;
                                     11 : Ch := #233;
                  End;
                  GotoXY(I, J);
                  If Screen[I, J] <> 0 Then Write(Ch);
             End;
End;

Procedure DropPod;
Begin
     If (Pods_E) and (PodsAvail > 0) and (Pods < MaxPods)
        and ((Player.DX <> 0) or (Player.DY <> 0))
        and (((Player.X + Player.DX) In [2..48]) and
             ((Player.Y + Player.DY) In [YLimit..23])) Then
        Begin
             Inc(Pods);
             Pod[Pods].Data := 1;
             Pod[Pods].X := Player.X;
             Pod[Pods].Y := Player.Y;
             GotoXY(Pod[Pods].X, Pod[Pods].Y);
             If InColor Then TextColor(Brown) Else TextColor(LightGray);
             Write('é');
             Screen[Player.X, Player.Y] := 11;
             Dec(PodsAvail);
             If (PodsAvail = 0) Then
                Begin
                     TextColor(LightGray);
                     GotoXY(60,9);
                     For K := 1 to 19 do
                         Write(#177);
                End;
        End;
End;

Procedure DoPods;
Var
   ShotTime : Byte;
Begin
     PodShot := True;
     For K := 1 to MaxPods do
         Begin
              ShotTime := Trunc(Int(((Pods + 2) / 2) + 0.5));
              If (Pod[K].Data <> 0) and ((Turn Mod ShotTime) = (K Mod ShotTime)) Then FireShot;
         End;
     PodShot := False;
End;


Procedure ParseOp;
Begin
     Case Op Of
               1 : Begin
                        Player.DX :=  0;
                        Player.DY := -1;
                   End;
               2 : Begin
                        Player.DX :=  1;
                        Player.DY :=  0;
                   End;
               3 : Begin
                        Player.DX :=  0;
                        Player.DY :=  1;
                   End;
               4 : Begin
                        Player.DX := -1;
                        Player.DY :=  0;
                   End;
               5 : Begin
                        Player.DX := 0;
                        Player.DY := 0;
                   End;
               6 : If Shots_E Then FireShot;
               7 : AutoFire := Not AutoFire;
               8 : Begin
                        InColor  := Not InColor;
                        DrawScreen;
                   End;
               9 : If CanQuit Then GameOver := -1;
              10 : Begin
                        IsSound  := Not IsSound;
                        NoSound;
                   End;
              11 : Demo     := Not Demo;
              12 : If Bomber_E Then StartBomber;
              13 : If Spider_E Then StartSpider;
              14 : Invinc   := Not Invinc;
              15 : DoPause;
              16 : MaskScreen;
              17 : ReDrawScreen;
              18 : If ExtraDelay <= 90 Then Inc(ExtraDelay, 10);
              19 : If ExtraDelay >= 11 Then Dec(ExtraDelay, 10);
              20 : DropPod;
              21 : GameOver := 1;
     End;
End;

Procedure CheckKey;
Begin
     If FuncKey Then
        Begin
             FuncKey := False;
             Case Ch Of
                       #72 : Op := 1;   { Up Arrow  }
                       #77 : Op := 2;   { Right     }
                       #80 : Op := 3;   { Down      }
                       #75 : Op := 4;   { Left      }
                       #73 : Op := 5;   { Stop      }
                       #71 : Op := 6;   { Fire      }
                       #81 : Op := 7;   { AutoFire  }
                       #46 : Op := 8;   { Color     }
                       #31 : Op := 10;  { Sound     }
                       #32 : Op := 11;  { Demo      }
                       #48 : Op := 12;  { Bomber    }
                       #25 : Op := 13;  { Spider    }
                       #23 : Op := 14;  { Invinc    }
                       #45 : Op := 9;   { Quit      }
                       #50 : Op := 16;  { Mask      }
                       #19 : Op := 17;  { ReDraw    }
                       #44 : Op := 18;  { Speed Up  }
                       #30 : Op := 19;  { Slow Down }
             Else
                 Op := 0;
             End;
        End
     Else
         Case Ch Of
                   '8','I','i' : Op := 1;
                   '6','L','l' : Op := 2;
                   '2',','     : Op := 3;
                   '4','J','j' : Op := 4;
                   '5','K','k' : Op := 5;
                   '7','Z','z' : Op := 6;
                   '3','A','a' : Op := 7;
                      {'X','x' : Op := 9;}
                       'P','p' : Op := 15;
                       'O','o' : Op := 20;
                           #27 : Op := 21;
         Else
             Op := 0;
         End;

     ParseOp;
End;


Procedure DemoMovePlayer;

Procedure RandomChangeBoth;
Begin
     Player.DX := 0;
     Player.DY := 0;
     I := Random(4) + 1;
     Case I Of
              1 : Player.DY := -1;
              2 : Player.DX :=  1;
              3 : Player.DY :=  1;
              4 : Player.DX := -1;
     End;
End;

Procedure RandomChangeX;
Begin
     I := Random(100) + 1;
     If I < 50 Then Player.DX := -1;
     If I > 50 Then Player.DX :=  1;
End;

Procedure RandomChangeY;
Begin
     I := Random(100) + 1;
     If I < 50 Then Player.DY := -1;
     If I > 50 Then Player.DY :=  1;
End;

Begin
     With Player Do
          Begin
               K := 0;
               L := 0;
               For I := 1 to C_Bugs do
                   Begin
                        If Bug[I].Data <> 0 Then
                           Begin
                                If Bug[I].X < X Then
                                   Dec(K)
                                Else
                                    If Bug[I].X > X Then
                                       Inc(K);
                                If Bug[I].Y < Y Then
                                   Dec(L)
                                Else
                                    If Bug[I].Y > Y Then
                                       Inc(Y);
                           End;
                   End;
               If K < 0 Then DX := -1;
               If K > 0 Then DX :=  1;
               If K = 0 Then RandomChangeX;
               If L < 0 Then DY := -1;
               If L > 0 Then DY :=  1;
               If L = 0 Then RandomChangeY;

               {If ((Random(10) + 1) = 10) Then RandomChangeY;}

               {J := Random(5) + 1;
               If ((OldX = X) and (OldY = Y)) or (J = 1) Then
                  RandomChange;}
          End;
     MovePlayer;
     AutoFire := True;
End;

Procedure SmartDemoMove;
Var
   A, B, C, D : Integer;
   Found      : Boolean;
Begin
     Found := False;
     A := Player.X + Player.DX;
     B := Player.Y + Player.DY;
     C := Player.DX;
     D := Player.DY;
     If (Screen[A, B] >= 3) and (Screen[A, B] <= 6) Then
        Begin
             If (Screen[A, Player.Y] = 0) or
                (Screen[Player.X, B] = 0) Then
                 Begin
                      If ((Random(100) + 1) > 75) Then
                         C := 0
                      Else
                          D := 0;
                      Found := True;
                 End;
             If (B > 1) And (Screen[A, (Player.Y - 1)] = 0) And Not Found Then
                Begin
                     D := -1;
                     Found := True;
                End
             Else
                 If (B < 22) And (Screen[A, (Player.Y + 1)] = 0) And Not Found Then
                    Begin
                         D := 1;
                         Found := True;
                    End;
             If Not Found And (Screen[Player.X, B] = 0) Then
                Begin
                     C := 0;
                     Found := True;
                End;
        End;
     If (Screen[A, B] = 2) or (Screen[A, B] = 8) or (Screen[A, B] = 9) Then
        Begin
             If (Screen[A, Player.Y] = 0) Then
                Begin
                     D := 0;
                     Found := True;
                End
             Else
                 If (Screen[Player.X, B] = 0) Then
                    Begin
                         C := 0;
                         Found := True;
                    End
                 Else
                     Begin
                          C := 0;
                          D := 0;
                     End;
        End;
End;

Procedure AlternateDemoMove;
Var
   OldTX, OldTY, ShouldTrack, A : Integer;
Begin
     ShouldTrack := 0;
     OldTX := TX;
     OldTY := TY;
     If ((Tracking = 2) and ((Not Bomber_E) or (Bomber.Data = 0))) or
        ((Tracking = 3) and ((Not Spider_E) or (Spider.Data = 0))) Then
          Tracking := 0;
     If (Bugs_E) and (Bug[Track].Data = 0) Then Tracking := 0;
     If ((Bugs_E) and (Bugs > 0) and (Tracking = 0)) or
        ((Bomber_E) and (Bomber.Data <> 0) and
         (Abs(Player.X - Bomber.X) >= Abs(Player.Y - Bomber.Y))) Then
        Begin
             Repeat
                   I := Random(C_Bugs) + 1;
             Until Bug[I].Data <> 0;
             TX := Bug[I].X;
             TY := Bug[I].Y;
             ShouldTrack := 1;
             Track := I;
        End;
     If Bomber_E And (Bomber.Data <> 0) Then
        Begin
             If Abs(Player.X - Bomber.X) < Abs(Player.Y - Bomber.Y) Then
                Begin
                     ShouldTrack := 2;
                     TX := Bomber.X;
                     {TY := Bomber.Y;}
                     TY := 24;         { Go down, to avoid getting killed }
                End
             Else
                 ShouldTrack := 1;
        End;
     If Spider_E And (Spider.Data <> 0) Then
        Begin
             TX := Spider.X;
             TY := Spider.Y;
             ShouldTrack := 3;
        End;
     If ShouldTrack <= Tracking Then
        Begin
             TX := OldTX;
             TY := OldTY;
        End
     Else
         Tracking := ShouldTrack;
     If Tracking = 1 Then
        Begin
             TX := Bug[Track].X;
             TY := Bug[Track].Y;
        End;
     If TX <> Player.X Then
        Player.DX := ((TX - Player.X) Div Abs(TX - Player.X))
     Else
         Player.DX := 0;
     If TY <> Player.Y Then
        Player.DY := ((TY - Player.Y) Div Abs(TY - Player.Y))
     Else
         Player.DY := 0;
     If ((Random(10) + 1) > 4) Then Player.DY := 1;
     If ((Player.Y + Player.DY < YLimit) or
         (Player.Y + Player.DY > 23)) Then
                   Player.DY := 0;
     If ((Player.X + Player.DX < 2) or
         (Player.X + Player.DX > 48)) Then
                   Player.DX := 0;
     
     If (Player.DX <> 0) and (Player.DY <> 0) Then
        If ((Random(100) + 1) > 75) Then
           Player.DX := 0
        Else
            Player.DY := 0;
     A := Screen[(Player.X - 1), Player.Y];
     If (A = 2) Or (A = 8) Or (A = 9) Then
        Begin
             If ((Random(100) + 1) > 20) Then
                 Player.DX := 1
             Else
                 If ((Random(100) + 1) > 50) Then
                    Player.DY := -1
                 Else
                     Player.DY := 1;
        End;
     A := Screen[(Player.X + 1), Player.Y];
     If (A = 2) Or (A = 8) Or (A = 9) Then
        Begin
             If ((Random(100) + 1) > 20) Then
                 Player.DX := -1
             Else
                 If ((Random(100) + 1) > 50) Then
                    Player.DY := -1
                 Else
                     Player.DY := 1;
        End;
     A := Screen[Player.X, (Player.Y - 1)];
     If (A = 9) And (Player.DX <> 0) Then
        If (Random(100) + 1 > 50) Then
           Player.DX := 1
        Else
            Player.DX := -1;
     If Screen[(Player.X + Player.DX),(Player.Y + Player.DY)] <> 0 Then
        SmartDemoMove;
     GotoXY(60,20);
     Write('Track : ',Tracking,' Bug: ',Track:2);
     GotoXY(60,22);
     Write('TX : ',TX:2,'  TY : ',TY:2);
     GotoXY(60,23);
     Write('DX : ',Player.DX:2,'  DY : ',Player.DY:2);
     {MovePlayer;}
     AutoFire := True;

     If PodsAvail > 0 Then DropPod;
End;

Procedure Stats;
Begin
     If InColor Then TextColor(White);
     GotoXY(60,13);
     Write(' Turn : ',Turn);
     GotoXY(60,10);
     Write('Score : ',Score);
     GotoXY(60,9);
     If (Pods_E) and (PodsAvail > 0) Then
        Write('Pods  : ',PodsAvail);
     GotoXY(60,14);
     Write('Time Delay : ',ExtraDelay:2);
     GotoXY(60,15);
     Write('Shots : ',Shots:2);
     GotoXY(60,16);
     Write('Bugs  : ',Bugs:2);
     GotoXY(55,17);
     {Write('Bug : ');
     For I := 1 to C_Bugs do
         Write(Bug[I].Data,',');
     GotoXY(55,18);
     For I := 1 to C_Bugs do
         Write(Bug[I].X);}
     GotoXY(60,19);
     Write('Turns : ',Spider.Turns:3);
     GotoXY(60,21);
     Write('X  : ',Player.X:2,'   Y : ',Player.Y:2);
End;

Procedure CheckShots;
Var
   Count : Integer;
Begin
     Count := 0;
     For I := 1 to C_Shots Do
         With Shot[I] Do
              If Data <> 0 Then
                 If Abs(OldY - Y) > 1 Then Inc(Count);
     If Count > 0 Then
        Begin
             GotoXY(60,22);
             Write('AArrrrggghh!');
        End;
End;

Procedure Main;
Begin
     ClrScr;
     DrawScreen;
     Init;
     Repeat
           GetTime(H1, M1, S1, C1);
           Repeat
                 GetTime(H2, M2, S2, C2);
           Until KeyPressed or
           (((C2 >= (C1 +  1))         or (C2 < C1)) and Not Delay_E) or
           (((C2 >= (C1 + ExtraDelay)) or (C2 < C1)) and     Delay_E);

          {Delay(TimeDelay);}

           If KeyPressed Then
               Begin
                    Ch := ReadKey;
                    If Ch = #0 Then
                       Begin
                            Ch := ReadKey;
                            FuncKey := True;
                       End;
                    Flush;
                    CheckKey;
                    Stats;
                    If Demo And DemoBreak And (Op <> 11) Then
                       Begin
                            Demo := False;
                            GameOver := 2;
                       End;
               End
           Else
               Begin
                    MovePlayer;
                    If Bugs_E Then MoveBugs;
                    If Shots_E Then MoveShots;
                    If (Bugs = 0) and Bugs_E Then
                       Begin
                            Inc(Score, 1000);
                            InitBugs;
                       End;
                    If AutoFire And Shots_E Then FireShot;
                    Inc(Turn);
                    Dec(Time);
                    If Time <= 0 Then ShowScore(0,0);
                    Stats;
                    If Not InColor Then TextColor(LightGray);
                    If Demo Then AlternateDemoMove;
                    If (Bomber.Data <> 0) And Bomber_E Then MoveBomber;
                    If ((Random(100) + 1) < 3) and
                       (Bomber.Data = 0) and
                       Bomber_E Then StartBomber;
                    If (Spider.Data <> 0) And Spider_E Then MoveSpider;
                    If ((Random(200) + 1) < 2) and
                       (Spider.Data = 0) and
                       Spider_E Then StartSpider;
                    If (Pods_E) and (Pods > 0) Then DoPods;
                    If (Pods_E) and (Pods <> MaxPods) and
                       (((Score div PodScore) - (OldScore div PodScore)) <> 0) Then
                           Inc(PodsAvail);
                    OldScore := Score;
               End;
           If (GameOver = 1) and Invinc Then GameOver := 0;
     Until (GameOver <> 0);
     If Score > HiScore Then HiScore := Score;
End;

Procedure DoGameOver;
Var
   Space : String;

Begin
     Space := '';
     For I := 1 to 30 do
         Space := Concat(Space, ' ');
     For J := 5 to 20 do
         Begin
              GotoXY(5,J);
              Write(Space);
         End;
     GotoXY(15,8);
     If InColor Then TextColor(White + Blink);
     Write(' -- GAME OVER -- ');
     If Score > HiScore Then
        Begin
             If InColor Then TextColor(White);
             GotoXY(15,12);
             Write(' Congratulations!! ');
             GotoXY(11,13);
             Write(' You have the new high score!!');
             GotoXY(10,14);
             Write(' -> ');
             Readln(HiScorer);
             GotoXY(15,16);
        End
     Else
         GotoXY(15,10);
     Write('Again ? ');
     Flush;
     Ch := Readkey;
     If (Ch = 'n') or (Ch = 'N') Then GameOver := -1;
End;


Begin
     TextBackground(Black);
     InColor    := StartInColor;
     TimeDelay  := StartDelay;
     BetterShot := S_BetterShot;
     IsSound    := S_Sound;
     Demo       := S_Demo;
     C_Bugs     := S_Bugs;
     C_Shots    := S_Shots;
     Invinc     := S_Invinc;
     HiScore    := 0;
     Randomize;
     HideCursor;
     Repeat
           Main;
         { DoGameOver; }
     Until GameOver = -1;
     ShowCursor;
End.

