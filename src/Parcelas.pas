unit Parcelas;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  TParcelas = array of Currency;

{ Divide AValor em ANumero parcelas. O resto dos centavos vai para a primeira
  parcela, entao a soma sempre fecha exatamente em AValor. }
function DividirEmParcelas(AValor: Currency; ANumero: Integer): TParcelas;

{ Parcela fixa com juros compostos mensais (tabela Price). ATaxa em fracao,
  por exemplo 0.02 para 2% ao mes. }
function ParcelaPrice(AValor, ATaxa: Double; ANumero: Integer): Currency;

implementation

uses
  SysUtils, Math;

function DividirEmParcelas(AValor: Currency; ANumero: Integer): TParcelas;
var
  Centavos, Base, Resto: Int64;
  I: Integer;
begin
  if ANumero < 1 then
    raise EArgumentException.Create('Numero de parcelas deve ser maior que zero');
  if AValor < 0 then
    raise EArgumentException.Create('Valor nao pode ser negativo');

  Centavos := Round(AValor * 100);
  Base := Centavos div ANumero;
  Resto := Centavos mod ANumero;

  SetLength(Result, ANumero);
  for I := 0 to ANumero - 1 do
    Result[I] := Base / 100;
  Result[0] := (Base + Resto) / 100;
end;

function ParcelaPrice(AValor, ATaxa: Double; ANumero: Integer): Currency;
var
  Fator: Double;
begin
  if ANumero < 1 then
    raise EArgumentException.Create('Numero de parcelas deve ser maior que zero');
  if ATaxa = 0 then
  begin
    Result := AValor / ANumero;
    Exit;
  end;
  Fator := Power(1 + ATaxa, ANumero);
  Result := AValor * (ATaxa * Fator) / (Fator - 1);
end;

end.
