# GitHub + Netlify 自动化部署配置脚本
# 使用方法：在项目根目录运行此脚本
# PowerShell: .\setup-github-netlify.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== GitHub + Netlify 自动化部署配置 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Git 是否安装
try {
    $gitVersion = git --version
    Write-Host "✓ Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Git 未安装，请先安装 Git" -ForegroundColor Red
    exit 1
}

# GitHub 仓库信息
$githubRepo = "https://github.com/kongk1one/weddingProj.git"
$githubUser = "kongk1one"
$repoName = "weddingProj"

Write-Host "GitHub 仓库: $githubRepo" -ForegroundColor Yellow
Write-Host ""

# 检查是否已初始化 Git
if (Test-Path ".git") {
    Write-Host "✓ Git 仓库已存在" -ForegroundColor Green
} else {
    Write-Host "初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "✓ Git 仓库初始化完成" -ForegroundColor Green
}

# 检查远程仓库
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    Write-Host "✓ 远程仓库已配置: $remoteExists" -ForegroundColor Green
    if ($remoteExists -ne $githubRepo) {
        Write-Host "更新远程仓库地址..." -ForegroundColor Yellow
        git remote set-url origin $githubRepo
        Write-Host "✓ 远程仓库地址已更新" -ForegroundColor Green
    }
} else {
    Write-Host "添加远程仓库..." -ForegroundColor Yellow
    git remote add origin $githubRepo
    Write-Host "✓ 远程仓库已添加" -ForegroundColor Green
}

# 创建 .gitignore（如果不存在）
if (-not (Test-Path ".gitignore")) {
    Write-Host "创建 .gitignore..." -ForegroundColor Yellow
    @"
# 依赖
node_modules/
package-lock.json

# 构建输出
dist/
build/
.next/

# 环境变量
.env
.env.local

# 编辑器
.vscode/
.idea/
*.swp
*.swo

# 系统文件
.DS_Store
Thumbs.db

# 临时文件
*.log
*.tmp
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "✓ .gitignore 已创建" -ForegroundColor Green
}

# 添加所有文件
Write-Host "添加文件到 Git..." -ForegroundColor Yellow
git add .

# 提交更改
Write-Host "提交更改..." -ForegroundColor Yellow
$commitMessage = Read-Host "请输入提交信息（直接回车使用默认）"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "feat: initial commit - wedding site (NGA style)"
}

try {
    git commit -m $commitMessage
    Write-Host "✓ 提交完成" -ForegroundColor Green
} catch {
    Write-Host "⚠ 提交可能失败（文件未更改或已提交）" -ForegroundColor Yellow
}

# 创建 release 分支
Write-Host "创建 release 分支..." -ForegroundColor Yellow
$branchExists = git branch --list release 2>$null
if (-not $branchExists) {
    git checkout -b release
    Write-Host "✓ release 分支已创建" -ForegroundColor Green
} else {
    git checkout release
    Write-Host "✓ 已切换到 release 分支" -ForegroundColor Green
}

# 合并 main 到 release（如果不同）
git checkout main
$mainCommit = git rev-parse HEAD
$releaseCommit = git rev-parse release 2>$null
if ($mainCommit -ne $releaseCommit) {
    Write-Host "合并 main 到 release..." -ForegroundColor Yellow
    git checkout release
    git merge main --no-ff -m "chore(release): merge from main"
    Write-Host "✓ 合并完成" -ForegroundColor Green
} else {
    Write-Host "✓ main 和 release 已同步" -ForegroundColor Green
}

# 推送到 GitHub
Write-Host ""
Write-Host "推送代码到 GitHub..." -ForegroundColor Yellow
Write-Host "提示：如果这是首次推送，可能需要输入 GitHub 用户名和密码/令牌" -ForegroundColor Cyan

try {
    git push -u origin main
    Write-Host "✓ main 分支已推送" -ForegroundColor Green
    
    git checkout release
    git push -u origin release
    Write-Host "✓ release 分支已推送" -ForegroundColor Green
} catch {
    Write-Host "⚠ 推送失败，请检查网络连接和 GitHub 认证" -ForegroundColor Red
    Write-Host "提示：可以使用 GitHub CLI (gh) 或配置 SSH 密钥" -ForegroundColor Yellow
}

# 返回 main 分支
git checkout main

Write-Host ""
Write-Host "=== GitHub 配置完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：配置 Netlify 自动部署" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 访问 https://app.netlify.com" -ForegroundColor Cyan
Write-Host "2. 点击 'Add new site' > 'Import an existing project'" -ForegroundColor Cyan
Write-Host "3. 选择 'Deploy with GitHub'" -ForegroundColor Cyan
Write-Host "4. 授权 GitHub 并选择仓库: $githubUser/$repoName" -ForegroundColor Cyan
Write-Host "5. 配置部署设置：" -ForegroundColor Cyan
Write-Host "   - Branch to deploy: release" -ForegroundColor White
Write-Host "   - Build command: (留空)" -ForegroundColor White
Write-Host "   - Publish directory: ./" -ForegroundColor White
Write-Host "6. 点击 'Deploy site'" -ForegroundColor Cyan
Write-Host ""
Write-Host "完成配置后，每次将代码合并到 release 分支时，Netlify 会自动部署。" -ForegroundColor Green
Write-Host ""

