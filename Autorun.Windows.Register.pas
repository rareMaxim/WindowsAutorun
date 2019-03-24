unit Autorun.Windows.Register;

interface

uses
  Autorun.Intrf,
  System.Generics.Collections,
  System.Win.Registry;

type
  TAutorunItem = Autorun.Intrf.TAutorunItem;

  IAutorunManager = Autorun.Intrf.IAutorunManager;

  TWinAutorunRegisterBase = class abstract(TAutorunBase)
  private
    FReg: TRegistry;
  protected
    const
      AUTORUN_PATH = '\Software\Microsoft\Windows\CurrentVersion\Run';
  protected
    procedure ReadData;
    procedure SaveData;
    procedure FillKeyValues(AReg: TRegistry; AList: TList<TAutorunItem>);
  public
    procedure Add(const AName, APath: string);
    procedure Delete(const AName: string);
    function Count: Integer;
    constructor Create; override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    property Items[Index: Integer]: TAutorunItem read GetItem write SetItem;
  end;

  TWinAutorunCurentUser = class(TWinAutorunRegisterBase, IAutorunManager)
  public
    constructor Create; override;
  end;

  TWinAutorunLocalMachine = class(TWinAutorunRegisterBase, IAutorunManager)
  public
    constructor Create; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes,
  System.SysUtils;

{ TWinAutorunRegisterBase }

procedure TWinAutorunRegisterBase.Add(const AName, APath: string);
begin
  FList.Add(TAutorunItem.Create(AName, APath));
  FList.Last.IsNew := True;
end;

procedure TWinAutorunRegisterBase.AfterConstruction;
begin
  inherited;
  ReadData;
end;

function TWinAutorunRegisterBase.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TWinAutorunRegisterBase.Create;
begin
  inherited;
  FReg := TRegistry.Create;
end;

procedure TWinAutorunRegisterBase.Delete(const AName: string);
begin
  GetItemByName(AName).IsDelete := True;
end;

destructor TWinAutorunRegisterBase.Destroy;
begin
  SaveData;
  FreeAndNil(FReg);
  inherited;
end;

procedure TWinAutorunRegisterBase.FillKeyValues(AReg: TRegistry; AList: TList<
  TAutorunItem>);
var
  LKeys: TStringList;
  I: Integer;
begin
  LKeys := TStringList.Create();
  AList.Clear;
  try
    AReg.GetValueNames(LKeys);
    for I := 0 to LKeys.Count - 1 do
      AList.Add(TAutorunItem.Create(LKeys[I], AReg.ReadString(LKeys[I])));
  finally
    LKeys.Free;
  end;
end;

procedure TWinAutorunRegisterBase.ReadData;
begin
  if FReg.OpenKey(AUTORUN_PATH, False) then
  begin
    FillKeyValues(FReg, FList);
  end;
end;

procedure TWinAutorunRegisterBase.SaveData;
var
  MyElem: TAutorunItem;
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    MyElem := FList[I];
    if MyElem.IsNew then
      FReg.WriteString(MyElem.Name, MyElem.Path);
    if MyElem.IsDelete then
      FReg.DeleteValue(MyElem.Name);
  end;
end;

constructor TWinAutorunCurentUser.Create;
begin
  inherited;
  FReg.RootKey := HKEY_CURRENT_USER;
end;

{ TWinAutorunLocalMachine }

constructor TWinAutorunLocalMachine.Create;
begin
  inherited;
  FReg.RootKey := HKEY_LOCAL_MACHINE;
end;

end.

