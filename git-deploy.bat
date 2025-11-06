@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set PROJECT=D:\cursorDemo\weddingProj
set PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe

echo ===== 调试模式：开始执行 =====
echo 项目路径: %PROJECT%

if not exist "%PROJECT%" (
  echo ✗ 项目路径不存在: %PROJECT%
  pause
  exit /b 1
)

echo ✓ 项目路径存在
echo ===== Git 一键部署 =====
echo 1) 提交到 main（日常開發）
echo 2) 發布到 release（觸發 Netlify）

:retry_choice
set choice=
set /p "choice=请输入 1 或 2: "
if "!choice!"=="" (
  echo 错误：请输入选择
  goto retry_choice
)

echo 你选择了: !choice!
if not "!choice!"=="1" if not "!choice!"=="2" (
  echo 错误：请输入 1 或 2
  goto retry_choice
)

set mode=main
if "!choice!"=="2" set mode=release
echo 模式设置为: !mode!

set msg=chore: update
set /p "msg=提交说明(回车默认: chore: update): "
if "!msg!"=="" set msg=chore: update
echo 提交信息: !msg!

set version=
if "!mode!"=="release" (
  set /p "version=版本号(如 v1.0.0，可留空): "
  echo 版本号: !version!
)

echo.
echo ===== 准备执行PowerShell脚本 =====
echo 命令: "%PS%" -NoProfile -ExecutionPolicy Bypass -File "%PROJECT%\git-deploy.ps1" -Mode !mode! -Message "!msg!" -Version "!version!" -ProjectPath "%PROJECT%"
echo.

"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%PROJECT%\git-deploy.ps1" -Mode !mode! -Message "!msg!" -Version "!version!" -ProjectPath "%PROJECT%"

if errorlevel 1 (
  echo.
  echo ✗ PowerShell脚本执行失败，错误代码: !errorlevel!
  echo 请检查上面的错误信息
  pause
  exit /b 1
)

echo.
echo ✓ 完成。按任意鍵關閉...
pause >nul