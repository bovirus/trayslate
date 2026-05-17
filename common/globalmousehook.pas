//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit GlobalMouseHook;

{$NOTES OFF}
{$HINTS OFF}
{$WARNINGS OFF}

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Controls
  {$IFDEF WINDOWS}
  , Windows
  , Messages
  {$ENDIF}
  ;

type
  PMouseEventInfo = ^TMouseEventInfo;

  TMouseEventInfo = record
    Button: TMouseButton;
    X, Y: integer;
    Time: longword;
    CtrlDown: boolean;
    ShiftDown: boolean;
    AltDown: boolean;
  end;

  TMouseEvent = procedure(Sender: TObject; const Info: TMouseEventInfo) of object;

  {$IFDEF WINDOWS}
type
  PMouseLLHookStruct = ^TMouseLLHookStruct;
  TMouseLLHookStruct = record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;
  {$ENDIF}

  TGlobalMouseHook = class
  private
    FEnabled: boolean;
    FEditFieldOnly: boolean;
    FOnLeftDown, FOnLeftUp: TMouseEvent;
    FOnRightDown, FOnRightUp: TMouseEvent;
    FOnMiddleDown, FOnMiddleUp: TMouseEvent;
    procedure SetEnabled(AValue: boolean);
    {$IFDEF WINDOWS}
    class var FActiveInstance: TGlobalMouseHook;
    FHook: HHOOK;
    class function HookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    procedure InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
    function IsEditControl(Wnd: THandle): Boolean;
    function IsDropDownWindow(Wnd: THandle): Boolean;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    property Enabled: boolean read FEnabled write SetEnabled;
    property EditFieldOnly: boolean read FEditFieldOnly write FEditFieldOnly;
    property OnLeftDown: TMouseEvent read FOnLeftDown write FOnLeftDown;
    property OnLeftUp: TMouseEvent read FOnLeftUp write FOnLeftUp;
    property OnRightDown: TMouseEvent read FOnRightDown write FOnRightDown;
    property OnRightUp: TMouseEvent read FOnRightUp write FOnRightUp;
    property OnMiddleDown: TMouseEvent read FOnMiddleDown write FOnMiddleDown;
    property OnMiddleUp: TMouseEvent read FOnMiddleUp write FOnMiddleUp;
    class function IsCtrlPressed: boolean;
    class function IsShiftPressed: boolean;
    class function IsAltPressed: boolean;
  end;

  {$IFDEF WINDOWS}
const
  WH_MOUSE_LL = 14;
  {$ENDIF}

implementation

{$IFDEF WINDOWS}
class function TGlobalMouseHook.HookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  p: PMouseLLHookStruct;
begin
  if (nCode >= 0) and (FActiveInstance <> nil) then
  begin
    p := PMouseLLHookStruct(Pointer(PtrUInt(lParam)));
    FActiveInstance.InternalMouseEvent(wParam, p^);
  end;
  if FActiveInstance <> nil then
    Result := CallNextHookEx(FActiveInstance.FHook, nCode, wParam, lParam)
  else
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

function TGlobalMouseHook.IsDropDownWindow(Wnd: THandle): Boolean;
var
  szClass: array[0..255] of Char;
begin
  Result := False;
  if Wnd = 0 then Exit;
  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    // ComboLBox is the class of the popup list in a ComboBox
    if StrIComp(szClass, 'ComboLBox') = 0 then Exit(True);
  end;
end;

function TGlobalMouseHook.IsEditControl(Wnd: THandle): Boolean;
const
  TextEditClasses: array[0..11] of PChar = (
    'Edit', 'RichEdit20A', 'RichEdit50W', 'TMemo', 'TEdit',
    'Scintilla',
    'Chrome_RenderWidgetHostHWND',
    'MozillaContentWindowClass',
    'Internet Explorer_Server',
    'OperaWindowClass',
    'Windows.UI.Core.CoreWindow',
    'Afx:FrameOrView:100'
  );
var
  szClass: array[0..255] of Char;
  i: Integer;
  pid: DWORD;
  hProc: THandle;
  fileName: array[0..MAX_PATH] of WideChar;
  len: DWORD;
  s: WideString;
  j: Integer;
  dwStart, dwEnd: DWORD;
begin
  Result := False;
  if Wnd = 0 then Exit;

  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    for i := Low(TextEditClasses) to High(TextEditClasses) do
      if StrIComp(szClass, TextEditClasses[i]) = 0 then
        Exit(True);
  end;

  GetWindowThreadProcessId(HWND(Wnd), @pid);
  hProc := OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, False, pid);
  if hProc <> 0 then
  begin
    len := MAX_PATH;
    if QueryFullProcessImageNameW(hProc, 0, @fileName[0], @len) then
    begin
      SetString(s, PWideChar(@fileName[0]), len);
      j := LastDelimiter('\', string(s));
      if (j > 0) and (StrIComp(PWideChar(@s[j+1]), 'explorer.exe') = 0) then
      begin
        CloseHandle(hProc);
        Exit(False);
      end;
    end;
    CloseHandle(hProc);
  end;

  if SendMessageTimeout(HWND(Wnd), EM_GETSEL, WPARAM(@dwStart), LPARAM(@dwEnd),
                        SMTO_ABORTIFHUNG, 20, nil) <> 0 then
    Exit(True);
end;

procedure TGlobalMouseHook.InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
var
  info: TMouseEventInfo;
  handler: TMouseEvent;
  wndHandle: THandle;
  R: TRect;
  Pt: TPoint;
begin
  info.X := p.pt.X;
  info.Y := p.pt.Y;
  info.Time := p.time;
  info.CtrlDown := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
  info.ShiftDown := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
  info.AltDown := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;

  // --- Global drop-down list guard (always active) ---
  if (wParam = WM_LBUTTONDOWN) or (wParam = WM_LBUTTONUP) then
  begin
    wndHandle := THandle(WindowFromPoint(p.pt));
    if IsDropDownWindow(wndHandle) then
      Exit;   // Ignore clicks inside drop‑down lists (ComboBox, etc.)
  end;
  // ----------------------------------------------------

  // Apply EditFieldOnly filter only if the option is enabled
  if FEditFieldOnly then
  begin
    wndHandle := THandle(WindowFromPoint(p.pt));
    if (wndHandle = 0) or (not IsEditControl(wndHandle)) then
      Exit;

    // Additional check: release must be in the client area of the edit window
    if wParam = WM_LBUTTONUP then
    begin
      if GetClientRect(wndHandle, @R) then
      begin
        Pt := p.pt;
        ScreenToClient(wndHandle, Pt);
        if not PtInRect(R, Pt) then
          Exit;   // physically the cursor is outside the editing area - suppress the event
      end;
    end;
  end;

  handler := nil;
  case wParam of
    WM_LBUTTONDOWN: begin info.Button := mbLeft; handler := FOnLeftDown; end;
    WM_LBUTTONUP:   begin info.Button := mbLeft; handler := FOnLeftUp;   end;
    WM_RBUTTONDOWN: begin info.Button := mbRight; handler := FOnRightDown; end;
    WM_RBUTTONUP:   begin info.Button := mbRight; handler := FOnRightUp;  end;
    WM_MBUTTONDOWN: begin info.Button := mbMiddle; handler := FOnMiddleDown; end;
    WM_MBUTTONUP:   begin info.Button := mbMiddle; handler := FOnMiddleUp;  end;
  end;

  if Assigned(handler) then
    handler(Self, info);
end;

constructor TGlobalMouseHook.Create;
begin
  inherited;
  FHook := 0;
  FEnabled := False;
  FEditFieldOnly := False;
end;

destructor TGlobalMouseHook.Destroy;
begin
  Enabled := False;
  inherited;
end;

procedure TGlobalMouseHook.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then Exit;
  if AValue then
  begin
    if FActiveInstance <> nil then
      raise Exception.Create('Only one TGlobalMouseHook can be active at a time.');
    FActiveInstance := Self;
    FHook := SetWindowsHookEx(WH_MOUSE_LL, @HookProc, 0, 0);
    if FHook = 0 then
    begin
      FActiveInstance := nil;
      RaiseLastOSError;
    end;
    FEnabled := True;
  end
  else
  begin
    if FHook <> 0 then
    begin
      UnhookWindowsHookEx(FHook);
      FHook := 0;
    end;
    FActiveInstance := nil;
    FEnabled := False;
  end;
end;

class function TGlobalMouseHook.IsCtrlPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
end;

class function TGlobalMouseHook.IsShiftPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
end;

class function TGlobalMouseHook.IsAltPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;
end;

{$ELSE}

// Non Windows stub – compiles but does nothing

constructor TGlobalMouseHook.Create;
begin
  inherited;
  FEnabled := False;
  FEditFieldOnly := False;
end;

destructor TGlobalMouseHook.Destroy;
begin
  inherited;
end;

procedure TGlobalMouseHook.SetEnabled(AValue: boolean);
begin
  if AValue then
    raise Exception.Create('GlobalMouseHook is only supported on Windows.');
end;

class function TGlobalMouseHook.IsCtrlPressed: boolean;
begin
  Result := False;
end;

class function TGlobalMouseHook.IsShiftPressed: boolean;
begin
  Result := False;
end;

class function TGlobalMouseHook.IsAltPressed: boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
