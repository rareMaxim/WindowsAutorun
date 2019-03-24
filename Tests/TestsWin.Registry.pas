unit TestsWin.Registry;

interface

uses
  TestsWin.Base,
  Autorun.Windows.Register,
  DUnitX.TestFramework;

type
  [TestFixture]
  TAutorunWinCurentUserTest = class(TAutorunWinBaseTest)
  public
    [Setup]
    procedure Setup; override;
  end;

  // {RUN AS ADMIN}  [TestFixture]
  TAutorunWinLocalMachineTest = class(TAutorunWinBaseTest)
  public
    [Setup]
    procedure Setup; override;
  end;

implementation


{ TAutorunWinCurentUserTest }

procedure TAutorunWinCurentUserTest.Setup;
begin
  FAutorun := TWinAutorunCurentUser.Create;
end;

{ TAutorunWinLocalMachineTest }

procedure TAutorunWinLocalMachineTest.Setup;
begin
  FAutorun := TWinAutorunLocalMachine.Create;
end;

initialization
  TDUnitX.RegisterTestFixture(TAutorunWinCurentUserTest);
  // {RUN AS ADMIN} TDUnitX.RegisterTestFixture(TAutorunWinLocalMachineTest);

end.

