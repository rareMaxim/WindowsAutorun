unit Autorun.Windows;

interface

uses
  System.Generics.Collections,
  System.Win.Registry;

type
  TAutorunItem = class
  private
    FPath: string;
    FName: string;
    FIsNew: Boolean;
    FIsDelete: Boolean;
  public
    constructor Create(const AName, APath: string);
  public
    property Name: string read FName write FName;
    property Path: string read FPath write FPath;
    property IsNew: Boolean read FIsNew;
    property IsDelete: Boolean read FIsDelete;
  end;

  IAutorunManager = interface
    ['{C64D020B-E4B4-42BE-A2CA-BDEFCC15539A}']
    function GetItem(Index: Integer): TAutorunItem;
    function GetItemByName(AName: string): TAutorunItem;
    procedure SetItem(Index: Integer; Value: TAutorunItem);
    //
    procedure ReadData;
    procedure SaveData;
    //
    procedure Add(const AName, APath: string);
    procedure Delete(const AName: string);
    function Count: Integer;
    property Items[Index: Integer]: TAutorunItem read GetItem write SetItem;
    property ItemsByName[Name: string]: TAutorunItem read GetItemByName;
  end;

  TWinAutorunRegisterBase = class abstract(TInterfacedObject)
  private
    FReg: TRegistry;
    FList: TObjectList<TAutorunItem>;
    function GetItem(Index: Integer): TAutorunItem;
    function GetItemByName(AName: string): TAutorunItem;
    procedure SetItem(Index: Integer; Value: TAutorunItem);
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
    constructor Create; virtual;
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
  WinApi.Windows,
  System.Classes,
  System.SysUtils;

{ TWinAutorunRegisterBase }

procedure TWinAutorunRegisterBase.Add(const AName, APath: string);
begin
  FList.Add(TAutorunItem.Create(AName, APath));
  FList.Last.FIsNew := True;
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
  FReg := TRegistry.Create;
  FList := TObjectList<TAutorunItem>.Create;
end;

procedure TWinAutorunRegisterBase.Delete(const AName: string);
begin
  GetItemByName(AName).FIsDelete := True;
end;

destructor TWinAutorunRegisterBase.Destroy;
begin

  SaveData;
  FreeAndNil(FList);
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
    begin
      AList.Add(TAutorunItem.Create(LKeys[I], AReg.ReadString(LKeys[I])));
      AList.Last.FIsNew := False;
    end;
  finally
    LKeys.Free;
  end;
end;

function TWinAutorunRegisterBase.GetItem(Index: Integer): TAutorunItem;
begin
  Result := FList[Index];
end;

function TWinAutorunRegisterBase.GetItemByName(AName: string): TAutorunItem;
var
  MyElem: TAutorunItem;
begin
  Result := nil;
  for MyElem in FList do
    if MyElem.Name = AName then
    begin
      Result := MyElem;
      Break;
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

procedure TWinAutorunRegisterBase.SetItem(Index: Integer; Value: TAutorunItem);
begin
  FList[Index] := Value;
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

{ TAutorunItem }

constructor TAutorunItem.Create(const AName, APath: string);
begin
  FName := AName;
  FPath := APath;
  FIsNew := False;
  FIsDelete := False;
end;

end.

