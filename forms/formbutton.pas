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
  Windows,
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
begin
  ApplicationTranslate(language, self, formTrayslate.LoadCustomPoFile(formTrayslate.CustomPoFile));

  SbTranslate.ImageIndex := ThemeValue(2, 3);
  Width := 27;
  Height := 27;
end;

procedure TformButtonTrayslate.FormShow(Sender: TObject);
begin
  TimerHide.Enabled := True;
end;

procedure TformButtonTrayslate.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;
  Canvas.MoveTo(Width - 2, 0);
  Canvas.LineTo(Width - 2, Height - 1);
  Canvas.MoveTo(0, Height - 2);
  Canvas.LineTo(Width - 1, Height - 2);

  Canvas.Pen.Color := clSilver;
  Canvas.MoveTo(Width - 1, 0);
  Canvas.LineTo(Width - 1, Height - 1);
  Canvas.MoveTo(0, Height - 1);
  Canvas.LineTo(Width - 1, Height - 1);
end;

procedure TformButtonTrayslate.SbTranslateClick(Sender: TObject);
begin
  TimerHideTimer(Self);
  formTrayslate.TranslatePopup(SourceText);
end;

procedure TformButtonTrayslate.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {$IFDEF WINDOWS}
  Params.ExStyle := Params.ExStyle or WS_EX_NOACTIVATE;
  {$ENDIF}
end;

procedure TformButtonTrayslate.SbTranslateMouseEnter(Sender: TObject);
begin
  TimerHide.Enabled := False;
end;

procedure TformButtonTrayslate.SbTranslateMouseLeave(Sender: TObject);
begin
  TimerHide.Enabled := True;
end;

procedure TformButtonTrayslate.TimerHideTimer(Sender: TObject);
begin
  TimerHide.Enabled := False;
  Hide;
end;

end.
