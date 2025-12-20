import os
import subprocess

def run_terraform(directory, environment):
    """
    Function to execute Terraform commands in a directory with a specific environment.
    """
    print(f"Processing directory: {directory} with environment: {environment}")

    # Check if provider.tf exists in the directory
    provider_path = None
    for root, dirs, files in os.walk(directory):
        if "provider.tf" in files:
            provider_path = os.path.join(root, "provider.tf")
            break

    if provider_path:
        print(f"Found provider.tf at: {provider_path}")
    else:
        print(f"No provider.tf found in {directory}. Skipping...")
        return

    # Run Terraform commands
    try:
        print("Running 'terraform init'...")
        subprocess.run(["terraform", "init"], cwd=directory, check=True)

        print(f"Selecting or creating workspace: {environment}")
        # Select or create the workspace
        try:
            subprocess.run(["terraform", "workspace", "select", environment], cwd=directory, check=True)
        except subprocess.CalledProcessError:
            subprocess.run(["terraform", "workspace", "new", environment], cwd=directory, check=True)

        print("Running 'terraform plan'...")
        subprocess.run(["terraform", "plan"], cwd=directory, check=True)

        print("Running 'terraform apply'...")
        subprocess.run(["terraform", "apply", "-auto-approve"], cwd=directory, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error processing directory: {directory}. Error: {e}")

def find_terraform_dirs(base_dir):
    """
    Recursively find directories containing Terraform configuration files.
    """
    terraform_dirs = []
    for root, dirs, files in os.walk(base_dir):
        if any(file.endswith(".tf") for file in files):
            terraform_dirs.append(root)
    return terraform_dirs

def detect_environments(terraform_dirs):
    """
    Detect environments (dev, prod, qa) based on folder names.
    """
    environments = set()
    for directory in terraform_dirs:
        parts = directory.lower().split(os.sep)
        for env in ["dev", "prod", "qa"]:
            if env in parts:
                environments.add(env)
    return environments if environments else {"dev"}  # Default to dev if no environments are found

def main():
    base_dir = r"d:\\Work\\git\\terraform_work"

    # Find all directories with Terraform files
    terraform_dirs = find_terraform_dirs(base_dir)

    # Detect environments
    environments = detect_environments(terraform_dirs)
    print(f"Identified environments: {', '.join(environments)}")

    # Execute Terraform commands for each environment
    for environment in environments:
        for directory in terraform_dirs:
            if environment in directory.lower():
                run_terraform(directory, environment)

    print("All Terraform directories have been processed.")

if __name__ == "__main__":
    main()