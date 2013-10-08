unit WebUi;

interface

uses
  Windows,  SysUtils, Variants, Classes, Controls, Forms,
  ShellApi, StdCtrls, ExtCtrls, INIFiles, Tlhelp32;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  myINI : TINIFile;
  Form1: TForm1;
  WindowList: TList;

implementation

{$R *.dfm}

function pKill(ExeFileName: string): Boolean;
const
  PROCESS_TERMINATE = $0001;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      Result := TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function GetHandle(windowtitle: string): HWND;
var
  h, TopWindow: HWND;
  Dest: array[0..80] of char;
  i: integer;
  s: string;
  function getWindows(Handle: HWND; Info: Pointer): BOOL; stdcall;
    begin
      Result:= True;
      WindowList.Add(Pointer(Handle));
    end;
begin
  result:= 0;
  try
    WindowList:= TList.Create;
    TopWindow:= Application.Handle;
    EnumWindows(@getWindows, Longint(@TopWindow));
    i:= 0;
    while (i < WindowList.Count) and (result = 0) do
      begin
        GetWindowText(HWND(WindowList[i]), Dest, sizeof(Dest) - 1);
        s:= dest;
        if length(s) > 0 then
          begin
            if (Pos(UpperCase(Windowtitle), UpperCase(s)) >= 1) then
              begin
                h:= HWND(WindowList[i]);
                if IsWindow(h) then
                  result:= h
             end
           end;
        inc(i)
      end
    finally
      WindowList.Free;
    end;
end;

function StrToPansi(stringVar : string) : PAnsiChar;
Var
  AnsString : AnsiString;
  InternalError : Boolean;
begin
  InternalError := false;
  Result := '';
  try
    if stringVar <> '' Then
    begin
       AnsString := AnsiString(StringVar);
       Result := PAnsiChar(PAnsiString(AnsString));
    end;
  Except
    InternalError := true;
  end;
  if InternalError or (String(Result) <> stringVar) then
  begin
    Raise Exception.Create('Conversion from string to PAnsiChar failed!');
  end;
end;

procedure RunSimba;
var
Handle:HWND;
begin
    ShellExecute(Handle, 'open', 'c:\Simba\Simba.exe', nil, nil, SW_SHOWNORMAL)
end;

Procedure RewriteLog;
begin
    myINI := TINIFile.Create('C:\Simba\WebCommandLog.ini');
    myINI.WriteString('ScriptToRun', 'name', '');
    myINI.WriteString('ActionToPerform','name', '');
    myINI.Free;
end;

Procedure WriteLog;
var
   myFile : TextFile;
   text   : string;
begin
   AssignFile(myFile, 'WebCommandLog.ini');
   ReWrite(myFile);
   WriteLn(myFile, 'Simba has Started correctly');
   CloseFile(myFile);
end;

Function ReadLog:string;
var
   myFile : TextFile;
   text   : string;
begin
    AssignFile(myFile, 'WebCommandLog.ini');
    Reset(myFile);
    ReadLn(myFile, text);
    CloseFile(myFile);
    Result:=text;
end;

Procedure KeyDown(KeyID : Integer);
begin
  Keybd_Event(KeyID, 1, 0, 0);
end;

Procedure KeyUp(KeyID : Integer);
begin
  Keybd_Event(KeyID, 1, KEYEVENTF_KEYUP, 0);
end;

procedure TypeByte(k: Byte);
begin
  KeyDown(k);
  Sleep(10 + Random(50));
  KeyUp(k);
end;

procedure Activate;
var
SimbaHwnd: Hwnd;
begin
    SimbaHwnd:=GetHandle('Simba');
    SetForegroundWindow(SimbaHwnd);
end;

procedure PlayScript;
begin
    //Activate;
    TypeByte(vk_f9);
end;

procedure OpenScript(ScriptName:PAnsiChar);
var
Handle:HWND;
Loc:PAnsiChar;
begin
   Loc:=StrToPansi('C:\Simba\Scripts\'+ScriptName+'.simba');
   ShellExecute(Handle, 'open', Loc, nil, nil, SW_SHOWNORMAL)
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
Action:string;
begin
    myINI := TINIFile.Create('C:\Simba\WebCommandLog.ini');
    Action:= myINI.ReadString('ActionToPerform','name', '');
  if Action = 'RunScript' then
  begin
      pKill('Simba.exe');
    try
      OpenScript(StrToPansi(myINI.ReadString('ScriptToRun','name','non')));
      myINI.Free;
      sleep(3000);
      PlayScript;
      RewriteLog;
    except
      exit;
    end;
  end;
end;


end.
