//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------
//  uLangDetect.pas  –  Fast language detection using character trigrams
//  Always initialises a set of default profiles, then merges in any profiles
//  found in an external binary file (langprofiles.dat).  Profiles from the
//  file overwrite defaults for matching language codes; new codes are added.
//  Public functions:
//    function DetectLanguageForText(const AText: string): string;
//    function DetectLanguageWithConfidence(const AText: string; out Confidence: Double): string;
//  Cross-platform: Windows, Linux, macOS.  Lazarus / FPC 3.2.2+
//-----------------------------------------------------------------------------------

unit langdetect;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  SysUtils,
  Classes,
  LazUTF8;      // UTF-8 aware string functions (especially UTF8LowerCase, UTF8CodepointSize)

// Returns language code (e.g. 'en', 'ru') or 'unknown'
function DetectLanguageForText(const AText: string): string;

// Also returns a confidence value between 0.0 and 1.0
function DetectLanguageWithConfidence(const AText: string; out Confidence: double): string;

implementation

type
  TStringArray = array of string;

  TProfile = record
    Code: string;
    Trigrams: TStringArray;   // sorted by frequency, most frequent first
  end;

var
  Profiles: array of TProfile;

//  Check if a UTF-8 character is in the CJK (Chinese/Japanese/Korean) range
function IsCJK(const s: string): boolean;
var
  cp: UCS4Char;
  CharLen: integer;
begin
  if s = '' then Exit(False);
  CharLen := 0;
  cp := UTF8CodepointToUnicode(@s[1], CharLen);
  Result :=
    ((cp >= $4E00) and (cp <= $9FFF)) or ((cp >= $3400) and (cp <= $4DBF)) or ((cp >= $20000) and (cp <= $2A6DF)) or
    ((cp >= $F900) and (cp <= $FAFF)) or ((cp >= $2F800) and (cp <= $2FA1F)) or ((cp >= $3000) and (cp <= $303F)) or
    ((cp >= $FF00) and (cp <= $FFEF)) or ((cp >= $3040) and (cp <= $309F)) or ((cp >= $30A0) and (cp <= $30FF)) or
    ((cp >= $AC00) and (cp <= $D7AF));
end;

//  Extract character trigrams from a UTF-8 text
//  For texts dominated by CJK characters, spaces are ignored.
function ExtractCharTrigrams(const AText: string): TStringArray;
var
  s: string;
  chars: array of string = ();
  i, p, charLen: integer;
  ch: string;
  cjkCount, totalCount, actualCharCount: integer;
  skipSpaces: boolean;
begin
  Result := nil;
  s := UTF8LowerCase(AText);

  // Pre-allocate maximum possible size to prevent continuous memory reallocation
  SetLength(chars, Length(s));
  actualCharCount := 0;
  p := 1;

  // ----- First pass: decide whether to ignore spaces (CJK heuristic) -----
  cjkCount := 0;
  totalCount := 0;
  while (p <= Length(s)) and (totalCount < 30) do
  begin
    {$NOTES OFF}
    charLen := UTF8CodepointSize(@s[p]);
    {$NOTES ON}
    if charLen = 0 then Inc(p)
    else
    begin
      ch := Copy(s, p, charLen);
      Inc(p, charLen);
      if ch = ' ' then Continue;
      if ((ch[1] >= 'A') and (ch[1] <= 'Z')) or ((ch[1] >= 'a') and (ch[1] <= 'z')) or (Ord(ch[1]) >= $C0) then
      begin
        Inc(totalCount);
        if IsCJK(ch) then Inc(cjkCount);
      end;
    end;
  end;
  skipSpaces := (totalCount > 0) and (cjkCount / totalCount > 0.5);

  // ----- Second pass: build character list -----
  p := 1;
  while p <= Length(s) do
  begin
    {$NOTES OFF}
    charLen := UTF8CodepointSize(@s[p]);
    {$NOTES ON}
    if charLen = 0 then
    begin
      Inc(p);
      Continue;
    end;
    ch := Copy(s, p, charLen);
    Inc(p, charLen);

    if ch = ' ' then
    begin
      if not skipSpaces then
      begin
        if (actualCharCount = 0) or (chars[actualCharCount - 1] <> ' ') then
        begin
          chars[actualCharCount] := ' ';
          Inc(actualCharCount);
        end;
      end;
    end
    else
    if ((ch[1] >= 'A') and (ch[1] <= 'Z')) or ((ch[1] >= 'a') and (ch[1] <= 'z')) or (Ord(ch[1]) >= $C0) then
    begin
      chars[actualCharCount] := ch;
      Inc(actualCharCount);
    end
    else
    begin
      if not skipSpaces then
      begin
        if (actualCharCount = 0) or (chars[actualCharCount - 1] <> ' ') then
        begin
          chars[actualCharCount] := ' ';
          Inc(actualCharCount);
        end;
      end;
    end;
  end;

  // Trim array to actual used size
  SetLength(chars, actualCharCount);

  if Length(chars) < 3 then Exit;
  SetLength(Result, Length(chars) - 2);
  for i := 0 to High(Result) do
    Result[i] := chars[i] + chars[i + 1] + chars[i + 2];
end;

//  Distance between text trigrams and a profile
//  (simple linear search – fast enough for typical trigram sets)
function DistanceToProfile(const TextTrigrams: TStringArray; const Profile: TProfile): integer;
var
  i, j, penalty: integer;
  found: boolean;
const
  MISSING_PENALTY = 1000;
begin
  Result := 0;
  penalty := 0;
  for i := 0 to High(TextTrigrams) do
  begin
    found := False;
    for j := 0 to High(Profile.Trigrams) do
      if Profile.Trigrams[j] = TextTrigrams[i] then
      begin
        penalty := j;
        found := True;
        Break;
      end;
    if not found then
      penalty := MISSING_PENALTY;
    Inc(Result, penalty);
  end;
end;

//  Default profiles (defined in separate include file)
{$include langprofiles_data.inc}

//  Load profiles from binary file and merge into the global Profiles
procedure MergeProfilesFromFile(const FileName: string);
var
  fs: TFileStream;
  Count, i, j, trigCount, existingIdx: Integer;
  codeLen: Byte;
  code: string = '';
  trigLen: Byte;
  trig: string = '';
  freq: Integer;                 // frequency is read but not stored (reserved for future use)
  fileProfiles: array of TProfile = ();
begin
  if not FileExists(FileName) then Exit;
  fs := TFileStream.Create(FileName, fmOpenRead);
  try
    Count := 0;
    fs.ReadBuffer(Count, SizeOf(Count));
    SetLength(fileProfiles, Count);
    for i := 0 to Count - 1 do
    begin
      codeLen := 0;
      fs.ReadBuffer(codeLen, SizeOf(codeLen));
      SetLength(code, codeLen);
      if codeLen > 0 then
        fs.ReadBuffer(code[1], codeLen);
      fileProfiles[i].Code := code;

      trigCount := 0;
      fs.ReadBuffer(trigCount, SizeOf(trigCount));
      SetLength(fileProfiles[i].Trigrams, trigCount);
      for j := 0 to trigCount - 1 do
      begin
        trigLen := 0;
        fs.ReadBuffer(trigLen, SizeOf(trigLen));
        SetLength(trig, trigLen);
        if trigLen > 0 then
          fs.ReadBuffer(trig[1], trigLen);
        fileProfiles[i].Trigrams[j] := trig;

        // Read the frequency (4 bytes) – we don't use it yet,
        // but it must be consumed to keep the file pointer correct.
        freq := 0;
        fs.ReadBuffer(freq, SizeOf(freq));
      end;
    end;
  finally
    fs.Free;
  end;

  // Merge (same as before)
  for i := 0 to High(fileProfiles) do
  begin
    existingIdx := -1;
    for j := 0 to High(Profiles) do
      if Profiles[j].Code = fileProfiles[i].Code then
      begin
        existingIdx := j;
        Break;
      end;
    if existingIdx >= 0 then
      Profiles[existingIdx].Trigrams := fileProfiles[i].Trigrams
    else
    begin
      SetLength(Profiles, Length(Profiles) + 1);
      Profiles[High(Profiles)] := fileProfiles[i];
    end;
  end;
end;

//  Public functions
function DetectLanguageForText(const AText: string): string;
var
  dummy: double;
begin
  Result := DetectLanguageWithConfidence(AText, dummy);
end;

function DetectLanguageWithConfidence(const AText: string; out Confidence: double): string;
var
  textTrigrams: TStringArray;
  i, bestIdx, secondIdx: integer;
  bestDist, secondDist, currentDist: integer;
  allSameDist: boolean;
  distCache: array of integer = (); // Cache to store calculated distances

// ------------------------------------------------------------------
//  Fallback detection based on Unicode character ranges
// ------------------------------------------------------------------
  function DetectByUnicodeRange(const Txt: string): string;
  var
    p, charLen, total, cjk, hiragana, katakana, hangul: integer;
    cp: UCS4Char;
    ch: string;
  begin
    total := 0;
    cjk := 0;
    hiragana := 0;
    katakana := 0;
    hangul := 0;
    p := 1;
    while (p <= Length(Txt)) and (total < 50) do
    begin
      {$NOTES OFF}
      charLen := UTF8CodepointSize(@Txt[p]);
      {$NOTES ON}
      if charLen = 0 then
      begin
        Inc(p);
        Continue;
      end;
      ch := Copy(Txt, p, charLen);
      Inc(p, charLen);
      if ch = ' ' then Continue;
      // Accept any letter or CJK symbol as a "character" for counting
      if ((ch[1] >= 'A') and (ch[1] <= 'Z')) or ((ch[1] >= 'a') and (ch[1] <= 'z')) or (Ord(ch[1]) >= $C0) then
      begin
        Inc(total);
        cp := UTF8CodepointToUnicode(@ch[1], charLen);
        // CJK Unified Ideographs and extensions
        if ((cp >= $4E00) and (cp <= $9FFF)) or ((cp >= $3400) and (cp <= $4DBF)) or ((cp >= $20000) and (cp <= $2A6DF)) then
          Inc(cjk)
        // Hiragana
        else if (cp >= $3040) and (cp <= $309F) then
          Inc(hiragana)
        // Katakana
        else if (cp >= $30A0) and (cp <= $30FF) then
          Inc(katakana)
        // Hangul Syllables
        else if (cp >= $AC00) and (cp <= $D7AF) then
          Inc(hangul);
      end;
    end;

    if total = 0 then Exit('unknown');
    if hangul / total > 0.5 then Exit('ko');
    if (hiragana + katakana) / total > 0.3 then Exit('ja');
    if cjk / total > 0.5 then Exit('zh-CN');
    Result := 'unknown';
  end;

begin
  Confidence := 0.0;
  if Length(AText) < 3 then Exit('unknown');

  textTrigrams := ExtractCharTrigrams(AText);
  if Length(textTrigrams) = 0 then Exit('unknown');

  bestDist := MaxInt;
  bestIdx := -1;
  secondDist := MaxInt;
  secondIdx := -1;

  SetLength(distCache, Length(Profiles));

  for i := 0 to High(Profiles) do
  begin
    currentDist := DistanceToProfile(textTrigrams, Profiles[i]);
    distCache[i] := currentDist;

    if currentDist < bestDist then
    begin
      secondDist := bestDist;
      secondIdx := bestIdx;
      bestDist := currentDist;
      bestIdx := i;
    end
    else if currentDist < secondDist then
    begin
      secondDist := currentDist;
      secondIdx := i;
    end;
  end;

  // If all profiles are equally "bad" (no trigram matched any language profile)
  allSameDist := True;
  if bestIdx >= 0 then
    for i := 0 to High(Profiles) do
      if (i <> bestIdx) and (distCache[i] <> bestDist) then
      begin
        allSameDist := False;
        Break;
      end;

  if allSameDist and (bestIdx >= 0) then
  begin
    Result := DetectByUnicodeRange(AText);
    if Result <> 'unknown' then
    begin
      Confidence := 0.8;
      Exit;
    end;
  end;

  if bestIdx >= 0 then
  begin
    Result := Profiles[bestIdx].Code;
    if (secondIdx >= 0) and (bestDist + secondDist > 0) then
      Confidence := 1.0 - (bestDist / (bestDist + secondDist))
    else
      Confidence := 1.0;
  end
  else
    Result := 'unknown';
end;

//  Unit initialization
var
  ExePath: string;

initialization
  InitDefaultProfiles;

  ExePath := ExtractFilePath(ParamStr(0));
  if FileExists(ExePath + 'langprofiles.dat') then
    MergeProfilesFromFile(ExePath + 'langprofiles.dat')
  else
    MergeProfilesFromFile(IncludeTrailingPathDelimiter(ExePath + 'corpus') + 'langprofiles.dat');
end.
