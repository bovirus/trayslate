//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit scriptrunner;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Variants,
  RegExpr,
  uPSComponent,
  uPSCompiler,
  uPSUtils, // uPSUtils provides btString, btS32
  osutils,
  stringhelper;

type
  { TScriptRunner
    Wraps a PascalScript engine (TPSScript) to execute user-defined scripts.
    Input parameters are passed as a TStringList (name=value pairs) and are
    accessible inside the script via the GetParam() function.
    Output values are stored by the script using SetOutput() and are collected
    in a public TStringList that the host can iterate after execution. }
  TScriptRunner = class
  private
    FPSScript: TPSScript;           // The script component (compiler + executor)
    FScriptCode: TStrings;          // Source code of the script
    FParams: TStringList;           // Input parameters (name=value)
    FOutputList: TStringList;       // Output results (name=value)
    FIsCompiled: boolean;           // True after a successful compilation
    // Event handlers for the script component
    procedure OnCompile(Sender: TPSScript);
    procedure OnExecute(Sender: TPSScript);
    // Functions callable from within the script (but registered via plain wrappers)
    function GetParam(const Name: string): string;
    procedure SetOutput(const Name, Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    // Load the script source (e.g. from a TMemo)
    procedure LoadScript(const ACode: TStrings);
    // Compile the script; raises an exception with detailed compiler messages on error
    procedure Compile;
    // Execute the compiled script; compilation is done automatically if needed.
    procedure Execute;
    // Input parameters – fill this list before calling Execute.
    // Each line should be in the form 'Name=Value'.
    property Params: TStringList read FParams;
    // Output parameters – after execution this list contains all values set
    // by the script via SetOutput(), each line in the form 'Name=Value'.
    property OutputList: TStringList read FOutputList;
  end;

implementation

// Global variable that points to the currently executing TScriptRunner instance.
// It is set in OnExecute and used by the plain wrapper functions below.
var
  CurrentRunner: TScriptRunner;

{ Retrieves a named input parameter that was passed by the host. }
function PS_GetParam(const Name: string): string;
begin
  if Assigned(CurrentRunner) then
    Result := CurrentRunner.GetParam(Name)
  else
    Result := '';
end;

{ Stores a named output value that the host can read after execution. }
procedure PS_SetOutput(const Name, Value: string);
begin
  if Assigned(CurrentRunner) then
    CurrentRunner.SetOutput(Name, Value);
end;

{ Returns the current Unix timestamp in milliseconds (UTC).
  This is a direct wrapper around TOS.GetTimestamp. }
function PS_GetTimestamp: int64;
begin
  Result := TOS.GetTimestamp;
end;

{ Returns a random integer with the given number of decimal digits.
  Example: GetRandom(6) returns a value between 100000 and 999999.
  This is a wrapper around TOS.GetRandom. }
function PS_GetRandom(ALength: integer): int64;
begin
  Result := TOS.GetRandom(ALength);
end;

{ Returns a pseudo-random floating-point number in the range [0, 1).
  This is the same as the standard System.Random when called without arguments. }
function PS_Random: extended;
begin
  Result := System.Random;
end;

{ Converts an integer value to a hexadecimal string representation,
  exactly like SysUtils.IntToHex. Digits specifies the minimum number
  of characters in the result (padded with leading zeros if needed). }
function PS_IntToHex(Value: integer; Digits: integer): string;
begin
  Result := SysUtils.IntToHex(Value, Digits);
end;

// Replaces all occurrences of OldPattern with NewPattern in S.
function PS_ReplaceAll(const S, OldPattern, NewPattern: string; IgnoreCase: boolean = False): string;
begin
  Result := S.ReplaceAll(OldPattern, NewPattern, IgnoreCase);
end;

// Replace all occurrences matching a regular expression pattern with Replacement.
// The search is case-insensitive by default.
function PS_RegexReplace(const Input, Pattern, Replacement: string): string;
begin
  Result := Input.RegexReplace(Pattern, Replacement);
end;

// Check if the input string matches the regular expression pattern.
// Returns True if at least one match is found.
function PS_RegexMatch(const Input, Pattern: string): boolean;
begin
  Result := Input.RegexMatch(Pattern);
end;

// Remove leading whitespace characters.
function PS_TrimLeft(const S: string): string;
begin
  Result := SysUtils.TrimLeft(S);
end;

// Remove trailing whitespace characters.
function PS_TrimRight(const S: string): string;
begin
  Result := SysUtils.TrimRight(S);
end;

// Encode special HTML characters into entities.
procedure PS_HtmlEncode(var Self: string; var Result: string);
begin
  Result := Self.HtmlEncode;
end;

// Decode HTML entities back to characters.
procedure PS_HtmlDecode(var Self: string; var Result: string);
begin
  Result := Self.HtmlDecode;
end;

// Percent-encode the string for safe URL inclusion.
procedure PS_UrlEncode(var Self: string; var Result: string);
begin
  Result := Self.UrlEncode;
end;

// Decode a percent-encoded URL string.
procedure PS_UrlDecode(var Self: string; var Result: string);
begin
  Result := Self.UrlDecode;
end;

// Check if the string matches the given regular expression pattern.
procedure PS_RegexMatch(var Self: string; const Pattern: string; var Result: boolean);
begin
  Result := Self.RegexMatch(Pattern);
end;

// Wrapper: s.ExtractBetween(StartMarker, EndMarker)
procedure PS_ExtractBetween(var Self: string; const StartMarker, EndMarker: string; var Result: string);
begin
  Result := Self.ExtractBetween(StartMarker, EndMarker);
end;

{ TScriptRunner }

constructor TScriptRunner.Create;
begin
  inherited Create;
  FPSScript := TPSScript.Create(nil);
  FScriptCode := TStringList.Create;
  FParams := TStringList.Create;
  FOutputList := TStringList.Create;
  // Wire up the script events
  FPSScript.OnCompile := @OnCompile;
  FPSScript.OnExecute := @OnExecute;
end;

destructor TScriptRunner.Destroy;
begin
  FPSScript.Free;
  FScriptCode.Free;
  FParams.Free;
  FOutputList.Free;
  inherited Destroy;
end;

procedure TScriptRunner.LoadScript(const ACode: TStrings);
begin
  FScriptCode.Assign(ACode);
  FIsCompiled := False;  // script changed, must recompile
end;

{ OnCompile event – registers all functions and procedures that will be
  available inside the script. }
procedure TScriptRunner.OnCompile(Sender: TPSScript);
begin
  // Input reader: allows the script to retrieve any parameter by name.
  Sender.AddFunction(@PS_GetParam, 'function GetParam(const Name: string): string;');

  // Output writer: the script calls this to store a result.
  Sender.AddFunction(@PS_SetOutput, 'procedure SetOutput(const Name, Value: string);');

  // Basic utility functions from TOS
  Sender.AddFunction(@PS_GetTimestamp, 'function GetTimestamp: Int64;');

  // Pseudo-random generator
  Sender.AddFunction(@PS_Random, 'function Random: Extended;');

  // Pseudo-random generator with length
  Sender.AddFunction(@PS_GetRandom, 'function GetRandom(ALength: Integer): Int64;');

  // Hexadecimal conversion
  Sender.AddFunction(@PS_IntToHex, 'function IntToHex(Value: Integer; Digits: Integer): string;');

  // Substring replacement function
  Sender.AddFunction(@PS_ReplaceAll, 'function ReplaceAll(const S, OldPattern, NewPattern: string; IgnoreCase: Boolean): string;');

  // Regular expression search and replace
  Sender.AddFunction(@PS_RegexReplace, 'function RegexReplace(const Input, Pattern, Replacement: string): string;');

  // Regular expression match test
  Sender.AddFunction(@PS_RegexMatch, 'function RegexMatch(const Input, Pattern: string): Boolean;');

  // Trim whitespace
  Sender.AddFunction(@PS_TrimLeft, 'function TrimLeft(const S: string): string;');
  Sender.AddFunction(@PS_TrimRight, 'function TrimRight(const S: string): string;');

  // HTML entity encoding and decoding
  Sender.AddFunction(@PS_HtmlEncode, 'function HtmlEncode(const S: string): string;');
  Sender.AddFunction(@PS_HtmlDecode, 'function HtmlDecode(const S: string): string;');

  // URL percent encoding and decoding
  Sender.AddFunction(@PS_UrlEncode, 'function UrlEncode(const S: string): string;');
  Sender.AddFunction(@PS_UrlDecode, 'function UrlDecode(const S: string): string;');

  // Extract substring between two markers
  Sender.AddFunction(@PS_ExtractBetween, 'function ExtractBetween(const S, StartMarker, EndMarker: string): string;');
end;

{ OnExecute event – called just before the script starts running.
  Here we store the current instance in the global variable so the
  wrapper functions know which object to work with. We also clear
  any previous output values. }
procedure TScriptRunner.OnExecute(Sender: TPSScript);
begin
  CurrentRunner := Self;
  FOutputList.Clear;
end;

{ Implementation of the GetParam function exposed to the script via PS_GetParam.
  It looks up the Name in the FParams string list and returns the
  corresponding value. If the name is not found, an empty string is returned. }
function TScriptRunner.GetParam(const Name: string): string;
begin
  Result := FParams.Values[Name];
end;

{ Implementation of the SetOutput procedure exposed to the script via PS_SetOutput.
  It stores a name=value pair in the FOutputList. }
procedure TScriptRunner.SetOutput(const Name, Value: string);
begin
  FOutputList.Values[Name] := Value;
end;

{ Compiles the loaded script. If errors are found, an exception is raised
  containing all compiler error messages. }
procedure TScriptRunner.Compile;
var
  i: integer;
  ErrMsg: string;
begin
  FPSScript.Script.Assign(FScriptCode);
  if not FPSScript.Compile then
  begin
    ErrMsg := '';
    for i := 0 to FPSScript.CompilerMessageCount - 1 do
      if FPSScript.CompilerMessages[i] is TPSPascalCompilerError then
        ErrMsg := ErrMsg + FPSScript.CompilerErrorToStr(i) + sLineBreak;
    if ErrMsg = '' then
      ErrMsg := 'Unknown compilation error.';
    raise Exception.Create('Script compilation error: ' + ErrMsg);
  end;
  FIsCompiled := True;
end;

{ Executes the compiled script. Calls Compile automatically if necessary.
  If execution fails, an exception is raised with the runtime error description. }
procedure TScriptRunner.Execute;
begin
  if not FIsCompiled then
    Compile;
  if not FPSScript.Execute then
    raise Exception.Create('Script execution error: ' + FPSScript.ExecErrorToString);
end;

end.
