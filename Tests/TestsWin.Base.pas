unit TestsWin.Base;

interface

uses
  Autorun.Windows.Register,
  DUnitX.TestFramework;

type
  TAutorunWinBaseTest = class
  protected
    FAutorun: IAutorunManager;
    function GetName: string;
    function GetPath: string;
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
    procedure Delete;
  end;

implementation

uses
  System.SysUtils;

{ TAutorunWinBaseTest }

procedure TAutorunWinBaseTest.Delete;
begin
  FAutorun.Delete(GetName);
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.IsNull(FAutorun.ItemsByName[GetName]);
end;

function TAutorunWinBaseTest.GetName: string;
begin
  Result := ExtractFileName(GetPath);
end;

function TAutorunWinBaseTest.GetPath: string;
begin
  Result := ParamStr(0);
end;

procedure TAutorunWinBaseTest.NewRecord;
begin
  FAutorun.Add(GetName, GetPath);
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.IsNotNull(FAutorun.ItemsByName[GetName]);
end;

procedure TAutorunWinBaseTest.Read;
begin
  FAutorun.Add(GetName, GetPath);
  FAutorun.SaveData;
  FAutorun.ReadData;
  Assert.AreEqual(GetPath, FAutorun.ItemsByName[GetName].Path);
end;

procedure TAutorunWinBaseTest.TearDown;
begin
  FAutorun := nil;
end;

end.

