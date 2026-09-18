<#
.SYNOPSIS
    Universal Frontend Development Harness — Project Installer for Windows PowerShell
.DESCRIPTION
    Installs the harness as a git submodule in the host project, initializes .project/ specs,
    scaffolds living project agent rules (AGENTS.md), feature templates, and CI/CD templates.
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

# Determine template source root
$harnessRoot = ""
if (Test-Path "$TargetPath/templates") {
    $harnessRoot = "$TargetPath/templates"
} elseif (Test-Path "templates") {
    $harnessRoot = "templates"
}

# 1. Scaffold .project/ directory, feature specs, and backend contracts
Write-Host "Checking project specification directory (.project/)..." -ForegroundColor Yellow
if (-not (Test-Path ".project")) {
    Write-Host "Creating .project/, .project/features/, and .project/contracts/ directories..." -ForegroundColor Green
    New-Item -ItemType Directory -Path ".project/features" -Force | Out-Null
    New-Item -ItemType Directory -Path ".project/contracts" -Force | Out-Null

    if ($harnessRoot) {
        Copy-Item -Path "$harnessRoot/project-spec/*.md" -Destination ".project/" -Force
        Copy-Item -Path "$harnessRoot/project-spec/features/*.md" -Destination ".project/features/" -Force
        if (Test-Path "$harnessRoot/project-spec/contracts") {
            Copy-Item -Path "$harnessRoot/project-spec/contracts/*.md" -Destination ".project/contracts/" -Force
        }
        Write-Host "Scaffolded default templates into .project/ from harness." -ForegroundColor Green
    }
} else {
    Write-Host ".project/ directory already exists." -ForegroundColor Gray
    if (-not (Test-Path ".project/features")) {
        New-Item -ItemType Directory -Path ".project/features" -Force | Out-Null
        if ($harnessRoot -and (Test-Path "$harnessRoot/project-spec/features")) {
            Copy-Item -Path "$harnessRoot/project-spec/features/*.md" -Destination ".project/features/" -Force
        }
    }
    if (-not (Test-Path ".project/contracts")) {
        New-Item -ItemType Directory -Path ".project/contracts" -Force | Out-Null
        if ($harnessRoot -and (Test-Path "$harnessRoot/project-spec/contracts")) {
            Copy-Item -Path "$harnessRoot/project-spec/contracts/*.md" -Destination ".project/contracts/" -Force
        }
    }
}

# 2. Scaffold host repository AGENTS.md (living rules for future agent runs)
if (-not (Test-Path "AGENTS.md") -and $harnessRoot) {
    if (Test-Path "$harnessRoot/project-root/AGENTS.md") {
        Write-Host "Scaffolding host repository AGENTS.md..." -ForegroundColor Green
        Copy-Item -Path "$harnessRoot/project-root/AGENTS.md" -Destination "AGENTS.md" -Force
    }
}

# 3. Scaffold GitHub PR template and CI/CD actions
if (-not (Test-Path ".github")) {
    New-Item -ItemType Directory -Path ".github/workflows" -Force | Out-Null
} elseif (-not (Test-Path ".github/workflows")) {
    New-Item -ItemType Directory -Path ".github/workflows" -Force | Out-Null
}

if ($harnessRoot) {
    if (Test-Path "$harnessRoot/github/pull_request_template.md" -and -not (Test-Path ".github/pull_request_template.md")) {
        Write-Host "Scaffolding .github/pull_request_template.md..." -ForegroundColor Green
        Copy-Item -Path "$harnessRoot/github/pull_request_template.md" -Destination ".github/pull_request_template.md" -Force
    }
    if (Test-Path "$harnessRoot/github-actions" -and -not (Test-Path ".github/workflows/ci.yml")) {
        Write-Host "Scaffolding GitHub Actions CI pipelines..." -ForegroundColor Green
        Copy-Item -Path "$harnessRoot/github-actions/*.yml" -Destination ".github/workflows/" -Force
    }
}

# 4. Ensure .worktrees/ is in .gitignore
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
