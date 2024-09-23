## Chapter 14: Setting Up a Control Machine for Ansible Using Amazon Lightsail

---

### Introduction

In this chapter, we will walk you through setting up a **blank Ubuntu instance** on **Amazon Lightsail** to serve as your **Ansible control machine**. We’ll name this machine **FountainController**. This machine will be used to automate infrastructure management for FountainAI using **Ansible**, **Git**, and **GitHub CLI**.

The process will cover:
1. Making FountainController easily accessible via SSH.
2. Installing essential tools: **GitHub CLI** (`gh`), **AWS CLI**, **Git**, **Python**, and **Ansible**.
3. Bootstrapping the **Ansible environment** using a shell script that creates a **private GitHub repository** for version control.
4. Setting up a **push-pull workflow** with Git to manage infrastructure updates using Ansible.

By the end of this chapter, you will have **FountainController** ready to manage infrastructure using **Ansible**, **Git**, and **GitHub workflows** for **version control**, **automation**, and **collaboration**.

---

### Step 1: Provisioning FountainController on Lightsail

#### Why Amazon Lightsail?

Amazon Lightsail is a lightweight service that makes it easy to provision **low-cost instances** quickly. It’s a perfect environment for setting up a control machine without the overhead of larger AWS services.

**Provision an Ubuntu 20.04 LTS instance** on **Amazon Lightsail**:

1. **Login to Lightsail**: 
   - Visit [Amazon Lightsail](https://lightsail.aws.amazon.com).
   - You may need to create an AWS account if you don’t already have one.

2. **Create a new instance**:
   - Select **Linux/Unix** as the platform.
   - Choose **Ubuntu 20.04 LTS**.
   - **Instance Plan**: Start with the $5 plan, which provides adequate resources for testing.
   - **Instance Name**: Name your instance `FountainController` to keep things organized.

3. **Download the SSH key**:
   - Lightsail automatically generates an SSH key when creating an instance.
   - Download this key to your machine, as you’ll need it to connect to FountainController securely.

**Common Pitfall**: 
If you forget to download the SSH key, you’ll be unable to access your instance via SSH. You can regenerate a key from the Lightsail console, but this will replace any existing SSH key.

---

### Step 2: Making FountainController Easily Accessible via SSH

#### Why Configure SSH?

Instead of typing long SSH commands every time you want to connect to FountainController, you can simplify the process by configuring SSH locally.

**Edit your SSH configuration**:

1. **Open the SSH configuration file**:
   ```bash
   nano ~/.ssh/config
   ```

2. **Add the following configuration**:
   Replace `<Public IP of FountainController>` with your instance’s public IP and point to the path where you downloaded the Lightsail SSH key.

   ```bash
   Host FountainController
       HostName <Public IP of FountainController>
       User ubuntu
       IdentityFile /path/to/LightsailKey.pem
   ```

3. **Save and close the file** by pressing `CTRL + X`, then `Y`, and hit `Enter`.

Now, to connect to FountainController, you simply need to type:

```bash
ssh FountainController
```

**Common Pitfall**: 
If you encounter a "Permission denied" error when connecting, make sure that your SSH key file has the correct permissions. You can fix it by running:

```bash
chmod 400 /path/to/LightsailKey.pem
```

---

### Step 3: Installing Critical Tools for Ansible and GitHub Workflow

At this stage, we need to install the tools that will allow us to manage **FountainController** and **connect it to GitHub**. These include **Git**, **GitHub CLI (gh)**, **AWS CLI**, **Python**, and **Ansible**.

#### 1. Installing Python

Python is essential for running Ansible. Install Python by running the following commands:

```bash
sudo apt update
sudo apt install python3 -y
```

You can verify that Python was installed correctly by checking the version:

```bash
python3 --version
```

**Common Pitfall**: If you get an error during the installation, run `sudo apt-get update` first to refresh your package list.

#### 2. Installing Git

Git will be used to manage our **Ansible playbooks** and configurations. Install Git by running:

```bash
sudo apt install git -y
```

Verify the installation by checking the version:

```bash
git --version
```

#### 3. Installing Ansible

Ansible will be the tool we use to manage infrastructure and run playbooks. To install Ansible:

```bash
sudo apt install ansible -y
```

Check the version to confirm the installation:

```bash
ansible --version
```

**Common Pitfall**: If the default `apt` repository doesn’t provide the latest Ansible version, you may want to add the Ansible PPA (Personal Package Archive) and install from there:

```bash
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

#### 4. Installing GitHub CLI (`gh`)

The **GitHub CLI** allows us to interact with GitHub directly from the terminal, including creating repositories, managing pull requests, and more.

To install `gh`:

```bash
sudo apt install gh -y
```

Verify the installation:

```bash
gh --version
```

**Authorize GitHub CLI**:

You’ll need to log in to GitHub via the CLI:

```bash
gh auth login
```

Follow the prompts, which will open a web browser to authorize the CLI with your GitHub account. This will allow you to push code, manage repositories, and more.

**Common Pitfall**: If you encounter issues logging in, make sure you are connected to the internet and have access to GitHub.

#### 5. Installing AWS CLI

The **AWS CLI** allows you to manage your Lightsail instance and other AWS services from the command line.

Install AWS CLI by running:

```bash
sudo apt install awscli -y
```

Verify the installation:

```bash
aws --version
```

**Configure AWS CLI**:

After installation, you need to configure AWS CLI with your **AWS Access Key ID** and **AWS Secret Access Key**. Run the following command:

```bash
aws configure
```

You’ll be prompted to enter:
- **AWS Access Key ID**
- **AWS Secret Access Key**
- **Default region** (e.g., `us-east-1`)
- **Default output format** (e.g., `json`)

**Common Pitfall**: If you haven’t already created an **IAM user** with API access, you’ll need to do that from the AWS console first. Ensure the IAM user has the necessary permissions to interact with Lightsail.

---

### Step 4: Bootstrapping the Ansible Environment with GitHub

Now that all critical tools are installed, we will **bootstrap the Ansible environment** by creating a **private GitHub repository** to store all playbooks, roles, and inventory files.

We’ll use the following script to automate this setup.

---

### Shell Script: `setup_ansible_environment.sh`

```bash
#!/bin/bash

# FountainAI Script: Setup Ansible Environment with GitHub
# Author: Contexter
# Description: Automates the setup of an Ansible environment 
#              by creating a private GitHub repository and initializing
#              the Ansible directory structure. If the repository already exists, it will delete it first.

# Configuration Variables
GITHUB_USER="YourGitHubUsername"  # Replace this with your GitHub username
REPO_NAME="fountaincontroller-ansible"
PROJECT_DIR="$HOME/ansible"
REQUIREMENTS_FILE="$PROJECT_DIR/requirements.yml"
README_FILE="$PROJECT_DIR/README.md"
GITHUB_REPO_SSH_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"  # Using SSH URL instead of HTTPS

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Delete existing GitHub repository
delete_github_repo() {
  echo "Checking if GitHub repository $REPO_NAME already exists..."
  if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
    echo "Repository $REPO_NAME already exists. Deleting it..."
    gh repo delete "$GITHUB_USER/$REPO_NAME" --yes
    if [ $? -eq 0 ]; then
      echo "Repository $REPO_NAME deleted successfully."
    else
      echo "Error: Failed to delete GitHub repository. Exiting..."
      exit 1
    fi
  else
    echo "No existing repository found with the name $REPO_NAME."
  fi
}

# Create a private GitHub repository using GitHub CLI
create_github_repo() {
  echo "Creating private GitHub repository: $REPO_NAME"
  gh repo create "$GITHUB_USER/$REPO_NAME" --private --confirm
  if [ $? -eq 0 ]; then
    echo "Repository $REPO_NAME created successfully."
  else
    echo "Error: Failed to create GitHub repository. Exiting..."
    exit 1
  fi
}

# Initialize the Ansible directory structure
initialize_ansible_structure() {
  echo "Setting up Ansible directory structure at $PROJECT_DIR"
  mkdir -p "$PROJECT_DIR/playbooks" "$PROJECT_DIR/roles" "$PROJECT_DIR/inventory"
  if [ $? -eq 0 ]; then
    echo "Ansible directory structure created."
  else
    echo "Error: Failed to create Ansible directories. Exiting..."
    exit 1
  fi
}

# Initialize Git and push to GitHub using GitHub CLI (via SSH)
initialize_git_and_push() {
  echo "Initializing Git repository at $PROJECT_DIR"
  cd "$PROJECT_DIR" || exit
  git init
  git branch -M main  # Renaming the default branch to main
  git remote remove origin 2>/dev/null  # Remove existing origin to avoid conflicts
  git remote add origin "$GITHUB_REPO_SSH_URL"  # Using SSH URL instead of HTTPS
  
  touch "$README_FILE"
  echo "# FountainController Ansible Environment" > "$README_FILE"

  cat > "$REQUIREMENTS_FILE" <<EOL
---
# Example roles and collections
EOL

  git add .
  git commit -m "Initial commit: Set up Ansible directory structure"
  
  # Push changes to the GitHub repository using SSH
  git push -u origin main  # Push to the main branch using SSH
  if [ $? -eq 0 ]; then
    echo "Project pushed to GitHub successfully."
  else
    echo "Error: Failed to push project to GitHub. Exiting..."
    exit 1
  fi
}

# Main Execution
if ! command_exists gh; then
  echo "Error: GitHub CLI (gh) is not installed. Please install gh before running this script."
  exit 1
fi

# Step 1: Delete the existing repository if it exists
delete_github_repo

# Step 2: Create a new repository
create_github_repo

# Step 3: Set up Ansible structure and Git
initialize_ansible_structure
initialize_git_and_push

echo "Setup complete."
echo "1. Clone the repository: git clone $GITHUB_REPO_SSH_URL"
echo "2. Change to the project directory: cd $REPO_NAME"
echo "3. Add your playbooks and roles in the appropriate directories."
```

This updated script includes **SSH authentication** for GitHub, which prevents the need for a username/password and ensures a smooth push to the repository.

---

### Conclusion

In this chapter, we have covered the process of setting up **FountainController** using **Git**, **Ansible**, **GitHub CLI**, and **AWS CLI**. By automating the setup using the `setup_ansible_environment.sh` script and using **push-pull workflows**, you now have a fully functional, version-controlled **Ansible environment** for managing infrastructure efficiently.

