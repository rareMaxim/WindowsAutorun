unit Autorun.Windows.StartupDir;

interface

uses
  Autorun.Intrf;

type
  TAutorunItem = Autorun.Intrf.TAutorunItem;

  IAutorunManager = Autorun.Intrf.IAutorunManager;

  TWinAutorunByStartupDir = class(TInterfacedObject{, IAutorunManager})
  protected
    function GetStartupDirPath: string;
    procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
  public
  end;

implementation

uses
  Winapi.SHFolder,
  Winapi.ShlObj,
  Winapi.ActiveX,
  System.Win.ComObj,
  Winapi.Windows;

{ TWinAutorunByStartupDir }

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
  PFile.Save(PWChar(WideString(PathLink)), FALSE);
end;

function TWinAutorunByStartupDir.GetStartupDirPath: string;
const
  SHGFP_TYPE_CURRENT = 0;
  CSIDL_STARTUP = $0007; // Пуск - Программы - Автозагрузка
var
  path: array[0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_STARTUP, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

end.

