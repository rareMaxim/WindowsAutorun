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

procedure TWinAutorunRegisterBase.AfterConstruction;
begin
  inherited;
  ReadData;
end;

constructor TWinAutorunRegisterBase.Create;
begin
  inherited;
  FReg := TRegistry.Create;
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
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    if FList[I].IsDelete then
      FReg.DeleteValue(FList[I].Name);
    if FList[I].IsNew then
      FReg.WriteString(FList[I].Name, FList[I].Path);
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

