<#
.SYNOPSIS
    Universal Frontend Development Harness — Project Installer for Windows PowerShell
.DESCRIPTION
    Installs the harness as a git submodule in the host project, initializes .project/ specs,
    and validates .gitignore.
.PARAMETER SubmoduleUrl
    The Git clone URL of the harness repository.
.PARAMETER TargetPath
    The target directory inside the host repository (defaults to .agents/plugins/frontend-harness).
#>
param(
    [Parameter(Position=0)]
    [string]$SubmoduleUrl = "",

    [Parameter(Position=1)]
    [string]$TargetPath = ".agents/plugins/frontend-harness"
)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Universal Frontend Development Harness Installer" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Check if inside git repository
try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
    if (-not $repoRoot) {
        Write-Error "Must be executed inside a Git repository."
        exit 1
    }
} catch {
    Write-Error "Git command failed. Ensure Git is installed and you are in a repo."
    exit 1
}

Set-Location $repoRoot

# Handle submodule addition if URL provided
if ($SubmoduleUrl) {
    Write-Host "Adding harness as git submodule at $TargetPath..." -ForegroundColor Yellow
    if (-not (Test-Path ".agents/plugins")) {
        New-Item -ItemType Directory -Path ".agents/plugins" -Force | Out-Null
    }

    if (-not (Test-Path $TargetPath)) {
        git submodule add $SubmoduleUrl $TargetPath
        git submodule update --init --recursive
    } else {
        Write-Host "Submodule directory $TargetPath exists. Updating..." -ForegroundColor Yellow
        git submodule update --remote $TargetPath
    }
}

# Scaffold .project/ directory if not present
Write-Host "Checking project specification directory (.project/)..." -ForegroundColor Yellow
if (-not (Test-Path ".project")) {
    Write-Host "Creating .project/ directory..." -ForegroundColor Green
    New-Item -ItemType Directory -Path ".project" -Force | Out-Null

    $templateSource = ""
    if (Test-Path "$TargetPath/templates/project-spec") {
        $templateSource = "$TargetPath/templates/project-spec"
    } elseif (Test-Path "templates/project-spec") {
        $templateSource = "templates/project-spec"
    }

    if ($templateSource) {
        Copy-Item -Path "$templateSource/*.md" -Destination ".project/" -Force
        Write-Host "Scaffolded default templates into .project/ from harness." -ForegroundColor Green
    }
} else {
    Write-Host ".project/ directory already exists." -ForegroundColor Gray
}

# Ensure .worktrees/ is in .gitignore
if (Test-Path ".gitignore") {
    $gitignoreContent = Get-Content ".gitignore" -Raw
    if ($gitignoreContent -notmatch "\.worktrees/") {
        Write-Host "Adding .worktrees/ to .gitignore..." -ForegroundColor Green
        Add-Content -Path ".gitignore" -Value "`n# Isolated Git Worktrees`n.worktrees/"
    }
} else {
    Write-Host "Creating .gitignore with .worktrees/..." -ForegroundColor Green
    Set-Content -Path ".gitignore" -Value "# Isolated Git Worktrees`n.worktrees/`n"
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Harness installation and project contract setup complete!" -ForegroundColor Green
Write-Host " Next steps:" -ForegroundColor White
Write-Host " 1. Open Antigravity in this project." -ForegroundColor White
Write-Host " 2. Run agent with 'project-scoping' to finalize .project/SCOPE.md" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan
