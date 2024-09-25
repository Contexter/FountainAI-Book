#!/bin/bash

# Function to check GitHub CLI authentication
check_gh_auth() {
    if ! gh auth status > /dev/null 2>&1; then
        echo "Error: You are not authenticated with GitHub CLI (gh). Please run 'gh auth login' to authenticate."
        exit 1
    else
        echo "GitHub authentication confirmed."
    fi
}

# Function to get the authenticated GitHub user
get_github_user() {
    gh_user=$(gh api user --jq '.login')
    if [ -z "$gh_user" ]; then
        echo "Error: Unable to retrieve authenticated GitHub user."
        exit 1
    fi
    echo "$gh_user"
}

# Function to handle an existing repository
handle_existing_repo() {
    local repo_name="$1"
    local github_user="$2"

    if gh repo view "$github_user/$repo_name" > /dev/null 2>&1; then
        echo "Warning: The repository $github_user/$repo_name already exists."
        echo "Options:"
        echo "1. Delete the existing repository and start fresh."
        echo "2. Backup the repository before creating a new one."
        echo "3. Cancel the operation."
        read -p "Choose an option (1/2/3): " choice

        case $choice in
            1)
                delete_repo "$repo_name" "$github_user"
                ;;
            2)
                backup_and_delete_repo "$repo_name" "$github_user"
                ;;
            3)
                echo "Operation canceled."
                exit 0
                ;;
            *)
                echo "Invalid option. Operation canceled."
                exit 1
                ;;
        esac
    else
        echo "Repository $github_user/$repo_name does not exist. Proceeding to create a new one."
    fi
}

# Function to delete the existing repository
delete_repo() {
    local repo_name="$1"
    local github_user="$2"
    
    echo "Deleting repository $github_user/$repo_name..."
    gh repo delete "$github_user/$repo_name" --yes
}

# Function to backup the existing repository and then delete it
backup_and_delete_repo() {
    local repo_name="$1"
    local github_user="$2"
    local backup_repo_name="${repo_name}-backup-$(date +%Y-%m-%d-%H-%M-%S)"
    local temp_dir="${repo_name}_temp"

    echo "Creating backup repository $github_user/$backup_repo_name..."
    gh repo create "$github_user/$backup_repo_name" --public --confirm

    echo "Cloning existing repository into a temporary directory..."
    
    # Ensure the temp directory doesn't exist
    if [ -d "$temp_dir" ]; then
        rm -rf "$temp_dir"
    fi

    # Clone the repository using gh into the temp directory
    gh repo clone "$github_user/$repo_name" "$temp_dir"
    cd "$temp_dir" || exit 1

    echo "Pushing existing content to backup repository using gh..."
    
    # Push content to the backup repository with gh
    gh repo sync "$github_user/$backup_repo_name"

    cd ..
    rm -rf "$temp_dir"

    echo "Backup created successfully. Deleting the original repository..."
    delete_repo "$repo_name" "$github_user"
}

# Function to create the new repository under the authenticated user account
create_repo() {
    local repo_name="$1"
    local github_user="$2"

    echo "Creating GitHub repository $github_user/$repo_name..."
    if gh repo create "$github_user/$repo_name" --public --confirm; then
        echo "Repository $github_user/$repo_name created successfully."
    else
        echo "Error: Failed to create repository $github_user/$repo_name."
        exit 1
    fi
}

# Clone the newly created repository
clone_repo() {
    local repo_name="$1"
    local github_user="$2"
    local base_dir="$repo_name"

    echo "Cloning the repository $github_user/$repo_name..."
    
    # If the base directory exists, delete it
    if [ -d "$base_dir" ]; then
        rm -rf "$base_dir"
    fi

    # Clone the repository into the base directory
    if gh repo clone "$github_user/$repo_name" "$base_dir"; then
        cd "$base_dir" || exit 1
    else
        echo "Error: Failed to clone the repository $github_user/$repo_name."
        exit 1
    fi
}

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
        ["configure_kong.sh"]="#!/bin/bash\n\n# Ensure Kong configuration is only created if it doesn't exist\ncreate_kong_config() {\n    local config_file=\"/etc/kong/kong.yml\"\n\n    if [ ! -f \"$config_file\" ]; then\n        echo \"Creating Kong configuration.\"\n        cat <<EOL > \"$config_file\"\n_format_version: \"3.0\"\nservices:\n  - name: api_service\n    url: http://backend-service\n    routes:\n      - name: api_route\n        paths:\n          - /api\nEOL\n    else\n        echo \"Kong configuration already exists.\"\n    fi\n}\n\ncreate_kong_config"
        ["configure_opensearch.sh"]="#!/bin/bash\n\n# Ensure OpenSearch configuration is only created if it doesn't exist\ncreate_opensearch_config() {\n    local config_file=\"/etc/opensearch/opensearch.yml\"\n\n    if [ ! -f \"$config_file\" ]; then\n        echo \"Creating OpenSearch configuration.\"\n        cat <<EOL > \"$config_file\"\n# OpenSearch configuration\nEOL\n    else\n        echo \"OpenSearch configuration already exists.\"\n    fi\n}\n\ncreate_opensearch_config"
        ["configure_docker.sh"]="#!/bin/bash\n\n# Ensure Docker configuration is only created if it doesn't exist\ncreate_docker_config() {\n    local config_file=\"./docker-compose.yml\"\n\n    if [ ! -f \"$config_file\" ]; then\n        echo \"Creating Docker Compose configuration.\"\n        cat <<EOL > \"$config_file\"\nversion: '3'\nservices:\n  app:\n    image: your-app-image\n    ports:\n      - \"8000:8000\"\nEOL\n    else\n        echo \"Docker Compose configuration already exists.\"\n    fi\n}\n\ncreate_docker_config"
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

# Create a .gitignore file
create_gitignore() {
    local base_dir="$1"
    local gitignore_file="$base_dir/.gitignore"

    if [ ! -f "$gitignore_file" ]; then
        cat <<EOL > "$gitignore_file"
# Ignore sensitive files
.env
*.secret
*.key

# Ignore generated files
*.log
*.bak
*.backup
EOL
        echo ".gitignore file created."
    else
        echo ".gitignore file already exists."
    fi
}

# Download the paper as README.md and place it in the repo
create_readme() {
    local base_dir="$1"
    local readme_file="$base_dir/README.md"

    # Use the content of the fetched paper as the README
    curl -o "$readme_file" https://raw.githubusercontent.com/Contexter/FountainAI-Book/main/chapters/Paper_%20A%20Manual-First%20Approach%20to%20Infrastructure%20Configuration%20Management%20with%20AWS%20Lightsail,%20Kong,%20Docker,%20and%20OpenSearch.md
    echo "README.md created from the paper."
}

# Function to commit and push changes using gh
sync_changes() {
    local base_dir="$1"

    cd "$base_dir" || exit 1

    echo "Staging all files and committing changes..."
    gh repo sync --force
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
    create_gitignore "$repo_dir"
    create_readme "$repo_dir"
    echo "Repository setup completed according to the FountainAI way."
}

# Main process
main() {
    local repo_name="fountainai-setup"

    # Step 1: Check if the user is authenticated with GitHub
    check_gh_auth

    # Step 2: Get the authenticated GitHub user
    local github_user
    github_user=$(get_github_user)

    # Step 3: Handle existing repository (delete, backup, or cancel)
    handle_existing_repo "$repo_name" "$github_user"

    # Step 4: Create the new repository using GitHub CLI
    create_repo "$repo_name" "$github_user"

    # Step 5: Clone the repository
    clone_repo "$repo_name" "$github_user"

    # Step 6: Initialize the repository structure
    initialize_repository "$(pwd)"

    # Step 7: Set the default remote repository for future gh commands
    echo "Setting the default remote repository..."
    gh repo set-default "$github_user/$repo_name"

    # Step 8: Sync changes using gh
    echo "Committing and pushing changes using gh..."
    sync_changes "$(pwd)"
}

# Execute the main process
main
