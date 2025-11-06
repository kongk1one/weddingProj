@echo off
chcp 65001 >nul
echo ==== 开始配置 GitHub + Netlify ===
echo.

REM 检查 Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Git 未安装，请先安装 Git
    pause
    exit /b 1
)

REM 检查项目文件
if not exist "index.html" (
    echo ✗ 未找到 index.html，请确保在项目根目录运行此脚本
    pause
    exit /b 1
)

echo ✓ 找到项目文件
echo.

REM 初始化 Git（如果未初始化）
if not exist ".git" (
    echo 初始化 Git 仓库...
    call git init
    call git branch -M main
    echo ✓ Git 仓库已初始化
) else (
    echo ✓ Git 仓库已存在
)

REM 配置远程仓库
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo 添加远程仓库...
    call git remote add origin https://github.com/kongk1one/weddingProj.git
    echo ✓ 远程仓库已添加
) else (
    echo ✓ 远程仓库已配置
    call git remote set-url origin https://github.com/kongk1one/weddingProj.git
)

REM 创建 .gitignore（如果不存在）
if not exist ".gitignore" (
    echo node_modules/ > .gitignore
    echo .env >> .gitignore
    echo .DS_Store >> .gitignore
    echo Thumbs.db >> .gitignore
    echo *.log >> .gitignore
    echo ✓ .gitignore 已创建
)

REM 添加所有文件
echo.
echo 添加文件到 Git...
call git add .

REM 提交
echo 提交更改...
call git commit -m "feat: initial commit - wedding site (NGA style)" 2>nul
if errorlevel 1 (
    echo ⚠ 没有需要提交的更改或已提交
) else (
    echo ✓ 提交完成
)

REM 创建 release 分支
echo.
echo 创建 release 分支...
call git checkout -b release 2>nul
if errorlevel 1 (
    call git checkout release
    echo ✓ release 分支已存在，已切换
)

REM 合并 main 到 release
call git checkout main
call git checkout release
call git merge main --no-ff -m "chore(release): merge from main" 2>nul
call git checkout main

echo.
echo ==== 准备推送代码 ====
echo 提示：如果首次推送，可能需要输入 GitHub 用户名和密码/令牌
echo.
set /p push="是否立即推送到 GitHub? (Y/N): "
if /i "%push%"=="Y" (
    echo.
    echo 推送 main 分支...
    call git push -u origin main
    echo.
    echo 推送 release 分支...
    call git checkout release
    call git push -u origin release
    call git checkout main
    echo.
    echo ✓ 推送完成！
) else (
    echo.
    echo 跳过推送。你可以稍后运行以下命令推送：
    echo   git push -u origin main
    echo   git checkout release
    echo   git push -u origin release
    echo   git checkout main
)

echo.
echo ==== 下一步：配置 Netlify ====
echo 1. 访问 https://app.netlify.com
echo 2. Add new site ^> Import an existing project
echo 3. Deploy with GitHub
echo 4. 选择仓库: kongk1one/weddingProj
echo 5. Branch to deploy: release
echo 6. Publish directory: ./
echo.
pause

