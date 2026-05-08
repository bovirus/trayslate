//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formpopup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Buttons,
  ExtCtrls,
  Graphics,
  Dialogs,
  StdCtrls,
  Clipbrd,
  Math,
  LCLType,
  LCLIntf,
  LMessages,
  textdroptarget;

type

  { TformPopupTrayslate }

  TformPopupTrayslate = class(TForm)
    FlowPairs: TFlowPanel;
    LabelWatermark: TLabel;
    MemoTarget: TMemo;
    PanelWatermark: TPanel;
    PanelButtonTarget: TPanel;
    SbCopyTarget: TSpeedButton;
    Timer: TTimer;

    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: boolean);
    procedure FormShow(Sender: TObject);
    procedure MemoTargetChange(Sender: TObject);
    procedure PanelWatermarkClick(Sender: TObject);
    procedure SbCopyTargetClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OnTextDroppedHandler(Sender: TObject; const AText: string);
  private
    FSourceText: string;
    FDropTarget: TTextDropTarget;

    procedure UpdateWatermarkVisibility;
  public
    property SourceText: string read FSourceText write FSourceText;
  end;

var
  formPopupTrayslate: TformPopupTrayslate;

implementation

uses mainform, systemtool;

  {$R *.lfm}

  { TformPopupTrayslate }

procedure TformPopupTrayslate.FormCreate(Sender: TObject);
begin
  FDropTarget := TTextDropTarget.Create(Self);
  FDropTarget.Target := MemoTarget;
  FDropTarget.InsertText := False;
  FDropTarget.OnTextDropped := @OnTextDroppedHandler;

  SbCopyTarget.ImageIndex := ThemeValue(10, 11);
  SbCopyTarget.PressedImageIndex := ThemeValue(12, 13);

  UpdateWatermarkVisibility;
end;

procedure TformPopupTrayslate.FormShow(Sender: TObject);
begin
  FDropTarget.ForceRegister;
end;

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

  PanelWatermark.Left := MemoTarget.Left + (MemoTarget.Width - PanelWatermark.Width) div 2;
  PanelWatermark.Top := MemoTarget.Top + (MemoTarget.Height - PanelWatermark.Height) div 2;

  UpdateWatermarkVisibility;
end;

procedure TformPopupTrayslate.FormChangeBounds(Sender: TObject);
begin
  formTrayslate.FormPopupLeft := Left;
  formTrayslate.FormPopupTop := Top;
end;

procedure TformPopupTrayslate.MemoTargetChange(Sender: TObject);
begin
  UpdateWatermarkVisibility;
end;

procedure TformPopupTrayslate.PanelWatermarkClick(Sender: TObject);
begin
  if MemoTarget.Enabled and MemoTarget.Visible and MemoTarget.CanFocus then
    MemoTarget.SetFocus;
end;

procedure TformPopupTrayslate.SbCopyTargetClick(Sender: TObject);
begin
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformPopupTrayslate.TimerTimer(Sender: TObject);
var
  CursorPos: TPoint;
  TargetAlpha: integer;
  DetectionRect: TRect;
const
  // Individual margins for each side (in pixels)
  MARGIN_LEFT = 10;
  MARGIN_RIGHT = 5; // Increased to compensate for invisible borders
  MARGIN_TOP = 40; // Covers the caption bar
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
  DetectionRect.Left := DetectionRect.Left - MARGIN_LEFT;
  DetectionRect.Top := DetectionRect.Top - MARGIN_TOP;
  DetectionRect.Right := DetectionRect.Right + MARGIN_RIGHT;
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

    UpdateWatermarkVisibility;
  end;
end;

procedure TformPopupTrayslate.OnTextDroppedHandler(Sender: TObject; const AText: string);
begin
  formTrayslate.TranslatePopup(AText);
end;

procedure TformPopupTrayslate.UpdateWatermarkVisibility;
begin
  PanelWatermark.Visible := (MemoTarget.Text = string.Empty);

  if (Width < PanelWatermark.Width) or (Height < PanelWatermark.Height + FlowPairs.Height) then
    PanelWaterMark.Visible := False;

  PanelButtonTarget.Visible := (Width > 100) and (Height > 50 + FlowPairs.Height);
end;

end.
