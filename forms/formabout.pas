//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formabout;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  StdCtrls,
  ExtCtrls,
  Graphics,
  LCLIntf;

type

  { TformAboutTrayslate }

  TformAboutTrayslate = class(TForm)
    buttonOk: TButton;
    imageLogo: TImage;
    LblAbout: TLabel;
    labelBy: TLabel;
    labelName: TLabel;
    labelLic: TLabel;
    LabelLicUrl: TLabel;
    MemoAbout: TMemo;
    labelBy1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LabelLicUrlClick(Sender: TObject);
  private

  public

  end;

var
  formAboutTrayslate: TformAboutTrayslate;

implementation

uses mainform, systemtool;

  {$R *.lfm}

  { TformAboutTrayslate }

procedure TformAboutTrayslate.FormCreate(Sender: TObject);
begin
  ApplicationTranslate(language, self, formTrayslate.LoadCustomPoFile(formTrayslate.CustomPoFile));

  MemoAbout.Text := LblAbout.Caption;
  labelName.Caption := 'Trayslate © ' + GetAppVersion;
  LabelLicUrl.Font.Color := ThemeColor(clBlue, clSkyBlue);
end;

procedure TformAboutTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormAboutWidth := Width;
  formTrayslate.FormAboutHeight := Height;
end;

procedure TformAboutTrayslate.LabelLicUrlClick(Sender: TObject);
begin
  OpenUrl(labelLicUrl.Caption);
end;

end.
