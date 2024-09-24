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
