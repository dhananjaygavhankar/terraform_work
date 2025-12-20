# PowerShell script to execute Terraform commands in all relevant folders with respective provider paths

# Define the base directory
$baseDir = "d:\Work\git\terraform_work"

# Function to execute Terraform commands in a directory
function Run-Terraform {
    param (
        [string]$directory
    )

    Write-Host "Processing directory: $directory" -ForegroundColor Green

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

        # Initialize Terraform
        Write-Host "Running 'terraform init'..." -ForegroundColor Yellow
        terraform init

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
    Where-Object { Test-Path "$($_.FullName)\*.tf" }

# Execute Terraform commands in each directory
foreach ($dir in $terraformDirs) {
    Run-Terraform -directory $dir.FullName
}

Write-Host "All Terraform directories have been processed." -ForegroundColor Green