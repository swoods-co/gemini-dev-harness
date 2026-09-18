<#
.SYNOPSIS
    Git Worktree Helper Script for Windows PowerShell
.DESCRIPTION
    Safely manages git worktrees for isolated agent tasks.
#>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("Create", "Remove", "List", "Prune")]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$Branch = ""
)

function Sanitize-BranchName([string]$name) {
    return ($name -replace '[^a-zA-Z0-9._-]', '-')
}

switch ($Action) {
    "Create" {
        if (-not $Branch) {
            Write-Error "Branch name required for Create."
            exit 1
        }
        $dirName = Sanitize-BranchName $Branch
        $targetPath = ".worktrees/$dirName"

        if (-not (Test-Path ".worktrees")) {
            New-Item -ItemType Directory -Path ".worktrees" | Out-Null
        }

        Write-Host "Creating worktree at $targetPath for branch $Branch..."
        git worktree add $targetPath -b $Branch
        Write-Host "Worktree created successfully."
        Write-Host "To enter worktree: cd $targetPath"
    }

    "Remove" {
        if (-not $Branch) {
            Write-Error "Branch name required for Remove."
            exit 1
        }
        $dirName = Sanitize-BranchName $Branch
        $targetPath = ".worktrees/$dirName"

        if (Test-Path $targetPath) {
            Write-Host "Removing worktree at $targetPath..."
            git worktree remove $targetPath
            Write-Host "Worktree removed."
        } else {
            Write-Warning "Target path $targetPath does not exist."
        }
        git worktree prune
    }

    "List" {
        git worktree list
    }

    "Prune" {
        git worktree prune -v
    }
}
