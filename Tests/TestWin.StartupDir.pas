unit TestWin.StartupDir;

interface

uses
  Autorun.Windows.StartupDir,
  TestsWin.Base,
  DUnitX.TestFramework;

type
  [TestFixture]
  TAutorunWinStartupDirTest = class(TAutorunWinBaseTest)
  public
    [Setup]
    procedure Setup; override;
  end;

implementation

{ TAutorunWinStartupDir }

procedure TAutorunWinStartupDirTest.Setup;
begin
  inherited;
  FAutorun := TWinAutorunByStartupDir.Create;
end;

initialization
  TDUnitX.RegisterTestFixture(TAutorunWinStartupDirTest);

end.

