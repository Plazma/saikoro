program saikoro;

{$mode objfpc}{$H+}

uses
    SysUtils, Classes;

type
    Die = record
            Name : string;
            numSides : integer;
            rolls : integer;
            content : Array[0..50] of String;
           end;



procedure OpenDice(var myDice : Array of Die; var numDice : Integer);

var
    lines : string;
    i : integer;
    count : integer;
    dieFile : Text;

begin


    for i:=0 to numDice-1 do
    begin

        write('Enter the name of die #', i+1, ': ');
        readln(myDice[i].Name);
        write('Enter the number of rolls for die #', i+1, ': ');

        {$I-}
        readln(myDice[i].rolls);
        {$I+}

        (* Test to see if integer *)
        while (myDice[i].rolls > 50) or (ioresult <> 0) do
        begin

            writeln;
            writeln('*** ERROR: Invalid Input! ***');
            writeln;
            write('Enter the number of rolls for die #', i+1, ': ');

            {$I-}
            readln(myDice[i].rolls);
            {$I+}

        end;

        writeln;

        AssignFile(dieFile, myDice[i].Name);

        if FileExists(myDice[i].Name) then
        begin

            Reset(dieFile);     (*reset file pointer *)

            count := 0;

            while not EOF(dieFile) do
            begin

                (* Read die file into string *)
                Readln(dieFile,lines);

                myDice[i].content[count] := lines;
                If (EOF(dieFile)) then break;
                Inc(count);

            end; (* End While *)

                CloseFile(dieFile);
                (* Current ide, store number of sides *)
                myDice[i].numSides := count;


         end
        else
            Writeln('Error: cannot open die: ', myDice[i].Name);
            writeln;
            
    end;



end;


procedure RollDice(var myDice : Array of Die; var numDice : Integer);

var
    dieRand : Integer;
    i, count : Integer;

begin

    randomize;

    for i:=0 to numDice-1 do
    begin

        Writeln('******* Rolling die: ', myDice[i].name , ' *******');
        writeln;

        for count:=1 to myDice[i].rolls do
        begin
            dieRand := random(myDice[i].numSides+1);
            Writeln(myDice[i].content[dieRand]);
        end;

        writeln;
    end;

end;



(* MAIN *)


var

    myDice : Array of Die;
    numDice : Integer;
    response : string;


begin

    while response <> '3' do
    begin
        writeln;
        writeln('======= Saikoro! Dice Roller Magic Fun Time! =======');
        writeln;
        writeln('1.     Load Dice');
        writeln('2.     Roll Dice');
        Writeln('3.     Quit');
        write('Enter a selection: ');
        readln(response);

        case response of
            '1': Begin
                    write('Enter the number of dice: ');

                    {$I-} 
                    readln(numDice);
                    {$I+}

                    while (numDice > 50) or (ioresult <> 0) do
                    begin

                        writeln;
                        writeln('*** ERROR: Invalid Input! ***');
                        writeln;
                        write('Enter the number of dice:  ');

                        (* Turn of I/O type checking *)
                        {$I-}
                        readln(numDice);
                        (* Turn on I/O type checking *)
                        {$I+}

                    end;

                    writeln;

                    (* Set the length of how many dice we have *)
                    SetLength(myDice, numDice);

                    (* Open Dice *)
                    openDice(myDice, numDice);
                 end;

            '2': Begin
                    (* Roll the Dice ! *)
                     writeln;
                     RollDice(myDice, numDice);
                 end;

            '3': Begin
                    writeln;
                    writeln('Ja-ne!');
                    writeln;
                 end;

        else
                writeln;
                writeln('**** ERROR: Invalid Selection! *****');
        end;

    end; (*END WHILE*)


end.
