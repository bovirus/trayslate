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

var
  // Registered clipboard formats for various text types
  CF_HTML_FORMAT: UINT = 0;
  CF_HTML_MIME:   UINT = 0;
  CF_TEXT_PLAIN:  UINT = 0;

// Simple HTML-to-text converter that strips all tags
function StripHTMLTags(const HTML: string): string;
var
  i: Integer;
  InTag: Boolean;
begin
  Result := '';
  InTag := False;
  for i := 1 to Length(HTML) do
  begin
    if HTML[i] = '<' then
      InTag := True
    else if HTML[i] = '>' then
      InTag := False
    else if not InTag then
      Result := Result + HTML[i];
  end;
end;

procedure TTextDropTarget.RegisterTarget;
begin
  if not Assigned(FTarget) or not FTarget.HandleAllocated then Exit;
  if FRegisteredHandle = FTarget.Handle then Exit;

  UnregisterTarget; // safety

  FImpl := TTextDropTargetImpl.Create(Self, FTarget);
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
  FImpl := nil;
end;

procedure TTextDropTarget.ForceRegister;
begin
  if Assigned(FTarget) and FTarget.HandleAllocated then
  begin
    if FRegisteredHandle = FTarget.Handle then Exit;
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
  Result := False;

  // Fill basic format fields once
  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;

  // Standard Windows text formats
  fmt.cfFormat := CF_UNICODETEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  fmt.cfFormat := CF_TEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);

  // HTML formats (Firefox, Chrome, etc.)
  if CF_HTML_FORMAT <> 0 then
  begin
    fmt.cfFormat := CF_HTML_FORMAT;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  end;
  if CF_HTML_MIME <> 0 then
  begin
    fmt.cfFormat := CF_HTML_MIME;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  end;

  // Raw MIME text/plain (Firefox often uses it)
  if CF_TEXT_PLAIN <> 0 then
  begin
    fmt.cfFormat := CF_TEXT_PLAIN;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
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
  isUnicode, isPlainText: Boolean;
  isHTML, isHTMLMime: Boolean;
  cf: UINT;
begin
  Result := E_FAIL;

  if not Assigned(FEdit) or not Assigned(FOwner) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit;
  end;

  // Prepare basic format request structure
  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;

  // Try to determine the best available format
  isUnicode := False;
  isPlainText := False;
  isHTML := False;
  isHTMLMime := False;

  // 1. CF_UNICODETEXT (preferred)
  fmt.cfFormat := CF_UNICODETEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then
    isUnicode := True
  else
  begin
    // 2. HTML Format (CF_HTML)
    if CF_HTML_FORMAT <> 0 then
    begin
      fmt.cfFormat := CF_HTML_FORMAT;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isHTML := True;
        cf := CF_HTML_FORMAT;
      end;
    end;
    // 3. text/html MIME
    if not isHTML and (CF_HTML_MIME <> 0) then
    begin
      fmt.cfFormat := CF_HTML_MIME;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isHTMLMime := True;
        cf := CF_HTML_MIME;
      end;
    end;
    // 4. text/plain MIME (Firefox)
    if not isHTML and not isHTMLMime and (CF_TEXT_PLAIN <> 0) then
    begin
      fmt.cfFormat := CF_TEXT_PLAIN;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isPlainText := True;
        cf := CF_TEXT_PLAIN;
      end;
    end;
    // 5. Fallback to CF_TEXT (ANSI)
    if not isHTML and not isHTMLMime and not isPlainText then
    begin
      fmt.cfFormat := CF_TEXT;
      if Failed(dataObj.QueryGetData(fmt)) then
      begin
        dwEffect := DROPEFFECT_NONE;
        Exit;
      end;
      // isUnicode stays False, but we have CF_TEXT
    end;
  end;

  // Set the final format for GetData
  if isUnicode then
    fmt.cfFormat := CF_UNICODETEXT
  else if isHTML or isHTMLMime then
    fmt.cfFormat := cf      // HTML or text/html
  else if isPlainText then
    fmt.cfFormat := CF_TEXT_PLAIN
  else
    fmt.cfFormat := CF_TEXT;

  // Actually retrieve the data
  if Failed(dataObj.GetData(fmt, stg)) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit;
  end;

  try
    // Extract text according to format
    if isUnicode then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        s := PWideChar(pText);
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else if isHTML or isHTMLMime then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        s := StripHTMLTags(string(PAnsiChar(pText))); // HTML is UTF-8 encoded
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else if isPlainText then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        // text/plain from Firefox is UTF-8; treat as such
        s := string(PAnsiChar(pText));
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else // CF_TEXT (ANSI)
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        s := string(PAnsiChar(pText));
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end;

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
    ReleaseStgMedium(stg);
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
initialization
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  CF_HTML_FORMAT := RegisterClipboardFormat('HTML Format');
  CF_HTML_MIME   := RegisterClipboardFormat('text/html');
  CF_TEXT_PLAIN  := RegisterClipboardFormat('text/plain');
finalization
  CoUninitialize;
{$ENDIF}

end.
