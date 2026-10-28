# Utilitários BR em Delphi

Units em Object Pascal que eu uso com frequência em sistemas empresariais brasileiros: validação e formatação de CPF e CNPJ, e divisão de valores em parcelas sem perder centavo.

## O que tem

- `src/BrDocs.pas`: `CpfValido`, `CnpjValido`, `FormatarCpf`, `FormatarCnpj` e `SomenteDigitos`.
- `src/Parcelas.pas`: `DividirEmParcelas` (o resto dos centavos vai para a primeira parcela, então a soma fecha sempre no valor original) e `ParcelaPrice` (parcela fixa com juros compostos).
- `tests/Testes.dpr`: programa de console com 16 verificações, sem dependência de framework de teste.

## Como usar

```pascal
uses BrDocs, Parcelas;

if CpfValido('529.982.247-25') then
  Writeln(FormatarCpf('52998224725'));

var P := DividirEmParcelas(100, 3); // 33,34 / 33,33 / 33,33
```

## Rodando os testes

No Delphi, abra `tests/Testes.dpr`, ajuste o caminho das units se precisar e execute (F9). Pela linha de comando:

```
dcc32 -U..\src tests\Testes.dpr
```

Com Free Pascal (modo Delphi), a partir da raiz do projeto:

```
fpc -Mdelphi -Fusrc -FEbin -FUbin tests/Testes.dpr
bin\Testes.exe
```

Saída esperada: `16 de 16 testes passaram`.

## Observações

- Os testes foram executados com o Free Pascal 3.2.2 em modo Delphi. As units usam só `SysUtils` e `Math`, então devem compilar nas versões recentes do Delphi sem ajuste, mas ainda não rodei no compilador da Embarcadero.
- Os arquivos estão sem acentos no código por causa da codificação ANSI do Delphi sem BOM.
