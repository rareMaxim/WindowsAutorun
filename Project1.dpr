program Project1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Unit2,
  System.SysUtils;

procedure Test;
var
  LAtrn: IAutorunManager;
begin
  LAtrn := TWinAutorunCurentUser.Create();

  Writeln(LAtrn.Count);
  Writeln(LAtrn.Items[0].Name, ' - ', LAtrn.Items[0].Path);
  LAtrn.Add('aimp', 'C:\Users\maks4\AppData\Local\SourceTree\SourceTree.exe');
  LAtrn.Delete('aimp');
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Test;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
