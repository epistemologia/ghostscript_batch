REM Chame este batch com parâmetro "1", "2" ou "3" (preferencialmente 3) para indicar PDF/A-1, PDF/A-2 ou PDF/A-3 respectivamente
REM Coloque o caminho e nome completo do executável ghostscript em "ghost.txt"

@echo off
setlocal enabledelayedexpansion

mkdir .\Saida

REM por padrão, queremos usar PDF/A-3; opcionalmente chamaremos o batch com um parâmetro "1", "2" ou "3".
if "%1"=="" (
    set arg1=3
) else (
    set arg1=%1
)

REM o segundo parâmetro é o caminho e nome do arquivo de saída; existe um valor padrão

if "%2"=="" (
    set arg2=..\Saida\_pdfa_concatenado.pdf
) else (
    set arg2=%2
)

REM incluímos o sufixo ".pdf" se ele não houver sido fornecido explicitamente.

if not "%arg2:~-4%"==".pdf" (
    set arg2=%arg2%.pdf
)

mkdir .\Entrada
copy inicie_aqui.bat .\Entrada
copy inicie_aqui.bat .\Saida

cd .\Entrada


rem Get files in alphabetical order
dir /b *.pdf *.fdf > files_a.txt
sort files_a.txt /o files_a.txt


rem Construct Ghostscript command
for /f "usebackq delims=" %%a in ("..\ghost.txt") do set gsCommand=%%a -dPDFA=%arg1% -dNOOUTERSAVE -sColorConversionStrategy=UseDeviceIndependentColor -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFACompatibilityPolicy=1 -sOutputFile=%arg2%

rem Iterate through files and append to command
for /f "tokens=*" %%f in (files_a.txt) do (
    set gsCommand=!gsCommand! "%%f"
)

rem Invoke Ghostscript
!gsCommand!

rem Clean up temporary file
del files_a.txt

cd ..\Saida
start .
