@echo off
chcp 65001 >nul
setlocal
set -ExecutionPolicy -Scope CurrentUser RemoteSigned
set PROJECT=D:\cursorDemo\weddingProj
set PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe

if not exist "%PROJECT%" (
  echo ✗ 项目路径不存在: %PROJECT%
  pause
  exit /b 1
)

echo ===== Git 一键部署 =====
echo 1) 提交到 main（日常開發）
echo 2) 發布到 release（觸發 Netlify）
set /p choice=輸入 1 或 2: 

set mode=main
if "%choice%"=="2" set mode=release

set /p msg=提交說明(回車默認: chore: update):
if "%msg%"=="" set msg=chore: update

set version=
if "%mode%"=="release" (
  set /p version=版本號(如 v1.0.0，可留空):
)

"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%PROJECT%\git-deploy.ps1" -Mode %mode% -Message "%msg%" -Version "%version%" -ProjectPath "%PROJECT%"
echo.
echo 完成。按任意鍵關閉...
pause >nul