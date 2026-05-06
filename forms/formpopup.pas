unit formpopup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  Math,
  ActnList,
  LCLType,
  LCLIntf,
  LMessages,
  ExtCtrls;

type

  { TformPopupTrayslate }

  TformPopupTrayslate = class(TForm)
    FlowPairs: TFlowPanel;
    MemoTarget: TMemo;
    Timer: TTimer;
    procedure FormChangeBounds(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: boolean);
    procedure TimerTimer(Sender: TObject);
  private
    FSourceText: string;
    //procedure CMMouseEnter(var Message: TLMessage); message CM_MOUSEENTER;
    //procedure CMMouseLeave(var Message: TLMessage); message CM_MOUSELEAVE;
  public
    property SourceText: string read FSourceText write FSourceText;
  end;

var
  formPopupTrayslate: TformPopupTrayslate;

implementation

uses mainform;

  {$R *.lfm}

  { TformPopupTrayslate }

procedure TformPopupTrayslate.FormShortCut(var Msg: TLMKey; var Handled: boolean);
begin
  if Msg.CharCode = VK_ESCAPE then
  begin
    Close;
    Handled := True;
  end;
end;

procedure TformPopupTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormPopupWidth := Width;
  formTrayslate.FormPopupHeight := Height;
end;

procedure TformPopupTrayslate.FormChangeBounds(Sender: TObject);
begin
  formTrayslate.FormPopupLeft := Left;
  formTrayslate.FormPopupTop := Top;
end;

procedure TformPopupTrayslate.TimerTimer(Sender: TObject);
var
  CursorPos: TPoint;
  TargetAlpha: Integer;
  DetectionRect: TRect;
const
  // Individual margins for each side (in pixels)
  MARGIN_LEFT   = 10;
  MARGIN_RIGHT  = 5; // Increased to compensate for invisible borders
  MARGIN_TOP    = 40; // Covers the caption bar
  MARGIN_BOTTOM = 5; // Increased for easier resizing
begin
  // Exit early if the form is not visible or is being destroyed
  if not Self.Visible or (csDestroying in Self.ComponentState) then
    Exit;

  // Safety check for the settings form to avoid Access Violation
  if not Assigned(formTrayslate) then
    Exit;

  // Convert global screen mouse position to local coordinates (0,0 is Top-Left of ClientArea)
  CursorPos := Self.ScreenToClient(Mouse.CursorPos);

  // Start with the basic client area rectangle
  DetectionRect := Self.ClientRect;

  // Manually expand the detection area to cover title bar and invisible borders
  DetectionRect.Left   := DetectionRect.Left - MARGIN_LEFT;
  DetectionRect.Top    := DetectionRect.Top - MARGIN_TOP;
  DetectionRect.Right  := DetectionRect.Right + MARGIN_RIGHT;
  DetectionRect.Bottom := DetectionRect.Bottom + MARGIN_BOTTOM;

  // Check if the relative mouse position is within our expanded virtual rect
  if PtInRect(DetectionRect, CursorPos) then
  begin
    // Mouse is within range (including margins)
    TargetAlpha := Round(EnsureRange(formTrayslate.OpacityHover, 0, 100) * 255 / 100);
  end
  else
  begin
    // Mouse is outside the detection zone
    TargetAlpha := Round(EnsureRange(formTrayslate.OpacityIdle, 0, 100) * 255 / 100);
  end;

  // Apply AlphaBlendValue only when it changes to avoid UI flicker
  if Self.AlphaBlendValue <> TargetAlpha then
  begin
    if not Self.AlphaBlend then
      Self.AlphaBlend := True;

    Self.AlphaBlendValue := TargetAlpha;
  end;
end;

end.
