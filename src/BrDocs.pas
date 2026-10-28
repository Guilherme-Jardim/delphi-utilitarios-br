unit BrDocs;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

{ Remove tudo que nao for digito. }
function SomenteDigitos(const AValor: string): string;

function CpfValido(const ACpf: string): Boolean;
function CnpjValido(const ACnpj: string): Boolean;

function FormatarCpf(const ACpf: string): string;
function FormatarCnpj(const ACnpj: string): string;

implementation

uses
  SysUtils;

function SomenteDigitos(const AValor: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValor) do
    if (AValor[I] >= '0') and (AValor[I] <= '9') then
      Result := Result + AValor[I];
end;

{ True quando todos os caracteres sao iguais (ex.: 11111111111). }
function TodosIguais(const AValor: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 2 to Length(AValor) do
    if AValor[I] <> AValor[1] then
    begin
      Result := False;
      Exit;
    end;
end;

function CpfValido(const ACpf: string): Boolean;
var
  Cpf: string;
  I, Soma, Dv1, Dv2: Integer;
begin
  Cpf := SomenteDigitos(ACpf);
  Result := False;
  if (Length(Cpf) <> 11) or TodosIguais(Cpf) then
    Exit;

  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + StrToInt(Cpf[I]) * (11 - I);
  Dv1 := (Soma * 10) mod 11;
  if Dv1 = 10 then
    Dv1 := 0;

  Soma := 0;
  for I := 1 to 10 do
    Soma := Soma + StrToInt(Cpf[I]) * (12 - I);
  Dv2 := (Soma * 10) mod 11;
  if Dv2 = 10 then
    Dv2 := 0;

  Result := (Dv1 = StrToInt(Cpf[10])) and (Dv2 = StrToInt(Cpf[11]));
end;

function CnpjValido(const ACnpj: string): Boolean;
const
  Pesos1: array[1..12] of Integer = (5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
  Pesos2: array[1..13] of Integer = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
var
  Cnpj: string;
  I, Soma, Dv1, Dv2: Integer;
begin
  Cnpj := SomenteDigitos(ACnpj);
  Result := False;
  if (Length(Cnpj) <> 14) or TodosIguais(Cnpj) then
    Exit;

  Soma := 0;
  for I := 1 to 12 do
    Soma := Soma + StrToInt(Cnpj[I]) * Pesos1[I];
  Dv1 := Soma mod 11;
  if Dv1 < 2 then
    Dv1 := 0
  else
    Dv1 := 11 - Dv1;

  Soma := 0;
  for I := 1 to 13 do
    Soma := Soma + StrToInt(Cnpj[I]) * Pesos2[I];
  Dv2 := Soma mod 11;
  if Dv2 < 2 then
    Dv2 := 0
  else
    Dv2 := 11 - Dv2;

  Result := (Dv1 = StrToInt(Cnpj[13])) and (Dv2 = StrToInt(Cnpj[14]));
end;

function FormatarCpf(const ACpf: string): string;
var
  C: string;
begin
  C := SomenteDigitos(ACpf);
  if Length(C) <> 11 then
    raise EConvertError.Create('CPF deve ter 11 digitos');
  Result := Copy(C, 1, 3) + '.' + Copy(C, 4, 3) + '.' + Copy(C, 7, 3) + '-' + Copy(C, 10, 2);
end;

function FormatarCnpj(const ACnpj: string): string;
var
  C: string;
begin
  C := SomenteDigitos(ACnpj);
  if Length(C) <> 14 then
    raise EConvertError.Create('CNPJ deve ter 14 digitos');
  Result := Copy(C, 1, 2) + '.' + Copy(C, 3, 3) + '.' + Copy(C, 6, 3) + '/' +
    Copy(C, 9, 4) + '-' + Copy(C, 13, 2);
end;

end.
