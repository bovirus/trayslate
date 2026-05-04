//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formsettings;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  Types,
  SysUtils,
  StrUtils,
  Controls,
  Graphics,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ColorBox,
  Spin,
  Math,
  Grids,
  LCLType,
  LCLIntf,
  langtool;

type

  { TformSettingsTrayslate }

  TformSettingsTrayslate = class(TForm)
    BtnFont: TButton;
    BtnReset: TButton;
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    CheckRecentPairHotkeys: TCheckBox;
    CheckRealTime: TCheckBox;
    CheckAutoSwap: TCheckBox;
    CheckTwoLang: TCheckBox;
    CheckAutostart: TCheckBox;
    CheckAutoAddLangPairs: TCheckBox;
    ColorIconBackground: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    ComboIconFontName: TComboBox;
    ComboLangDetect: TComboBox;
    FontDialog: TFontDialog;
    GroupAutoSwap: TGroupBox;
    GroupAutostart: TGroupBox;
    GroupLangPairs: TGroupBox;
    GroupTransFromClipboard1: TGroupBox;
    GroupRealTime: TGroupBox;
    GroupFont: TGroupBox;
    GroupTrayIcon: TGroupBox;
    ImagesPages: TImageList;
    LabelIconBackground1: TLabel;
    LabelIconFont1: TLabel;
    LabelMaxLangPairs: TLabel;
    LabelRealTimeDelay: TLabel;
    LabelIconBackground: TLabel;
    LabelIconFont: TLabel;
    ListPages: TListBox;
    PagesSettings: TPageControl;
    PanelPages: TPanel;
    PanelBottom: TPanel;
    PanelFont: TPanel;
    PageInterface: TTabSheet;
    PageHotkeys: TTabSheet;
    ScrollHotkeys: TScrollBox;
    ScrollInterface: TScrollBox;
    ScrollGeneral: TScrollBox;
    SpinMaxLangPairs: TSpinEdit;
    PageGeneral: TTabSheet;
    SpinRealTimeDelay: TSpinEdit;
    SplitterPages: TSplitter;
    GridHotkeys: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure GridHotkeysDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure GridHotkeysGetCellHint(Sender: TObject; ACol, ARow: integer; var HintText: string);
    procedure GridHotkeysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure GridHotkeysSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
    procedure ListPagesClick(Sender: TObject);
    procedure ListPagesDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure SettingChange(Sender: TObject);
    procedure SplitterPagesMoved(Sender: TObject);
  private
    FOriginalAutoStart: boolean;
    FOriginalFont: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconFontName: string;
    FOriginalIconTwoLang: boolean;
    FOriginalMaxLangPairs: integer;
    FOriginalAutoAddLangPairs: boolean;
    FOriginalRecentPairHotkeys: boolean;
    FOriginalRealTime: boolean;
    FOriginalRealTimeDelay: integer;
    FOriginalAutoSwap: boolean;
    FOriginalConfigLangDetect: string;
    FOriginalHotKeyApp: THotKeyData;
    FOriginalHotKeyTransSwap: THotKeyData;
    FOriginalHotKeyTransFromClipboard: THotKeyData;
    FOriginalHotKeyTransClipboard: THotKeyData;
    FOriginalHotKeyTransClipboardPopup: THotKeyData;
    FOriginalHotKeyTransFromControl: THotKeyData;
    FOriginalHotKeyTransControl: THotKeyData;
    FOriginalHotKeyTransControlPopup: THotKeyData;

    FHotKeyApp: THotKeyData;
    FHotKeyTransSwap: THotKeyData;
    FHotKeyTransFromClipboard: THotKeyData;
    FHotKeyTransClipboard: THotKeyData;
    FHotKeyTransClipboardPopup: THotKeyData;
    FHotKeyTransFromControl: THotKeyData;
    FHotKeyTransControl: THotKeyData;
    FHotKeyTransControlPopup: THotKeyData;

    procedure SetPanelFont(const AFont: TFont);
  public
    procedure Apply;
    procedure Reset;
    procedure SetHotKeyByRow(Row: integer; const HK: THotKeyData);
    function GetOriginalHotKey(Row: integer): THotKeyData;
    procedure FillListPages;
    procedure FillGridHotkeys;
  end;

var
  formSettingsTrayslate: TformSettingsTrayslate;

const
  HeaderRows: set of byte = [1, 10];
  ColorBevel = $00D9D9D9;
  ColorBevelDark = $00555555;

resourcestring
  rdefaultfont = 'Default';
  rglobal = 'Global Hotkeys';
  rrecent = 'Recent Language Pairs';

  rapp = 'Toggle Application (Tray Icon Click)';
  rapp_hint = 'Shows or hides the main application window';
  rapp_default = 'Default Ctrl+Shift+A';

  rtransswap = 'Swap Languages (Tray Icon Middle-Click)';
  rtransswap_hint = 'Swaps the source and target languages';
  rtransswap_default = 'Default Ctrl+Shift+S';

  rtransfromclipboard = 'Translate From Clipboard (Tray Icon Double-Click)';
  rtransfromclipboard_hint = 'Translates the current text from the clipboard';
  rtransfromclipboard_default = 'Default Ctrl+Shift+T';

  rtransclipboard = 'Translate Clipboard to Clipboard';
  rtransclipboard_hint = 'Translates the current text in clipboard and copies the result to the clipboard';
  rtransclipboard_default = 'Default Ctrl+Shift+R';

  rtransclipboardpopup = 'Translate Clipboard to Popup Window';
  rtransclipboardpopup_hint = 'Translates clipboard text to a popup window near the mouse cursor';
  rtransclipboardpopup_default = 'Default: Ctrl+Shift+P';

  rtransfromcontrol = 'Translate From Active Application Selection';
  rtransfromcontrol_hint = 'Translates the selected text from the active application';
  rtransfromcontrol_default = 'Default Ctrl+Shift+C';

  rtranscontrol = 'Translate In Active Application Selection';
  rtranscontrol_hint = 'Replaces the selected text in the active application with the translation';
  rtranscontrol_default = 'Default Ctrl+Shift+V';

  rtranscontrolpopup = 'Translate Selected Text to Popup Window';
  rtranscontrolpopup_hint = 'Translates selected text from the active application to a popup window near the mouse cursor';
  rtranscontrolpopup_default = 'Default: Ctrl+Shift+X';

implementation

uses mainform, formattool, systemtool;

  {$R *.lfm}

  { TformSettingsTrayslate }

procedure TformSettingsTrayslate.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ApplicationTranslate(language, self);

  PanelPages.BevelColor := ThemeColor(ColorBevel, ColorBevelDark);
  PagesSettings.PageIndex := 0;
  BtnCancel.Cancel := True;
  BtnReset.Enabled := True;

  ComboLangDetect.Items.Clear;
  ComboLangDetect.Items.Add(string.Empty);
  for i := 0 to formTrayslate.ConfigFiles.Count - 1 do
    ComboLangDetect.Items.Add(formTrayslate.ConfigTitles.Values[formTrayslate.ConfigFiles[i]]);
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(formTrayslate.ConfigLangDetect) + 1;

  AddCustomColors(ColorIconBackground);
  AddCustomColors(ColorIconFont);
  FillFontCombo(ComboIconFontName);
  Reset;
  FillListPages;
  FillGridHotkeys;
end;

procedure TformSettingsTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormSettingsWidth := Width;
  formTrayslate.FormSettingsHeight := Height;
end;

procedure TformSettingsTrayslate.FormShow(Sender: TObject);
begin
  formTrayslate.TopMost := False;
end;

procedure TformSettingsTrayslate.BtnFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(PanelFont.Font);
  if FontDialog.Execute then
  begin
    PanelFont.Font.Assign(FontDialog.Font);
    SetPanelFont(FontDialog.Font);

    BtnApply.Enabled := True;
  end;
end;

procedure TformSettingsTrayslate.BtnResetClick(Sender: TObject);
begin
  PanelFont.Font.SetDefault;
  SetPanelFont(PanelFont.Font);
  SettingChange(Self);
end;

procedure TformSettingsTrayslate.GridHotkeysDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  if aRow in HeaderRows then
    GridHotkeys.Canvas.Font.Style := [fsBold]
  else
    GridHotkeys.Canvas.Font.Style := [];

  if aRow = 0 then
    GridHotkeys.Canvas.Brush.Color := clWindow;

  GridHotkeys.DefaultDrawCell(aCol, aRow, aRect, aState);
end;

procedure TformSettingsTrayslate.ListPagesClick(Sender: TObject);
begin
  // Synchronize PageControl with the selected list item
  if (ListPages.ItemIndex >= 0) and (ListPages.ItemIndex < PagesSettings.PageCount) then
  begin
    PagesSettings.ActivePageIndex := ListPages.ItemIndex;
  end;
end;

procedure TformSettingsTrayslate.ListPagesDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  ImgY: integer;
  TextOffset: integer;
  TextRect: TRect;
  TextStyle: TTextStyle;
begin
  ListBox := Control as TListBox;

  // Draw item background
  ListBox.Canvas.FillRect(ARect);

  TextOffset := 4;

  // Calculate vertical centering for the image
  ImgY := ARect.Top + (ARect.Height - ImagesPages.Height) div 2;

  // Draw image if index is valid
  if (Index >= 0) and (Index < ImagesPages.Count) then
  begin
    ImagesPages.Draw(ListBox.Canvas, ARect.Left + TextOffset, ImgY, Index);
  end;

  // Prepare text rectangle
  TextRect := ARect;
  TextRect.Left := ARect.Left + ImagesPages.Width + (TextOffset * 2);
  TextRect.Right := ARect.Right - TextOffset;

  // Configure text style for LCL (Lazarus)
  TextStyle := ListBox.Canvas.TextStyle;
  TextStyle.Wordbreak := True;
  TextStyle.SingleLine := False;
  TextStyle.Layout := tlCenter; // In LCL use 'Layout' and 'tlCenter' for vertical centering

  // Draw wrapped text
  ListBox.Canvas.Brush.Style := bsClear;
  ListBox.Canvas.TextRect(TextRect, TextRect.Left, TextRect.Top, ListBox.Items[Index], TextStyle);
end;

procedure TformSettingsTrayslate.GridHotkeysGetCellHint(Sender: TObject; ACol, ARow: integer; var HintText: string);
begin
  if ACol = 0 then
    HintText := GridHotkeys.Cells[2, ARow]  // hidden hint column
  else
  if ACol = 1 then
    HintText := GridHotkeys.Cells[3, ARow]  // hidden default column
  else
    HintText := string.Empty;
end;

procedure TformSettingsTrayslate.GridHotkeysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  HK: THotKeyData;
  HasRealKey: boolean;
begin
  // Enter outside editor → start editing column 1
  if (Key = VK_RETURN) and (not GridHotkeys.EditorMode) then
  begin
    GridHotkeys.Col := 1;
    GridHotkeys.EditorMode := True;
    Key := 0;
    Exit;
  end;

  // Enter inside editor → confirm input
  if (Key = VK_RETURN) and GridHotkeys.EditorMode then
  begin
    GridHotkeys.EditorMode := False;
    Key := 0;
    Exit;
  end;

  // Safety guards
  if (GridHotkeys.Col <> 1) or (not GridHotkeys.EditorMode) then Exit;

  HK := Default(THotKeyData);

  // Escape → restore original + exit editor
  if (Key = VK_ESCAPE) then
  begin
    HK := GetOriginalHotKey(GridHotkeys.Row);
    SetHotKeyByRow(GridHotkeys.Row, HK);

    GridHotkeys.Cells[1, GridHotkeys.Row] := HotKeyToText(HK);

    GridHotkeys.EditorMode := False;

    Key := 0;
    Exit;
  end;

  // Delete → clear hotkey
  if (Key = VK_DELETE) and (Shift = []) then
  begin
    HK.Modifiers := 0;
    HK.Key := 0;

    SetHotKeyByRow(GridHotkeys.Row, HK);
    GridHotkeys.Cells[1, GridHotkeys.Row] := string.Empty;

    BtnApply.Enabled := True;

    Key := 0;
    Exit;
  end;

  // Build modifiers
  HK.Modifiers := 0;
  HK.Key := 0;

  if ssCtrl in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_CTRL;

  if ssShift in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_SHIFT;

  if ssAlt in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_ALT;

  if ssMeta in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_META;

  // Detect real key
  HasRealKey := not (Key in [VK_CONTROL, VK_SHIFT, VK_MENU, VK_LWIN, VK_RWIN]);

  if HasRealKey then
  begin
    HK.Key := Key;
    Key := 0;
  end
  else
    HK.Key := 0;

  // Apply hotkey
  SetHotKeyByRow(GridHotkeys.Row, HK);

  GridHotkeys.Cells[1, GridHotkeys.Row] := HotKeyToText(HK);

  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslate.GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  if (ACol = 1) and (ARow in HeaderRows) then
    Editor := nil;
end;

procedure TformSettingsTrayslate.GridHotkeysSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
var
  OldValue: string;
begin
  if ACol <> 1 then Exit;

  OldValue := GridHotkeys.Cells[ACol, ARow];

  // only react if value really changed
  if Value = OldValue then Exit;

  SettingChange(Sender);
end;

procedure TformSettingsTrayslate.SettingChange(Sender: TObject);
begin
  BtnApply.Enabled := True;

  if (Sender is TSpinEdit) then
  begin
    if (Sender as TSpinEdit).Value < 0 then
      (Sender as TSpinEdit).Value := 0;
  end
  else
  if (Sender = ColorIconBackground) or (Sender = ColorIconFont) or (Sender = ComboIconFontName) or (Sender = CheckTwoLang) then
  begin
    // Apply real time properies
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.SetIcon;
  end;
end;

procedure TformSettingsTrayslate.SplitterPagesMoved(Sender: TObject);
begin
  formTrayslate.FormSettingsSplit := ListPages.Width;
end;

procedure TformSettingsTrayslate.BtnOkClick(Sender: TObject);
begin
  Apply;
  ModalResult := mrOk;
end;

procedure TformSettingsTrayslate.BtnCancelClick(Sender: TObject);
begin
  // Reset real time properies
  formTrayslate.IconBackgroundColor := FOriginalIconBackgroundColor;
  formTrayslate.IconFontColor := FOriginalIconFontColor;
  formTrayslate.IconFontName := FOriginalIconFontName;
  formTrayslate.IconTwoLang := FOriginalIconTwoLang;
  formTrayslate.SetIcon;

  Reset;
  ModalResult := mrCancel;
end;

procedure TformSettingsTrayslate.BtnApplyClick(Sender: TObject);
begin
  Apply;
end;

procedure TformSettingsTrayslate.SetPanelFont(const AFont: TFont);
begin
  PanelFont.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), rdefaultfont, AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslate.SetHotKeyByRow(Row: integer; const HK: THotKeyData);
begin
  case Row of
    2: FHotKeyApp := HK;
    3: FHotKeyTransSwap := HK;
    4: FHotKeyTransFromClipboard := HK;
    5: FHotKeyTransClipboard := HK;
    6: FHotKeyTransClipboardPopup := HK;
    7: FHotKeyTransFromControl := HK;
    8: FHotKeyTransControl := HK;
    9: FHotKeyTransControlPopup := HK;
  end;
end;

function TformSettingsTrayslate.GetOriginalHotKey(Row: integer): THotKeyData;
begin
  case Row of
    2: Result := FOriginalHotKeyApp;
    3: Result := FOriginalHotKeyTransSwap;
    4: Result := FOriginalHotKeyTransFromClipboard;
    5: Result := FOriginalHotKeyTransClipboard;
    6: Result := FOriginalHotKeyTransClipboardPopup;
    7: Result := FOriginalHotKeyTransFromControl;
    8: Result := FOriginalHotKeyTransControl;
    9: Result := FOriginalHotKeyTransControlPopup;
    else
      Result := Default(THotKeyData);
  end;
end;

procedure TformSettingsTrayslate.FillListPages;
var
  i: integer;
begin
  ListPages.Clear;
  for i := 0 to PagesSettings.PageCount - 1 do
    ListPages.Items.Add(PagesSettings.Pages[i].Caption);
  ListPages.ItemIndex := PagesSettings.PageIndex;
  PagesSettings.ShowTabs := False;
end;

procedure TformSettingsTrayslate.FillGridHotkeys;
begin
  while GridHotkeys.RowCount > GridHotkeys.FixedRows do
    GridHotkeys.DeleteRow(GridHotkeys.RowCount - 1);

  GridHotkeys.InsertRowWithValues(1, [rglobal]);
  GridHotkeys.InsertRowWithValues(2, [rapp, HotKeyToText(FHotKeyApp), rapp_hint, rapp_default]);
  GridHotkeys.InsertRowWithValues(3, [rtransswap, HotKeyToText(FHotKeyTransSwap), rtransswap_hint, rtransswap_default]);
  GridHotkeys.InsertRowWithValues(4, [rtransfromclipboard, HotKeyToText(FHotKeyTransFromClipboard),
    rtransfromclipboard_hint, rtransfromclipboard_default]);
  GridHotkeys.InsertRowWithValues(5, [rtransclipboard, HotKeyToText(FHotKeyTransClipboard), rtransclipboard_hint,
    rtransclipboard_default]);
  GridHotkeys.InsertRowWithValues(6, [rtransclipboardpopup, HotKeyToText(FHotKeyTransClipboardPopup),
    rtransclipboardpopup_hint, rtransclipboardpopup_default]);
  GridHotkeys.InsertRowWithValues(7, [rtransfromcontrol, HotKeyToText(FHotKeyTransFromControl),
    rtransfromcontrol_hint, rtransfromcontrol_default]);
  GridHotkeys.InsertRowWithValues(8, [rtranscontrol, HotKeyToText(FHotKeyTransControl), rtranscontrol_hint, rtranscontrol_default]);
  GridHotkeys.InsertRowWithValues(9, [rtranscontrolpopup, HotKeyToText(FHotKeyTransControlPopup),
    rtranscontrolpopup_hint, rtranscontrolpopup_default]);
  //  GridHotkeys.InsertRowWithValues(8, [rrecent]);
end;

procedure TformSettingsTrayslate.Apply;
begin
  formTrayslate.AutoStart := CheckAutostart.Checked;
  formTrayslate.MaxLangPairs := SpinMaxLangPairs.Value;
  formTrayslate.AutoAddLangPairs := CheckAutoAddLangPairs.Checked;
  formTrayslate.RecentPairHotKeys := CheckRecentPairHotkeys.Checked;
  formTrayslate.RealTime := CheckRealTime.Checked;
  formTrayslate.RealTimeDelay := SpinRealTimeDelay.Value;
  formTrayslate.AutoSwap := CheckAutoSwap.Checked;
  if ComboLangDetect.ItemIndex > 0 then
    formTrayslate.ConfigLangDetect := formTrayslate.ConfigFiles[ComboLangDetect.ItemIndex - 1]
  else
    formTrayslate.ConfigLangDetect := string.Empty;
  formTrayslate.Font.Assign(PanelFont.Font);
  formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
  formTrayslate.IconFontColor := ColorIconFont.Selected;
  formTrayslate.IconFontName := ComboIconFontName.Text;
  formTrayslate.IconTwoLang := CheckTwoLang.Checked;
  formTrayslate.SetIcon;

  formTrayslate.HotKeyApp := FHotKeyApp;
  formTrayslate.HotKeyTransSwap := FHotKeyTransSwap;
  formTrayslate.HotKeyTransFromClipboard := FHotKeyTransFromClipboard;
  formTrayslate.HotKeyTransClipboard := FHotKeyTransClipboard;
  formTrayslate.HotKeyTransClipboardPopup := FHotKeyTransClipboardPopup;
  formTrayslate.HotKeyTransFromControl := FHotKeyTransFromControl;
  formTrayslate.HotKeyTransControl := FHotKeyTransControl;
  formTrayslate.HotKeyTransControlPopup := FHotKeyTransControlPopup;

  formTrayslate.ComboSource.SelLength := 0;
  formTrayslate.ComboTarget.SelLength := 0;

  Reset;
  formTrayslate.TimerTranslate.Interval := Max(formTrayslate.RealTimeDelay, 1);
  formTrayslate.LoadConfig;
  formTrayslate.DoRealign(0);
  Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
end;

procedure TformSettingsTrayslate.Reset;
begin
  FOriginalAutoStart := formTrayslate.AutoStart;
  FOriginalMaxLangPairs := formTrayslate.MaxLangPairs;
  FOriginalAutoAddLangPairs := formTrayslate.AutoAddLangPairs;
  FOriginalRecentPairHotkeys := formTrayslate.RecentPairHotKeys;
  FOriginalRealTime := formTrayslate.RealTime;
  FOriginalRealTimeDelay := formTrayslate.RealTimeDelay;
  FOriginalAutoSwap := formTrayslate.AutoSwap;
  FOriginalConfigLangDetect := formTrayslate.ConfigLangDetect;
  FOriginalFont := formTrayslate.Font;
  FOriginalIconBackgroundColor := formTrayslate.IconBackgroundColor;
  FOriginalIconFontColor := formTrayslate.IconFontColor;
  FOriginalIconFontName := formTrayslate.IconFontName;
  FOriginalIconTwoLang := formTrayslate.IconTwoLang;
  FOriginalHotKeyApp := formTrayslate.HotKeyApp;
  FOriginalHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FOriginalHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FOriginalHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FOriginalHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FOriginalHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FOriginalHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FOriginalHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;
  FHotKeyApp := formTrayslate.HotKeyApp;
  FHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;

  CheckAutostart.Checked := FOriginalAutoStart;
  SpinMaxLangPairs.Value := FOriginalMaxLangPairs;
  CheckAutoAddLangPairs.Checked := FOriginalAutoAddLangPairs;
  CheckRecentPairHotkeys.Checked := FOriginalRecentPairHotkeys;
  CheckRealTime.Checked := FOriginalRealTime;
  SpinRealTimeDelay.Value := FOriginalRealTimeDelay;
  CheckAutoSwap.Checked := FOriginalAutoSwap;
  if FOriginalConfigLangDetect <> string.Empty then
    ComboLangDetect.ItemIndex := Max(formTrayslate.ConfigFiles.IndexOf(FOriginalConfigLangDetect) + 1, 0)
  else
    ComboLangDetect.ItemIndex := 0;
  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(FOriginalFont);
  ColorIconBackground.Selected := FOriginalIconBackgroundColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  ComboIconFontName.Text := FOriginalIconFontName;
  CheckTwoLang.Checked := FOriginalIconTwoLang;

  BtnApply.Enabled := False;
end;

end.
