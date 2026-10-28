program Testes;

{$APPTYPE CONSOLE}
{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

uses
  SysUtils,
  BrDocs in '..\src\BrDocs.pas',
  Parcelas in '..\src\Parcelas.pas';

var
  Falhas: Integer = 0;
  Total: Integer = 0;

procedure Verificar(const ANome: string; ACondicao: Boolean);
begin
  Inc(Total);
  if ACondicao then
    WriteLn('[ok]    ', ANome)
  else
  begin
    Inc(Falhas);
    WriteLn('[FALHA] ', ANome);
  end;
end;

procedure TestarCpf;
begin
  Verificar('CPF valido com mascara', CpfValido('529.982.247-25'));
  Verificar('CPF valido sem mascara', CpfValido('52998224725'));
  Verificar('CPF com digito errado', not CpfValido('529.982.247-24'));
  Verificar('CPF com todos os digitos iguais', not CpfValido('111.111.111-11'));
  Verificar('CPF com tamanho errado', not CpfValido('1234'));
  Verificar('Formatar CPF', FormatarCpf('52998224725') = '529.982.247-25');
end;

procedure TestarCnpj;
begin
  Verificar('CNPJ valido com mascara', CnpjValido('11.222.333/0001-81'));
  Verificar('CNPJ valido sem mascara', CnpjValido('11222333000181'));
  Verificar('CNPJ com digito errado', not CnpjValido('11.222.333/0001-80'));
  Verificar('CNPJ com todos os digitos iguais', not CnpjValido('00000000000000'));
  Verificar('Formatar CNPJ', FormatarCnpj('11222333000181') = '11.222.333/0001-81');
end;

procedure TestarParcelas;
var
  P: TParcelas;
  I: Integer;
  Soma: Currency;
begin
  P := DividirEmParcelas(100, 3);
  Soma := 0;
  for I := 0 to High(P) do
    Soma := Soma + P[I];
  Verificar('100 em 3 parcelas fecha em 100', Soma = 100);
  Verificar('Primeira parcela leva o resto', P[0] = 33.34);
  Verificar('Demais parcelas iguais', (P[1] = 33.33) and (P[2] = 33.33));
  Verificar('Price sem juros divide igual', ParcelaPrice(1200, 0, 12) = 100);
  Verificar('Price com 2% em 12x', Abs(ParcelaPrice(1000, 0.02, 12) - 94.56) < 0.01);
end;

begin
  TestarCpf;
  TestarCnpj;
  TestarParcelas;
  WriteLn;
  WriteLn(Total - Falhas, ' de ', Total, ' testes passaram');
  if Falhas > 0 then
    Halt(1);
end.
