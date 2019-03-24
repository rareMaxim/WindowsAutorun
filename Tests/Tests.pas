unit Tests;

interface

uses
  Autorun.Windows,
  DUnitX.TestFramework;

type
  TAutorunWinBaseTest = class
  private
    FAutorun: IAutorunManager;
  public
    [Setup]
    procedure Setup; virtual; abstract;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure NewRecord;
    [Test]
    procedure Read;
    [Test]
    procedure Update;
    [Test]
    procedure Delete;
  end;

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

uses
  System.SysUtils;

procedure TAutorunWinBaseTest.Delete;
begin
  FAutorun.Delete('test');
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.IsNull(FAutorun.ItemsByName['test']);
end;

procedure TAutorunWinBaseTest.NewRecord;
begin
  FAutorun.Add('test', 'testPath');
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.IsNotNull(FAutorun.ItemsByName['test'] <> nil);
end;

procedure TAutorunWinBaseTest.Read;
begin
  FAutorun.Add('test', 'testPath');
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.AreEqual('testPath', FAutorun.ItemsByName['test'].Path);
end;

procedure TAutorunWinBaseTest.TearDown;
begin
  FAutorun := nil;
end;

procedure TAutorunWinBaseTest.Update;
begin
  FAutorun.Add('test', 'testPath');
  FAutorun.SaveData;
  FAutorun.ReadData;
  FAutorun.Add('test', 'testPathNew');
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.AreEqual('testPathNew', FAutorun.ItemsByName['test'].Path);
  FAutorun.Add('test', 'testPath');
  FAutorun.SaveData;
end;

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

