Param(
  [ValidateSet('main','release')]
  [string]$Mode = 'main',
  [string]$Message = "chore: update",
  [string]$Version = "",
  [string]$ProjectPath = "D:\cursorDemo\weddingProj",
  [string]$Remote = "https://github.com/kongk1one/weddingProj.git"
)

$ErrorActionPreference = "Stop"

function Ensure-Git() {
  try { git --version | Out-Null } catch {
    Write-Host "✗ 请先安装 Git: https://git-scm.com/downloads" -ForegroundColor Red
    exit 1
  }
}

function Go-Project() {
  if (!(Test-Path $ProjectPath)) {
    Write-Host "✗ 项目路径不存在：$ProjectPath" -ForegroundColor Red
    exit 1
  }
  Set-Location $ProjectPath
}

function Ensure-Repo() {
  if (!(Test-Path '.git')) {
    git init
    git branch -M main
  }
  $remoteUrl = git remote get-url origin 2>$null
  if (!$remoteUrl) {
    git remote add origin $Remote
  } elseif ($remoteUrl -ne $Remote) {
    git remote set-url origin $Remote
  }
}

function Commit-And-Push-Main() {
  git checkout -q main 2>$null; if ($LASTEXITCODE -ne 0) { git checkout -b main }
  git add .
  git commit -m $Message 2>$null | Out-Null
  git push -u origin main
  Write-Host "✓ 已推送到 main" -ForegroundColor Green
}

function Publish-Release() {
  git checkout -q main 2>$null; if ($LASTEXITCODE -ne 0) { git checkout -b main }
  git add .
  $autoMsg = if ([string]::IsNullOrWhiteSpace($Message)) { "chore: release sync" } else { $Message }
  git commit -m $autoMsg 2>$null | Out-Null
  git push -u origin main

  $hasRelease = git branch --list release
  if (-not $hasRelease) { git checkout -b release } else { git checkout release }

  $relMsg = if (![string]::IsNullOrWhiteSpace($Version)) { "chore(release): $Version" } else { "chore(release): merge from main" }
  git merge main --no-ff -m $relMsg
  git push -u origin release

  git checkout main
  Write-Host "✓ 已推送到 release（Netlify 将自动部署）" -ForegroundColor Green
}

Ensure-Git
Go-Project
Ensure-Repo

switch ($Mode) {
  'main'    { Commit-And-Push-Main }
  'release' { Publish-Release }
}