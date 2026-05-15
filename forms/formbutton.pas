//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formbutton;

{$mode ObjFPC}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,      // Required for CreateRoundRectRgn and SetWindowRgn
  {$ENDIF}
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  Buttons,
  ExtCtrls,
  LCLType;

type

  { TformButtonTrayslate }

  TformButtonTrayslate = class(TForm)
    SbTranslate: TSpeedButton;
    TimerHide: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SbTranslateClick(Sender: TObject);
    procedure SbTranslateMouseEnter(Sender: TObject);
    procedure SbTranslateMouseLeave(Sender: TObject);
    procedure TimerHideTimer(Sender: TObject);
  private
    FSourceText: string;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    property SourceText: string read FSourceText write FSourceText;
  end;

var
  formButtonTrayslate: TformButtonTrayslate;

implementation

uses mainform, systemtool;

  {$R *.lfm}

  { TformButtonTrayslate }

procedure TformButtonTrayslate.FormCreate(Sender: TObject);
{$IFDEF WINDOWS}
var
  Rgn: HRGN;
{$ENDIF}
begin
  // Apply localization
  ApplicationTranslate(language, self, formTrayslate.LoadCustomPoFile(formTrayslate.CustomPoFile));

  // Set the appropriate icon based on the theme
  SbTranslate.ImageIndex := ThemeValue(2, 3);
  Width := 27;
  Height := 27;

  // Remove standard window borders to allow custom rounded shape
  BorderStyle := bsNone;

  // Create a rounded-rectangle region for the form (radius = 6 pixels)
  {$IFDEF WINDOWS}
  Rgn := CreateRoundRectRgn(0, 0, Width, Height, 10, 10);
  SetWindowRgn(Handle, Rgn, True); // The system takes ownership of the region
  {$ENDIF}
  // For other platforms, TForm.SetShape with a bitmap can be used instead.
end;

procedure TformButtonTrayslate.FormShow(Sender: TObject);
begin
  TimerHide.Enabled := True;
end;

procedure TformButtonTrayslate.FormPaint(Sender: TObject);
begin
  Canvas.AntialiasingMode := amOn;
  Canvas.Pen.Width := 2;
  Canvas.Brush.Style := bsClear;

  Canvas.Pen.Color := clGray;
  Canvas.RoundRect(0, 0, Width - 2, Height - 2, 10, 10);
  Canvas.Pen.Color := clSilver;
  Canvas.RoundRect(0, 0, Width - 1, Height - 1, 10, 10);

  Canvas.Pen.Color := clWhite;
  Canvas.RoundRect(0, 0, Width, Height, 10, 10);
end;

procedure TformButtonTrayslate.SbTranslateClick(Sender: TObject);
begin
  // Hide the button and trigger the translation popup
  TimerHideTimer(Self);
  formTrayslate.TranslatePopup(SourceText, Left, Top);
end;

procedure TformButtonTrayslate.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {$IFDEF WINDOWS}
  // Prevent the form from taking focus (tool window style)
  Params.ExStyle := Params.ExStyle or WS_EX_NOACTIVATE;
  {$ENDIF}
end;

procedure TformButtonTrayslate.SbTranslateMouseEnter(Sender: TObject);
begin
  // Keep the button visible while the mouse is over it
  TimerHide.Enabled := False;
end;

procedure TformButtonTrayslate.SbTranslateMouseLeave(Sender: TObject);
begin
  // Resume auto-hide timer when the mouse leaves
  TimerHide.Enabled := True;
end;

procedure TformButtonTrayslate.TimerHideTimer(Sender: TObject);
begin
  // Automatically hide the form after a timeout
  TimerHide.Enabled := False;
  Hide;
end;

end.
