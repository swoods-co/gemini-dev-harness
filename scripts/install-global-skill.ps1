<#
.SYNOPSIS
    One-Line Installer for Antigravity Global Bootstrap Skill (Windows PowerShell)
.DESCRIPTION
    Installs the 'init-frontend-harness' skill globally into ~/.gemini/config/skills/
    so any new project opened in Antigravity can be initialized with a simple prompt.
.EXAMPLE
    irm https://raw.githubusercontent.com/swoods-co/gemini-dev-harness/main/scripts/install-global-skill.ps1 | iex
#>

$ErrorActionPreference = "Stop"

Write-Host "Installing Antigravity Global Bootstrap Skill..." -ForegroundColor Cyan

$targetDir = Join-Path $env:USERPROFILE ".gemini\config\skills\init-frontend-harness"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$skillUrl = "https://raw.githubusercontent.com/swoods-co/gemini-dev-harness/main/skills/init-frontend-harness/SKILL.md"
$targetFile = Join-Path $targetDir "SKILL.md"

Invoke-WebRequest -Uri $skillUrl -OutFile $targetFile

Write-Host "Success! 'init-frontend-harness' skill installed globally at:" -ForegroundColor Green
Write-Host "  $targetFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can now open ANY empty folder in Antigravity and simply prompt:" -ForegroundColor White
Write-Host "  'Set up this project with my frontend harness'" -ForegroundColor Cyan
