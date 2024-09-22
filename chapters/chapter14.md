## Chapter 14: Setting Up a Control Machine for Ansible Using Amazon Lightsail

---

### Introduction

In this chapter, we will walk you through setting up a **blanc Ubuntu instance** on **Amazon Lightsail** to serve as your **Ansible control machine**. We’ll name this machine **FountainController**. This machine will be used to automate infrastructure management for FountainAI using **Ansible**, **Git**, and **GitHub CLI**.

The process will cover:
1. Making FountainController easily accessible via SSH.
2. Installing essential tools: **GitHub CLI** (`gh`), **AWS CLI**, **Git**, **Python**, and **Ansible**.
3. Bootstrapping the **Ansible environment** using a shell script that creates a **private GitHub repository** for version control.
4. Setting up a **push-pull workflow** with Git to manage infrastructure updates using Ansible.

By the end of this chapter, you will have **FountainController** ready to manage infrastructure, using **Ansible**, **Git**, and **GitHub workflows** for **version control**, **automation**, and **collaboration**.

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
#              the Ansible directory structure.

# Configuration Variables
GITHUB_USER="YourGitHubUsername"
REPO_NAME="fountaincontroller-ansible"
PROJECT_DIR="$HOME/ansible"
REQUIREMENTS_FILE="$PROJECT_DIR/requirements.yml"
README_FILE="$PROJECT_DIR/README.md"
GITHUB_REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
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

# Initialize Git and push to GitHub
initialize_git_and_push() {
  echo "Initializing Git repository at $PROJECT_DIR"
  git init
  git remote add origin "$GITHUB_REPO_URL"
  touch "$README_FILE"
  echo "# FountainController Ansible Environment" > "$README_FILE"

  cat > "$REQUIREMENTS_FILE" <<EOL
---
# Example roles and collections
EOL

  git add .
  git commit -m "Initial commit: Set up Ansible directory structure"
  git branch -M main
  git push -u origin main
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

create_github_repo
initialize_ansible_structure
initialize_git_and_push

echo "Setup complete."
echo "1. Clone the repository: git clone $GITHUB_REPO_URL"
echo "2. Change to the project directory: cd $REPO_NAME"
echo "3. Add your playbooks and roles in the appropriate directories."
```

This script automates the process of creating a **private GitHub repository**, initializing the **Ansible environment**, and pushing the basic structure to GitHub.

---

### Step 5: Managing the Push-Pull Workflow

With the **GitHub repository** created and the **Ansible environment** bootstrapped, you can now manage all infrastructure through a **push-pull workflow** using Git.

Here’s how you can manage updates:

#### 1. Clone the Repository

You can clone the repository from any machine to start working on it locally:

```bash
git clone https://github.com/YourGitHubUsername/fountaincontroller-ansible.git
cd fountaincontroller-ansible
```

#### 2. Make Changes

Add your **playbooks**, **roles**, or **inventory files** to the appropriate directories. For example, if you want to create a new playbook to install **Git** on a server:

```bash
cd playbooks
nano install_git.yml
```

#### 3. Commit and Push Changes

Once changes are made, commit them to the repository:

```bash
git add .
git commit -m "Added playbook to install Git"
git push origin main
```

#### 4. Pull Changes from Another Machine

To keep other machines in sync, you can pull changes from the repository:

```bash
git pull origin main
```

This ensures that all team members or machines are always working with the latest version of the playbooks.

---

### Conclusion

In this chapter, we have covered the process of setting up **FountainController** using **Git**, **Ansible**, **GitHub CLI**, and **AWS CLI**. By automating the setup using the `setup_ansible_environment.sh` script and using **push-pull workflows**, you now have a fully functional, version-controlled **Ansible environment** for managing infrastructure efficiently.

For more information on the topics we covered:
- **Chapter 7: Shell Scripting and Idempotency**
- **Chapter 8: Ansible Automation**
- **GitHub CLI and AWS CLI Documentation**

---

## Appendix: Transition from Push-Pull Workflow to GitHub Workflows for Automation

---

### Introduction

In this chapter, we introduced the **push-pull workflow** as a foundational practice for managing your **Ansible environment** through **GitHub**. This workflow allows you to:
- **Version control your infrastructure**: Keep track of changes to playbooks, roles, and configurations.
- **Sync your environment** across different machines or collaborators by pushing changes to a **central GitHub repository** and pulling updates.

While the **push-pull workflow** is essential for keeping your infrastructure consistent and synchronized, it is not directly tied to **local development** but rather to ensure that changes are **tracked**, **collaborative**, and **transparent** as part of a broader automation strategy. The next step in this evolution is the introduction of **GitHub Actions** and **event-driven workflows** to automate deployments and infrastructure management without requiring manual interventions.

---

### The Push-Pull Workflow for Infrastructure Management

The **push-pull workflow** is a core method for managing infrastructure through GitHub. The goal here is not to develop locally, but to ensure your infrastructure's **Ansible configuration** is versioned, backed up, and synchronized across all relevant machines. This is done by:
1. **Pushing updates** (e.g., new playbooks, roles, or configurations) to a **GitHub repository**.
2. **Pulling updates** on other machines to ensure that they all operate with the same Ansible configurations.
3. **Committing changes** to maintain a detailed record of all modifications, enabling easy rollback or tracking of infrastructure changes.

This ensures that all team members and machines running **Ansible** are working with the latest and consistent set of configurations stored in a central repository.

#### Why This Workflow Matters

- **Centralized management**: All your Ansible playbooks and configurations are stored centrally in a GitHub repository.
- **Consistency**: Every machine or person using the playbooks will have the same version, reducing errors due to outdated configurations.
- **Traceability**: Git’s version control enables you to trace changes, resolve conflicts, and revert to earlier versions if necessary.
- **Foundation for automation**: This push-pull workflow is the stepping stone toward more sophisticated automation techniques, like using **GitHub Actions** to trigger deployments.

---

### Transition to Automation with GitHub Actions

As we shift from manual push-pull updates to **automated deployments**, GitHub offers an additional layer of functionality: **GitHub Actions**. This allows you to trigger specific workflows in response to events in your repository, such as:
- **Pushes to the repository**.
- **Merges or pull requests**.
- **Scheduled events** (e.g., daily or weekly tasks).

In the next stage of our infrastructure management process, we will leverage GitHub Actions to automate what is currently a manual process. This means you won’t need to manually push changes and pull them onto each machine. Instead, **event-driven workflows** will automatically trigger deployments when specific conditions are met.

---

### Preparing for Event-Driven Deployments

In future chapters, we will integrate **GitHub Actions** and **Ansible** to create **event-driven deployments**. Here’s what this will look like:

#### 1. Automating Deployment Triggers

Instead of manually pulling changes or running playbooks across machines, you can configure **GitHub Actions** to run specific **Ansible playbooks** when changes are made to your repository. This means:
- **Pushing a new playbook** to the repository will automatically trigger a workflow to deploy the changes to your infrastructure.
- You can schedule **automated tasks** that run at predefined times (e.g., nightly infrastructure updates).
- **Pull requests** can trigger workflows to validate changes in a staging environment before they are deployed to production.

#### 2. Building a CI/CD Pipeline with Ansible

In the near future, you will set up a **CI/CD pipeline** that automatically deploys infrastructure changes. This pipeline will:
- **Test and validate** Ansible playbooks when new changes are pushed.
- **Deploy** validated changes to the infrastructure.
- **Roll back** automatically if there are errors during deployment.

An example GitHub workflow to trigger a deployment could look like this:

```yaml
name: Deploy Infrastructure

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Check out repository
      uses: actions/checkout@v2

    - name: Set up Python and Ansible
      uses: actions/setup-python@v2
      with:
        python-version: '3.x'

    - name: Install Ansible
      run: |
        pip install ansible

    - name: Run Ansible Playbook
      run: ansible-playbook playbooks/deploy.yml -i inventory/hosts
```

#### 3. Docker and Docker Compose for Future Environments

As we progress, the **Docker and Docker Compose** ecosystem will take over the management of your environment. Instead of relying on manual configuration or local machine dependencies, you’ll build Docker images that package your **Ansible configurations** and **playbooks**.

With Docker:
- You will **containerize** your entire Ansible environment, making it portable and consistent across all systems.
- **Docker Compose** will help manage multi-container setups, where different containers represent different infrastructure components (e.g., application servers, databases).
- **GitHub Actions** will help trigger builds, run tests, and deploy these containers to your environment automatically.

---

### Moving Toward Continuous Deployment

In future chapters, we will move from **manual updates** to fully **automated event-driven deployments** using Ansible and GitHub. This will involve:
- **Continuous Deployment (CD)**: Automatically pushing changes from the repository to the live infrastructure when certain conditions are met.
- **Infrastructure Testing**: Implementing tests to validate your playbooks and configurations before they are deployed.
- **Rollback Mechanisms**: Automatically reverting to previous configurations if a deployment fails, ensuring that your infrastructure remains stable.

By leveraging GitHub Actions, Ansible, and Docker, you will create a robust, **automated pipeline** that:
- **Deploys infrastructure automatically** based on events like pushes, merges, or scheduled times.
- **Monitors and tests deployments** to ensure stability.
- **Scales** easily using Docker and Docker Compose for managing multiple containers and services.

---

### Conclusion

In this appendix, we have clarified the role of the **push-pull workflow** for managing infrastructure through **version control** and **synchronization** using GitHub, while introducing the future potential of **GitHub Actions** for automating **event-driven deployments** with Ansible. As we shift toward fully automated infrastructure management, you’ll be prepared to implement **GitHub workflows** that trigger **Ansible playbooks** automatically, deploy infrastructure changes seamlessly, and integrate Docker for scalable, containerized environments.

---

**End of Chapter and Appendix**
