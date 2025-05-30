@echo off
setlocal

:: Caminhos
set SOURCE_ZIP=D:\contrato\contrato.zip
set DEST_DIR=%~dp0
set DEST_ZIP=%DEST_DIR%app.zip

echo.
echo 🔍 Verificando se app.zip existe no caminho: %SOURCE_ZIP%
if not exist "%SOURCE_ZIP%" (
    echo ❌ ERRO: O arquivo app.zip não foi encontrado em %SOURCE_ZIP%
    exit /b 1
)

echo ✅ Encontrado. Copiando para a pasta do projeto...
copy /Y "%SOURCE_ZIP%" "%DEST_ZIP%" > nul

if exist "%DEST_ZIP%" (
    echo ✅ app.zip copiado com sucesso para %DEST_DIR%
) else (
    echo ❌ Falha ao copiar app.zip
    exit /b 1
)

echo.
echo 🐳 Iniciando build do Docker...
docker compose build

if %ERRORLEVEL% NEQ 0 (
    echo ❌ O build do Docker falhou!
    exit /b 1
)

echo ✅ Build concluído com sucesso!
echo 🚀 Pronto para rodar com: docker compose up -d

endlocal
pause
