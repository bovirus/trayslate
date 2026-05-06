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
  ActnList,
  LCLType,
  LMessages, ExtCtrls;

type

  { TformPopupTrayslate }

  TformPopupTrayslate = class(TForm)
    FlowPairs: TFlowPanel;
    MemoTarget: TMemo;
    procedure FormChangeBounds(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: boolean);
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

end.
