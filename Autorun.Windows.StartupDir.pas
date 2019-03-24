unit Autorun.Windows.StartupDir;

interface

uses
  Autorun.Intrf;

type
  TAutorunItem = Autorun.Intrf.TAutorunItem;

  IAutorunManager = Autorun.Intrf.IAutorunManager;

  TWinAutorunByStartupDir = class(TAutorunBase, IAutorunManager)
  protected
    function GetStartupDirPath: string;
    procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
    procedure DeleteFile(const AName: string);
  public
    procedure ReadData;
    procedure SaveData;
    constructor Create; override;
  end;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  System.Win.ComObj,
  Winapi.SHFolder,
  Winapi.ShlObj,
  Winapi.ActiveX,
  Winapi.Windows;

{ TWinAutorunByStartupDir }

constructor TWinAutorunByStartupDir.Create;
begin
  inherited;
  CoInitialize(nil);
end;

procedure TWinAutorunByStartupDir.CreateLink(const PathObj, PathLink, Desc,
  Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), False);
end;

procedure TWinAutorunByStartupDir.DeleteFile(const AName: string);
begin
  if TFile.Exists(AName) then
    TFile.Delete(AName);
end;

function TWinAutorunByStartupDir.GetStartupDirPath: string;
const
  SHGFP_TYPE_CURRENT = 0;
  CSIDL_STARTUP = $0007; // Пуск - Программы - Автозагрузка
var
  path: array[0..MAX_PATH] of Char;
begin
  if Succeeded(SHGetFolderPath(0, CSIDL_STARTUP, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

procedure TWinAutorunByStartupDir.ReadData;
var
  LFile: string;
  LFileName: string;
begin
  for LFile in TDirectory.GetFiles(GetStartupDirPath) do
  begin
    LFileName := TPath.GetFileName(LFile);
    if LFileName <> 'desktop.ini' then
      FList.Add(TAutorunItem.Create(LFileName, LFile));
  end;
end;

procedure TWinAutorunByStartupDir.SaveData;
var
  I: Integer;
  LinkFile: string;
begin
  for I := 0 to FList.Count - 1 do
  begin
    LinkFile := TPath.Combine(GetStartupDirPath, FList[I].Name);
    LinkFile := TPath.ChangeExtension(LinkFile, '.lnk');
    if FList[I].IsDelete then
      DeleteFile(LinkFile);
    if FList[I].IsNew then
      CreateLink(FList[I].path, LinkFile, '', '');
  end;
end;

end.

