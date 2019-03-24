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
  public
    constructor Create(const AName, APath: string);
  public
    property Name: string read FName write FName;
    property Path: string read FPath write FPath;
    property IsNew: Boolean read FIsNew write FIsNew;
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
    function GetItem(Index: Integer): TAutorunItem;
    function GetItemByName(AName: string): TAutorunItem;
    procedure SetItem(Index: Integer; Value: TAutorunItem);
  public
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

{ TAutorunBase }

constructor TAutorunBase.Create;
begin
  FList := TObjectList<TAutorunItem>.Create;
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

