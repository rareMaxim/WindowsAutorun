unit Autorun.Intrf;

interface

uses
  System.Generics.Collections;

type
  TAutorunItem = class
  private
    FPath: string;
    FName: string;
    FIsNew: Boolean;
    FIsDelete: Boolean;
    procedure SetIsNew(const Value: Boolean);
  public
    constructor Create(const AName, APath: string);
  public
    property Name: string read FName write FName;
    property Path: string read FPath write FPath;
    property IsNew: Boolean read FIsNew write SetIsNew;
    property IsDelete: Boolean read FIsDelete write FIsDelete;
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

  TAutorunBase = class abstract(TInterfacedObject)
  protected
    FList: TObjectList<TAutorunItem>;
    function GetItem(Index: Integer): TAutorunItem; virtual;
    function GetItemByName(AName: string): TAutorunItem; virtual;
    procedure SetItem(Index: Integer; Value: TAutorunItem); virtual;
  public
    procedure Add(const AName, APath: string); virtual;
    procedure Delete(const AName: string); virtual;
    function Count: Integer; virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;
{ TAutorunItem }

constructor TAutorunItem.Create(const AName, APath: string);
begin
  FName := AName;
  FPath := APath;
  FIsNew := False;
  FIsDelete := False;
end;

procedure TAutorunItem.SetIsNew(const Value: Boolean);
begin
  FIsNew := Value;
  if Value then
    FIsDelete := True;
end;

{ TAutorunBase }

procedure TAutorunBase.Add(const AName, APath: string);
begin
  FList.Add(TAutorunItem.Create(AName, APath));
  FList.Last.IsNew := True;
end;

function TAutorunBase.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TAutorunBase.Create;
begin
  FList := TObjectList<TAutorunItem>.Create;
end;

procedure TAutorunBase.Delete(const AName: string);
var
  LItem: TAutorunItem;
begin
  LItem := GetItemByName(AName);
  if Assigned(LItem) then
    LItem.IsDelete := True;
end;

destructor TAutorunBase.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TAutorunBase.GetItem(Index: Integer): TAutorunItem;
begin
  Result := FList[Index];
end;

function TAutorunBase.GetItemByName(AName: string): TAutorunItem;
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

procedure TAutorunBase.SetItem(Index: Integer; Value: TAutorunItem);
begin
  FList[Index] := Value;
end;

end.

