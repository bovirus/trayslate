//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit GlobalMouseHook;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Controls
  {$IFDEF WINDOWS}
  ,Windows
  ,Messages
  {$ENDIF}
  ;

type
  PMouseEventInfo = ^TMouseEventInfo;

  TMouseEventInfo = record
    Button: TMouseButton;
    X, Y: integer;
    Time: longword;         // system tick count (ms)
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
    FOnLeftDown, FOnLeftUp: TMouseEvent;
    FOnRightDown, FOnRightUp: TMouseEvent;
    FOnMiddleDown, FOnMiddleUp: TMouseEvent;
    procedure SetEnabled(AValue: boolean);
    {$IFDEF WINDOWS}
    class var FActiveInstance: TGlobalMouseHook;
    FHook: HHOOK;
    class function HookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    procedure InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    property Enabled: boolean read FEnabled write SetEnabled;
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
    p := {%H-}PMouseLLHookStruct(PtrUInt(lParam));
    FActiveInstance.InternalMouseEvent(wParam, p^);
  end;
  if FActiveInstance <> nil then
    Result := CallNextHookEx(FActiveInstance.FHook, nCode, wParam, lParam)
  else
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

procedure TGlobalMouseHook.InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
var
  info: TMouseEventInfo;
  handler: TMouseEvent;
begin
  info.X := p.pt.X;
  info.Y := p.pt.Y;
  info.Time := p.time;
  info.CtrlDown := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
  info.ShiftDown := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
  info.AltDown := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;

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

constructor TGlobalMouseHook.Create;
begin
  inherited;
  FEnabled := False;
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
