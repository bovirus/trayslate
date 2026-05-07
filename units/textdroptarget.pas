//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit TextDropTarget;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls
  {$IFDEF WINDOWS}
  , Windows, ActiveX, ComObj
  {$ENDIF};

type
  TTextDropTarget = class;   // forward declaration

  TTextDropEvent = procedure(Sender: TObject; const Text: string) of object;

  {$IFDEF WINDOWS}
  // Internal helper implementing IDropTarget – lifetime fully controlled by interface references
  TTextDropTargetImpl = class(TInterfacedObject, IDropTarget)
  private
    FOwner: TTextDropTarget;
    FEdit: TCustomEdit;
    function HasTextFormat(const dataObj: IDataObject): Boolean;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
    function DragOver(grfKeyState: DWORD; pt: TPoint;
      var dwEffect: DWORD): HRESULT; stdcall;
    function DragLeave: HRESULT; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
  public
    constructor Create(AOwner: TTextDropTarget; AEdit: TCustomEdit);
  end;
  {$ENDIF}

  TTextDropTarget = class(TComponent)
  private
    FTarget: TCustomEdit;
    FInsertText: boolean;
    FOnTextDropped: TTextDropEvent;
    {$IFDEF WINDOWS}
    FImpl: IDropTarget;
    FRegisteredHandle: HWND;
    procedure RegisterTarget;
    procedure UnregisterTarget;
    {$ENDIF}
    procedure SetTarget(AValue: TCustomEdit);
    procedure SetInsertText(AValue: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoTextDropped(const Text: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ForceRegister;
  published
    property Target: TCustomEdit read FTarget write SetTarget;
    property InsertText: boolean read FInsertText write SetInsertText default True;
    property OnTextDropped: TTextDropEvent read FOnTextDropped write FOnTextDropped;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Common Controls', [TTextDropTarget]);
end;

{ TTextDropTarget }

constructor TTextDropTarget.Create(AOwner: TComponent);
begin
  inherited;
  FTarget := nil;
  FInsertText := True;
  FOnTextDropped := nil;
  {$IFDEF WINDOWS}
  FImpl := nil;
  FRegisteredHandle := 0;
  {$ENDIF}
end;

destructor TTextDropTarget.Destroy;
begin
  Target := nil;  // unregister (calls UnregisterTarget which releases FImpl)
  inherited;
end;

procedure TTextDropTarget.SetTarget(AValue: TCustomEdit);
begin
  if FTarget = AValue then Exit;

  {$IFDEF WINDOWS}
  UnregisterTarget;
  {$ENDIF}

  FTarget := AValue;

  {$IFDEF WINDOWS}
  if Assigned(FTarget) then
  begin
    FTarget.FreeNotification(Self);
    if FTarget.HandleAllocated then
      RegisterTarget;
  end;
  {$ENDIF}
end;

procedure TTextDropTarget.SetInsertText(AValue: boolean);
begin
  if FInsertText = AValue then Exit;
  FInsertText := AValue;
end;

procedure TTextDropTarget.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FTarget) then
    Target := nil;
end;

procedure TTextDropTarget.DoTextDropped(const Text: string);
begin
  if Assigned(FOnTextDropped) then
    FOnTextDropped(Self, Text);
end;

{$IFDEF WINDOWS}
procedure TTextDropTarget.RegisterTarget;
begin
  if not Assigned(FTarget) or not FTarget.HandleAllocated then Exit;
  if FRegisteredHandle = FTarget.Handle then Exit;

  UnregisterTarget; // safety

  FImpl := TTextDropTargetImpl.Create(Self, FTarget);   // store as interface
  OleCheck(RegisterDragDrop(FTarget.Handle, FImpl));
  FRegisteredHandle := FTarget.Handle;
end;

procedure TTextDropTarget.UnregisterTarget;
begin
  if FRegisteredHandle <> 0 then
  begin
    if IsWindow(FRegisteredHandle) then
      RevokeDragDrop(FRegisteredHandle);
    FRegisteredHandle := 0;
  end;
  // Release our own interface reference – object will self-destroy if this was the last reference
  FImpl := nil;
end;

procedure TTextDropTarget.ForceRegister;
begin
  if Assigned(FTarget) and FTarget.HandleAllocated then
  begin
    if FRegisteredHandle = FTarget.Handle then
      Exit; // already registered for this handle
    UnregisterTarget;
    RegisterTarget;
  end
  else
    UnregisterTarget;
end;

{ TTextDropTargetImpl }

constructor TTextDropTargetImpl.Create(AOwner: TTextDropTarget; AEdit: TCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
  FEdit := AEdit;
end;

function TTextDropTargetImpl.HasTextFormat(const dataObj: IDataObject): Boolean;
var
  fmt: TFormatEtc;
begin
  fmt.cfFormat := CF_UNICODETEXT;
  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;
  Result := Succeeded(dataObj.QueryGetData(fmt));
  if not Result then
  begin
    fmt.cfFormat := CF_TEXT;
    Result := Succeeded(dataObj.QueryGetData(fmt));
  end;
end;

function TTextDropTargetImpl.DragEnter(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
begin
  if HasTextFormat(dataObj) then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
end;

function TTextDropTargetImpl.DragOver(grfKeyState: DWORD; pt: TPoint;
  var dwEffect: DWORD): HRESULT; stdcall;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TTextDropTargetImpl.DragLeave: HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TTextDropTargetImpl.Drop(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
var
  fmt: TFormatEtc;
  stg: TStgMedium;
  pText: PChar;
  s: string;
  ClientPt: TPoint;
  CharIdx: LResult;
  isUnicode: Boolean;
begin
  Result := E_FAIL;

  if not Assigned(FEdit) or not Assigned(FOwner) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit;
  end;

  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;

  fmt.cfFormat := CF_UNICODETEXT;
  isUnicode := Succeeded(dataObj.QueryGetData(fmt));
  if not isUnicode then
  begin
    fmt.cfFormat := CF_TEXT;
    if Failed(dataObj.QueryGetData(fmt)) then
    begin
      dwEffect := DROPEFFECT_NONE;
      Exit;
    end;
  end;

  if Failed(dataObj.GetData(fmt, stg)) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit;
  end;

  try
    pText := GlobalLock(stg.hGlobal);
    if not Assigned(pText) then Exit;
    try
      if isUnicode then
        s := PWideChar(pText)
      else
        s := string(PAnsiChar(pText));

      // Always fire event first
      FOwner.DoTextDropped(s);

      // Insert into edit only if allowed
      if FOwner.InsertText then
      begin
        ClientPt := FEdit.ScreenToClient(pt);
        CharIdx := SendMessage(FEdit.Handle, EM_CHARFROMPOS, 0,
          MakeLParam(ClientPt.X, ClientPt.Y));
        FEdit.SelStart := LoWord(CharIdx);
        FEdit.SelText := s;
      end;

      dwEffect := DROPEFFECT_COPY;
      Result := S_OK;
    finally
      GlobalUnlock(stg.hGlobal);
    end;
  finally
    ReleaseStgMedium(stg);
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
initialization
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
finalization
  CoUninitialize;
{$ENDIF}

end.
