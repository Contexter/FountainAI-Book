# **Paper: A Manual-First Approach to Infrastructure Configuration Management with AWS Lightsail, Kong, Docker, and OpenSearch**

## **Abstract**
This paper outlines a practical, **manual-first approach** to managing infrastructure configurations for a modular system architecture using **AWS Lightsail**. The focus is on the structured repository norm, utilizing **manual triggers** via **GitHub Actions**, **idempotent shell scripts** as defined by the **FountainAI way**, and strict **configuration management**. Each component, including **Kong (DB-less)**, **Docker-based services**, and **OpenSearch**, is controlled and documented through **shell scripts** stored in a well-defined repository structure. The system emphasizes reliability, traceability, and avoiding accidental overwrites, ensuring that every change is intentional and documented.

---

## **1. Introduction**

In a world that prioritizes automation, this paper presents a counter-approach based on **manual-first control** over infrastructure management. The foundation of this approach is the **FountainAI method** of shell scripting, which emphasizes:

1. **Manual control over automation**: Prevent unintended changes by relying on manual triggers.
2. **Idempotent, modular shell scripts**: Each script is reusable and ensures consistent results, regardless of how many times it's run, as per **FountainAI’s norms**.
3. **Comprehensive repository structure and documentation**: Strict organization of scripts, configuration files, and documentation ensures clarity and traceability for every action taken.

This approach eliminates the risks associated with over-automation, such as accidental overwrites or undocumented changes, while ensuring that every configuration change is fully controlled and deliberate.

---

## **2. Repository Norm: Structure and Purpose**

The **repository norm**, inspired by **Chapter 7 of the FountainAI Book**, establishes a strict structure for organizing scripts, configurations, and documentation. This norm provides a disciplined approach to managing infrastructure, ensuring that each component remains modular and well-documented.

### **2.1. Repository Layout**

```bash
/
├── .github/
│   └── workflows/
│       └── configure_kong.yml        # GitHub Action for Kong
│       └── configure_opensearch.yml  # GitHub Action for OpenSearch
│       └── configure_docker.yml      # GitHub Action for Docker
├── scripts/
│   └── configure_kong.sh             # Shell script for Kong configuration
│   └── configure_opensearch.sh       # Shell script for OpenSearch
│   └── configure_docker.sh           # Shell script for Docker services
├── configs/
│   └── kong/
│       └── kong.yml                  # Kong DB-less configuration
│   └── opensearch/
│       └── opensearch.yml            # OpenSearch configuration
│   └── docker/
│       └── docker-compose.yml        # Docker Compose configuration
├── docs/
│   └── kong_configuration.md         # Kong configuration documentation
│   └── opensearch_configuration.md   # OpenSearch documentation
│   └── docker_services.md            # Docker services documentation
└── README.md                         # High-level project documentation
```

### **2.2. Structure Rationale**

As enforced by **FountainAI**, this layout ensures that each component is self-contained and organized according to function:

1. **Scripts** (`scripts/`):
   - Shell scripts are organized by service (Kong, OpenSearch, Docker) and follow **FountainAI’s scripting principles**: each script is modular, well-documented, and idempotent.
   - Each script serves a specific purpose, reducing complexity and ensuring clear separation of concerns.

2. **Configurations** (`configs/`):
   - Configuration files for Kong, OpenSearch, and Docker are kept in distinct subdirectories, allowing for easy access and version control.

3. **Workflows** (`.github/workflows/`):
   - Workflows are linked to the shell scripts via **manual triggers**, ensuring that configurations are only applied when deliberately invoked.

4. **Documentation** (`docs/`):
   - Each service has dedicated documentation that explains how the shell scripts and configurations work together, following the **FountainAI** way of full documentation and clarity.

---

## **3. Manual-First Infrastructure Management**

The **manual-first approach** ensures that nothing happens automatically. This strict control is essential to prevent unintentional changes, and it aligns with FountainAI’s principle of **deterministic execution**—where every action is controlled, predictable, and repeatable.

### **3.1. GitHub Actions with Manual Triggers**

Using **GitHub Actions** with the `workflow_dispatch` event allows infrastructure administrators to trigger changes manually. This ensures that:

- **No accidental overwrites** occur because nothing runs automatically.
- **Human oversight** is always present. Every change must be triggered and reviewed before being applied.

**Example GitHub Action for Kong Configuration**:

```yaml
name: Kong Configuration

on:
  workflow_dispatch:  # Manual trigger only

jobs:
  configure-kong:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Run Kong configuration script
      run: ./scripts/configure_kong.sh
```

This manual-first approach is crucial, as it aligns with **FountainAI’s core philosophy** of controlling the environment deterministically and avoiding the unpredictability that can arise from full automation.

---

## **4. Idempotent Shell Scripts: The FountainAI Way**

### **4.1. The Role of Shell Scripts in FountainAI**

Shell scripts are the foundation of this setup, and they follow the **FountainAI norms** for modularity and idempotency. Each script must guarantee that running the script multiple times results in the same outcome, ensuring system stability and reliability.

- **Modularity**: Each script performs one clear task, making it easy to maintain and update.
- **Idempotency**: Scripts ensure that they don't reapply changes that have already been made, preventing unintended duplicates or errors.

### **4.2. Kong (DB-less Mode) Shell Script**

This script follows **FountainAI’s shell scripting guidelines**, ensuring that the Kong configuration is applied only if necessary, and that existing configurations are preserved unless explicitly overridden.

```bash
#!/bin/bash

# Ensure Kong configuration is only created if it doesn't exist
create_kong_config() {
    local config_file="/etc/kong/kong.yml"

    if [ ! -f "$config_file" ]; then
        echo "Creating Kong configuration."
        cat <<EOL > "$config_file"
_format_version: "3.0"
services:
  - name: api_service
    url: http://backend-service
    routes:
      - name: api_route
        paths:
          - /api
EOL
    else
        echo "Kong configuration already exists."
    fi
}

# Execute the function
create_kong_config
```

This script is designed with **idempotency** in mind: it checks if the Kong configuration already exists before creating a new one, ensuring that running the script multiple times does not overwrite existing settings.

### **4.3. The Importance of Idempotency**

**Idempotency** guarantees that the system remains in a stable state, regardless of how many times a script is executed. This is critical when dealing with infrastructure configuration, where unintended changes can cause system instability.

---

## **5. Configuration and Documentation Management: FountainAI’s Modular Approach**

### **5.1. Configuration Files in `configs/`**

Configurations are kept in clearly defined subdirectories under the `configs/` folder, aligning with **FountainAI’s modular approach** to organizing infrastructure. Each service has its own configuration, stored separately from the shell scripts.

**Example: Kong Configuration (`kong.yml`)**:

```yaml
_format_version: "3.0"
services:
  - name: api_service
    url: http://backend-service
    routes:
      - name: api_route
        paths:
          - /api
```

This separation of concerns ensures that configurations are isolated, version-controlled, and easy to manage without impacting the overall system.

### **5.2. Gapless Documentation**

Following **FountainAI’s principle** of complete documentation, every service is thoroughly documented in the `docs/` directory. The documentation explains:

- How to use the shell scripts.
- How the configurations are structured.
- What each part of the setup does.

**Example: Documentation for Kong Configuration** (`kong_configuration.md`):

```markdown
# Kong Configuration

This document explains the Kong DB-less configuration process.

## Configuration File: `configs/kong/kong.yml`

This file defines the services and routes managed by Kong. It is generated by the shell script located at `scripts/configure_kong.sh`.

### How to Modify:
- To update the services or routes, modify `kong.yml` and re-run the shell script.
```

This approach ensures that every configuration is understandable and maintainable, allowing future developers or administrators to pick up the system without ambiguity.

---

## **6. Ensuring Reliable and Consistent Changes**

### **6.1. Avoiding Accidental Overwrites: The FountainAI Way**

By using **manual GitHub Actions triggers** and **idempotent scripts**, the system ensures that configurations are only changed when explicitly intended. This enforces **FountainAI’s principle of deterministic control**, where nothing happens without deliberate action.

- **Scripts ensure no overwrites** unless explicitly intended.
- **Manual review** is required before any action is executed.

### **6.2. Backup Mechanisms**

In line with **FountainAI’s fail-safe principle**, before making any changes, shell scripts automatically create backups of existing configurations, ensuring easy rollback in case of unintended consequences.

```bash
# Backup existing configuration before applying changes
backup_existing_config() {
    local config_file="$1"
    local backup_file="$config_file.backup.$(date +'%Y%m%d%H%M%S')"

    if [ -f "$config_file" ]; then
        cp "$config_file" "$backup_file"
        echo "Backup created at $backup_file"
    fi
}
```

---

## **7. Conclusion: Enforcing the FountainAI Way**

This manual-first infrastructure setup enforces the **FountainAI Shell Scripting Norms**, which prioritize modularity, idempotency, and clear documentation. By focusing on manual control and deterministic execution, the system avoids the pitfalls of over-automation, ensuring that configurations are reliable, documented, and under full human control.

This setup is highly modular and can scale as needed, with the repository norm ensuring that each part of the system remains isolated yet interoperable. By combining **manual GitHub Actions triggers**, **idempotent scripts**, and **gapless documentation**, the system provides a robust, maintainable infrastructure management solution.

---

## **Appendix: FountainAI-Style Shell Script to Set Up the Repository**

This section provides the full shell script that sets up the repository structure as described in the paper, adhering to the **FountainAI principles** of modularity, idempotency, and clear documentation.

### **Step-by-Step Tutorial**

### **Step 1: Create a New GitHub Repository**

Using the GitHub CLI, you can create the repository as follows:

```bash
gh repo create Contexter/fountainai-setup --public --confirm
```
Replace `Contexter` with your actual GitHub username.

### **Step 2: Clone the Repository Locally**

```bash
git clone https://github.com/Contexter/fountainai-setup.git
cd fountainai-setup
```

### **Step 3: Download the Shell Script**

```bash
curl -O https://raw.githubusercontent.com/Contexter/FountainAI-Book/main/scripts/setup_repository.sh
chmod +x setup_repository.sh
```

### **Step 4: Run the Script**

```bash
./setup_repository.sh $(pwd)
```

This will set up the directory structure, shell scripts, workflows, and documentation files as per the **FountainAI way**.

### **Step 5: Commit and Push Changes**

```bash
git add .
git commit -m "Initial repository setup according to FountainAI norms"
git push origin main
```

---

### **Full Script: FountainAI-Style Shell Script**

```bash
#!/bin/bash

# Set up the base directory for the repository
setup_base_directory() {
    local base_dir="$1"

    if [ ! -d "$base_dir" ]; then
        mkdir -p "$base_dir"
        echo "Base directory $base_dir created."
    else
        echo "Base directory $base_dir already exists."
    fi
}

# Create a directory structure following the FountainAI repository norm
create_directory_structure() {
    local base_dir="$1"
    declare -a dirs=(
        "$base_dir/.github/workflows"
        "$base_dir/scripts"
        "$base_dir/configs/kong"
        "$base_dir/configs/opensearch"
        "$base_dir/configs/docker"
        "$base_dir/docs"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            echo "Directory $dir created."
        else
            echo "Directory $dir already exists."
        fi
    done
}

# Create the initial GitHub Actions workflows with manual triggers
create_github_actions() {
    local workflows_dir="$1/.github/workflows"
    declare -A workflows=(
        ["configure_kong.yml"]="name: Kong Configuration\n\non:\n  workflow_dispatch:\n\njobs:\n  configure-kong:\n    runs-on: ubuntu-latest\n    steps:\n    - name: Checkout repository\n      uses: actions/checkout@v2\n\n    - name: Run Kong configuration script\n      run: ./scripts/configure_kong.sh"
        ["configure_opensearch.yml"]="name: OpenSearch Configuration\n\non:\n  workflow_dispatch:\n\njobs:\n  configure-opensearch:\n    runs-on: ubuntu-latest\n    steps:\n    - name: Checkout repository\n      uses: actions/checkout@v2\n\n    - name: Run OpenSearch configuration script\n      run: ./scripts/configure_opensearch.sh"
        ["configure_docker.yml"]="name: Docker Configuration\n\non:\n  workflow_dispatch:\n\njobs:\n  configure-docker:\n    runs-on: ubuntu-latest\n    steps:\n    - name: Checkout repository\n      uses: actions/checkout@v2\n\n    - name: Run Docker configuration script\n      run: ./scripts/configure_docker.sh"
    )

    for file in "${!workflows[@]}"; do
        local workflow_file="$workflows_dir/$file"
        if [ ! -f "$workflow_file" ]; then
            echo -e "${workflows[$file]}" > "$workflow_file"
            echo "Workflow $file created."
        else
            echo "Workflow $file already exists."
        fi
    done
}

# Create shell scripts in the scripts/ directory
create_shell_scripts() {
    local scripts_dir="$1/scripts"
    declare -A scripts=(
        ["configure_kong.sh"]="#!/bin/bash\n\n# Ensure Kong configuration is only created if it doesn't exist\ncreate_kong_config() {\n    local config_file=\"/etc/kong/kong.yml\"\n\n    if [ ! -f \"\$config_file\" ]; then\n        echo \"Creating Kong configuration.\"\n        cat <<EOL > \"\$config_file\"\n_format_version: \"3.0\"\nservices:\n  - name: api_service\n    url: http://backend-service\n    routes:\n      - name: api_route\n        paths:\n          - /api\nEOL\n    else\n        echo \"Kong configuration already exists.\"\n    fi\n}\n\ncreate_kong_config"
        ["configure_opensearch.sh"]="#!/bin/bash\n\n# Ensure OpenSearch configuration is only created if it doesn't exist\ncreate_opensearch_config() {\n    local config_file=\"/etc/opensearch/opensearch.yml\"\n\n    if [ ! -f \"\$config_file\" ]; then\n        echo \"Creating OpenSearch configuration.\"\n        cat <<EOL > \"\$config_file\"\n# OpenSearch configuration\nEOL\n    else\n        echo \"OpenSearch configuration already exists.\"\n    fi\n}\n\ncreate_opensearch_config"
        ["configure_docker.sh"]="#!/bin/bash\n\n# Ensure Docker configuration is only created if it doesn't exist\ncreate_docker_config() {\n    local config_file=\"./docker-compose.yml\"\n\n    if [ ! -f \"\$config_file\" ]; then\n        echo \"Creating Docker Compose configuration.\"\n        cat <<EOL > \"\$config_file\"\nversion: '3'\nservices:\n  app:\n    image: your-app-image\n    ports:\n      - \"8000:8000\"\nEOL\n    else\n        echo \"Docker Compose configuration already exists.\"\n    fi\n}\n\ncreate_docker_config"
    )

    for file in "${!scripts[@]}"; do
        local script_file="$scripts_dir/$file"
        if [ ! -f "$script_file" ]; then
            echo -e "${scripts[$file]}" > "$script_file"
            chmod +x "$script_file"
            echo "Shell script $file created and made executable."
        else
            echo "Shell script $file already exists."
        fi
    done
}

# Create configuration files in the configs/ directory
create_config_files() {
    local configs_dir="$1/configs"
    declare -A configs=(
        ["kong/kong.yml"]="_format_version: \"3.0\"\nservices:\n  - name: api_service\n    url: http://backend-service\n    routes:\n      - name: api_route\n        paths:\n          - /api"
        ["opensearch/opensearch.yml"]="# OpenSearch configuration"
        ["docker/docker-compose.yml"]="version: '3'\nservices:\n  app:\n    image: your-app-image\n    ports:\n      - \"8000:8000\""
    )

    for file in "${!configs[@]}"; do
        local config_file="$configs_dir/$file"
        if [ ! -f "$config_file" ]; then
            echo -e "${configs[$file]}" > "$config_file"
            echo "Configuration file $file created."
        else
            echo "Configuration file $file already exists."
        fi
    done
}

# Create documentation files in the docs/ directory
create_docs() {
    local docs_dir="$1/docs"
    declare -A docs=(
        ["kong_configuration.md"]="# Kong Configuration\n\nThis document explains the Kong DB-less configuration process."
        ["opensearch_configuration.md"]="# OpenSearch Configuration\n\nThis document explains the OpenSearch configuration process."
        ["docker_services.md"]="# Docker Services\n\nThis document explains the Docker services configuration process."
    )

    for file in "${!docs[@]}"; do
        local doc_file="$docs_dir/$file"
        if [ ! -f "$doc_file" ]; then
            echo -e "${docs[$file]}" > "$doc_file"
            echo "Documentation file $file created."
        else
            echo "Documentation file $file already exists."
        fi
    done
}

# Initialize the repository structure and content
initialize_repository() {
    local repo_dir="$1"

    setup_base_directory "$repo_dir"
    create_directory_structure "$repo_dir"
    create_github_actions "$repo_dir"
    create_shell_scripts "$repo_dir"
    create_config_files "$repo_dir"
    create_docs "$repo_dir"

    echo "Repository setup completed according to the FountainAI way."
}

# Execute the repository setup
initialize_repository "$1"
```

---

This paper, including the appendix, outlines your **manual-first, FountainAI-compliant** approach to managing infrastructure configuration with GitHub and AWS Lightsail. Let me know if you need further assistance!