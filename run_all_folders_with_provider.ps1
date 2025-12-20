# PowerShell script to execute Terraform commands in all relevant folders with respective provider paths and environment handling

# Define the base directory
$baseDir = "d:\Work\git\terraform_work"

# Function to execute Terraform commands in a directory
function Run-Terraform {
    param (
        [string]$directory,
        [string]$environment  # Environment is passed explicitly
    )

    Write-Host "Processing directory: $directory with environment: $environment" -ForegroundColor Green

    # Navigate to the directory
    Push-Location $directory

    try {
        # Check if provider.tf exists in the directory
        $providerPath = Get-ChildItem -Path $directory -Filter "provider.tf" -Recurse -File | Select-Object -First 1

        if ($null -ne $providerPath) {
            Write-Host "Found provider.tf at: $($providerPath.FullName)" -ForegroundColor Cyan
        } else {
            Write-Host "No provider.tf found in $directory. Skipping..." -ForegroundColor Red
            return
        }

        # Initialize Terraform with the workspace
        Write-Host "Running 'terraform init'..." -ForegroundColor Yellow
        terraform init -upgrade

        # Select or create the workspace
        Write-Host "Selecting or creating workspace: $environment" -ForegroundColor Yellow
        terraform workspace select $environment 2>$null || terraform workspace new $environment

        # Plan Terraform
        Write-Host "Running 'terraform plan'..." -ForegroundColor Yellow
        terraform plan

        # Apply Terraform (auto-approve)
        Write-Host "Running 'terraform apply'..." -ForegroundColor Yellow
        terraform apply -auto-approve
    }
    catch {
        Write-Host "Error processing directory: $directory" -ForegroundColor Red
    }
    finally {
        # Return to the previous directory
        Pop-Location
    }
}

# Recursively find directories containing Terraform configuration files
$terraformDirs = Get-ChildItem -Path $baseDir -Recurse -Directory |
    Where-Object { Test-Path "$($_.FullName)\provider.tf" }

# Identify available environments based on folder names
$environments = @()
foreach ($dir in $terraformDirs) {
    if ($dir.FullName -match "(?i)(dev|prod|qa)") {
        $env = $Matches[1].ToLower()
        if (-not ($environments -contains $env)) {
            $environments += $env
        }
    }
}

if (-not $environments) {
    $environments = @("dev")  # Default to dev if no environments are found
}

Write-Host "Identified environments: $($environments -join ", ")" -ForegroundColor Green

# Execute Terraform commands for each environment
foreach ($environment in $environments) {
    $processed = $false
    foreach ($dir in $terraformDirs) {
        if ($dir.FullName -match "(?i)\\$environment\\|(?i)$environment$") {
            Run-Terraform -directory $dir.FullName -environment $environment
            $processed = $true
        }
    }
    if (-not $processed) {
        Write-Host "No directories found for environment: $environment" -ForegroundColor Yellow
    }
}

Write-Host "All Terraform directories have been processed." -ForegroundColor Green