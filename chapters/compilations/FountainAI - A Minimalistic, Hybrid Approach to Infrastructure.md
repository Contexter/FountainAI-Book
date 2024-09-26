# A Minimalistic, Hybrid Approach to Infrastructure
> providing a cost-effective, manually controlled, and scalable infrastructure management solution for 
## FountainAI 
> a Scalable, AI-Driven Storytelling Platform
___


## **Abstract**

This paper outlines a minimalistic, single-user infrastructure for FountainAI, designed to be affordable while providing full manual control over deployment, scaling, and service management. The infrastructure leverages **AWS Lightsail** to host OpenSearch, Kong (DB-less), and Dockerized applications, controlled via a **FastAPI-based API**. The setup follows a **manual-first control philosophy**, where users manage the infrastructure through API calls rather than fully automated pipelines. A hybrid approach is applied by integrating **GitHub Actions** to automate the building, testing, and pushing of Docker images to **GitHub Container Registry (GHCR)**, while deployments are handled manually via the FastAPI app. This solution ensures cost efficiency, flexibility, and full control over the deployment process.

---

## **1. Introduction**

The project aims to deliver a scalable, minimalistic infrastructure for FountainAI, tailored for a **single-user environment**. The infrastructure will support **OpenSearch** for search and analytics, **Kong** as an API Gateway (DB-less mode), and a separate **Docker-based instance** to host any Dockerized apps, including the FastAPI app itself.

Key principles:
- **Manual-first control**: All deployment and management are initiated manually via an API, giving the user full control over each step.
- **Minimal cost**: By using AWS Lightsail nano instances, infrastructure costs are kept at a minimum, ideal for a single-user setup.
- **Hybrid workflow**: While deployment and infrastructure management are manual, **GitHub Actions** automate the testing, building, and publishing of Docker images to **GHCR**.

---

## **2. Infrastructure Components**

### **2.1 AWS Lightsail Instances**

The infrastructure is built on three AWS Lightsail nano instances, one for each of the main services:

1. **OpenSearch Instance**:
   - Hosts the OpenSearch search and analytics engine.
   - Provides data storage and querying capabilities.
   
2. **Kong Gateway Instance**:
   - Hosts **Kong Gateway** in DB-less mode.
   - Serves as an API Gateway to route traffic securely across the infrastructure.
   
3. **Dockerized Applications Instance**:
   - Hosts Docker and runs any Dockerized services or apps, such as the FastAPI app itself.

### **2.2 FastAPI Application**

The FastAPI app is responsible for controlling and managing the infrastructure. This includes:
- Creating and managing AWS Lightsail instances.
- Deploying and configuring services like OpenSearch and Kong.
- Managing Docker containers and GitHub secrets.

The app interacts with the Lightsail instances via **boto3** for AWS operations and **paramiko** for remote SSH management.

### **2.3 GitHub Actions for CI/CD**

**GitHub Actions** is used for automating:
- Building Docker images for your applications or services.
- Running tests to ensure code integrity before deployment.
- Pushing Docker images to **GitHub Container Registry (GHCR)**.

Once the images are ready, deployment is triggered manually through the FastAPI app.

---

## **3. Project Workflow**

### **3.1 Step-by-Step Infrastructure Deployment**

#### **Step 1: Create AWS Lightsail Instances**

The FastAPI app allows users to create Lightsail instances for OpenSearch, Kong, and Dockerized apps. These instances are created using the FastAPI endpoint `/aws/lightsail/create-instance`, which interacts with AWS via **boto3**.

Example FastAPI call to create an instance:
```bash
curl -X POST "http://localhost:8000/aws/lightsail/create-instance" \
-H "Content-Type: application/json" \
-d '{
      "instance_name": "opensearch-instance",
      "blueprint_id": "ubuntu_20_04",
      "bundle_id": "nano_2_0",
      "region": "eu-central-1",
      "availability_zone": "eu-central-1a"
    }'
```

#### **Step 2: Deploy OpenSearch on the OpenSearch Instance**

Once the instance is created, **OpenSearch** is deployed using the FastAPI `/services/deploy-opensearch` endpoint. The service is installed via SSH, and its configuration is managed by the API.

Example FastAPI call to deploy OpenSearch:
```bash
curl -X POST "http://localhost:8000/services/deploy-opensearch" \
-H "Content-Type: application/json" \
-d '{
      "instance_ip": "1.2.3.4",
      "ssh_key_path": "/path/to/ssh_key"
    }'
```

#### **Step 3: Deploy Kong Gateway on the Kong Instance**

Similarly, **Kong Gateway** (in DB-less mode) is deployed on a separate instance via the `/services/deploy-kong` FastAPI endpoint. Kong routes and configuration files are managed directly on the instance via SSH.

Example FastAPI call to deploy Kong:
```bash
curl -X POST "http://localhost:8000/services/deploy-kong" \
-H "Content-Type: application/json" \
-d '{
      "instance_ip": "5.6.7.8",
      "ssh_key_path": "/path/to/ssh_key"
    }'
```

#### **Step 4: Deploy Dockerized Applications**

Once the Docker instance is created, users can deploy **Dockerized apps** by pulling Docker images from **GHCR** and running them on the instance. The FastAPI endpoint `/services/deploy-docker-app` handles the Docker container deployment.

Example FastAPI call to deploy a Dockerized app:
```bash
curl -X POST "http://localhost:8000/services/deploy-docker-app" \
-H "Content-Type: application/json" \
-d '{
      "instance_ip": "9.10.11.12",
      "docker_image": "ghcr.io/user/repo/my-app:latest",
      "ssh_key_path": "/path/to/ssh_key"
    }'
```

---

### **3.2 GitHub Actions Workflow for Docker**

To automate Docker image builds, **GitHub Actions** are used for:
- Building Docker images.
- Running unit tests.
- Pushing Docker images to **GHCR**.

Example GitHub Actions Workflow (`.github/workflows/docker-ci.yml`):
```yaml
name: Docker CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build Docker Image
        run: |
          docker build -t ghcr.io/${{ github.repository }}/my-app:latest .
      
      - name: Push Docker Image to GHCR
        run: |
          docker push ghcr.io/${{ github.repository }}/my-app:latest
      
      - name: Run Unit Tests
        run: |
          docker run --rm ghcr.io/${{ github.repository }}/my-app:latest pytest
```

This workflow builds, tests, and pushes Docker images to **GHCR**, ensuring all images are properly tested before deployment.

---

## **4. FastAPI Routes Overview**

### **4.1 AWS Lightsail Management Routes**

1. **Create Instance**:
   - **Method**: `POST`
   - **Route**: `/aws/lightsail/create-instance`
   - **Description**: Create a Lightsail instance.
   - **Parameters**:
     - `instance_name`, `blueprint_id`, `bundle_id`, `region`, `availability_zone`.

2. **Start/Stop/Delete Instance**:
   - Manage instances (e.g., start, stop, delete) using respective API endpoints.

### **4.2 Service Deployment Routes**

1. **Deploy OpenSearch**:
   - **Method**: `POST`
   - **Route**: `/services/deploy-opensearch`
   - **Description**: Deploy OpenSearch on a Lightsail instance.
   - **Parameters**: 
     - `instance_ip`, `ssh_key_path`.

2. **Deploy Kong Gateway**:
   - **Method**: `POST`
   - **Route**: `/services/deploy-kong`
   - **Description**: Deploy Kong Gateway on a Lightsail instance.
   - **Parameters**: 
     - `instance_ip`, `ssh_key_path`.

3. **Deploy Docker App**:
   - **Method**: `POST`
   - **Route**: `/services/deploy-docker-app`
   - **Description**: Deploy a Docker container on a Lightsail instance.
   - **Parameters**: 
     - `instance_ip`, `docker_image`, `ssh_key_path`.

---

## **5. Benefits of the Minimalistic, Hybrid Approach**

### **5.1 Manual Control and Flexibility**

- **Manual API Control**: By removing automated infrastructure pipelines, the user has full manual control over the environment, avoiding unintended deployments or configuration changes.
  
- **Low-Cost and Lightweight**: AWS Lightsail nano instances keep costs minimal, ensuring the infrastructure is affordable for a single user.

- **Hybrid Automation**: While infrastructure is manually controlled via API, GitHub Actions handles Docker image building and testing, ensuring reliability before deployment.

---

## **6. Conclusion**

This minimalistic, hybrid approach combines the best of both worlds:  **manual-first control** for infrastructure deployment and configuration, with **automated CI/CD** for building, testing, and pushing Dockerized applications. The use of **FastAPI** ensures flexibility and easy integration with existing systems, while **GitHub Actions** automates the more tedious tasks of testing and containerization. The result is an **affordable**, **scalable**, and **user-controlled** environment perfect for single-user setups like **FountainAI**.

---

# **Part II: Building the FastAPI Application the FountainAI Way**

## **1. Philosophy of the FountainAI Way in FastAPI**

The FountainAI way emphasizes **manual-first control**, **modularity**, **idempotency**, and **documentation**. Applying this to a **FastAPI app** means that every aspect of the application is:

1. **Manually triggered**: No automated actions happen without explicit user consent, keeping full control in the hands of the user.
2. **Modular**: Each function, service, or route has a single responsibility and is self-contained, making the system easier to extend and debug.
3. **Idempotent**: Every action is idempotent, meaning repeated execution of the same function will result in the same effect, ensuring stability and reliability.
4. **Fully documented**: Every service and route is accompanied by clear, concise documentation, explaining its purpose, input parameters, and output.

---

## **2. FastAPI Structure**

Following the **FountainAI norms**, the **FastAPI app** will have a clear and modular directory structure. Each route and service will be divided based on responsibility, ensuring separation of concerns and ease of maintenance.

### **2.1 Directory Layout**

```
/fountainai-infrastructure-api/
├── app/
│   ├── main.py                    # FastAPI app creation and route loading
│   ├── api/                       # API routes for infrastructure management
│   │   ├── lightsail/              # Lightsail routes (create, start, stop, delete instances)
│   │   ├── services/               # Routes for managing OpenSearch, Kong, Docker
│   ├── services/                  # Business logic for AWS, GitHub, and SSH management
│   │   ├── lightsail_service.py    # Logic for AWS Lightsail operations
│   │   ├── github_service.py       # Logic for GitHub secrets management
│   │   ├── opensearch_service.py   # Logic for deploying and managing OpenSearch
│   │   ├── kong_service.py         # Logic for deploying and managing Kong
│   │   ├── docker_service.py       # Logic for Dockerized apps management
│   ├── utils/                     # Utility functions (logging, error handling)
│   ├── config.py                  # Configuration management (API keys, regions, etc.)
├── scripts/                       # (Optional) Shell scripts for setting up the FastAPI app
│   ├── docker_deploy.sh           # Script to deploy FastAPI app with Docker
├── Dockerfile                     # Dockerfile for FastAPI app
├── docker-compose.yml             # Docker Compose orchestration for multi-service setup
├── requirements.txt               # Python dependencies
├── .env                           # Environment variables (API keys, etc.)
```

### **2.2 Structure Rationale**

- **Modularity**: Each folder corresponds to a specific part of the system—API routes, services, utilities, and configurations.
- **Single Responsibility**: Each Python file handles a single type of operation, such as managing AWS Lightsail, GitHub secrets, or Docker containers.
- **Separation of Concerns**: Routes are separated from business logic (services), ensuring that the API routes remain clean and focused only on routing and handling requests.

---

## **3. API Routes: Manual Control and Modularity**

Every API route in this application is explicitly **manually triggered** by the user. This gives full control over the infrastructure deployment and service management process.

### **3.1 AWS Lightsail Management**

These routes will control the creation, start, stop, and deletion of AWS Lightsail instances. 

#### **Example Route: Create a Lightsail Instance**

```python
# app/api/lightsail/instances.py
from fastapi import APIRouter
from app.services.lightsail_service import create_instance

router = APIRouter()

@router.post("/create-instance")
async def create_lightsail_instance(instance_name: str, blueprint_id: str, bundle_id: str, region: str, availability_zone: str):
    response = create_instance(instance_name, blueprint_id, bundle_id, region, availability_zone)
    return response
```

#### **Service Layer for Lightsail Operations**

```python
# app/services/lightsail_service.py
import boto3

def create_instance(instance_name, blueprint_id, bundle_id, region, availability_zone):
    client = boto3.client('lightsail', region_name=region)
    
    response = client.create_instances(
        instanceNames=[instance_name],
        availabilityZone=availability_zone,
        blueprintId=blueprint_id,
        bundleId=bundle_id
    )
    
    return {"status": "success", "message": f"Instance {instance_name} created in {region}"}
```

### **3.2 GitHub Secrets Management**

These routes handle GitHub secrets, ensuring that sensitive information (such as SSH keys, AWS credentials) is securely stored in **GitHub Secrets**.

#### **Example Route: Add a GitHub Secret**

```python
# app/api/github/secrets.py
from fastapi import APIRouter
from app.services.github_service import add_secret

router = APIRouter()

@router.post("/add-secret")
async def add_github_secret(repo_name: str, secret_name: str, secret_value: str, github_token: str):
    response = add_secret(repo_name, secret_name, secret_value, github_token)
    return response
```

#### **Service Layer for GitHub Secrets**

```python
# app/services/github_service.py
from github import Github

def add_secret(repo_name, secret_name, secret_value, token):
    g = Github(token)
    repo = g.get_repo(repo_name)
    
    # Add or update the secret
    repo.create_secret(secret_name, secret_value)
    return {"status": "success", "message": f"Secret {secret_name} added to {repo_name}"}
```

### **3.3 Service Deployment (OpenSearch, Kong, Docker)**

These routes manage the deployment of services like **OpenSearch**, **Kong**, and **Dockerized apps**. Each service has a dedicated route for deployment, ensuring modularity and ease of use.

#### **Example Route: Deploy OpenSearch**

```python
# app/api/services/opensearch.py
from fastapi import APIRouter
from app.services.opensearch_service import deploy_opensearch

router = APIRouter()

@router.post("/deploy-opensearch")
async def deploy_opensearch(instance_ip: str, ssh_key_path: str):
    response = deploy_opensearch(instance_ip, ssh_key_path)
    return response
```

#### **Service Layer for OpenSearch Deployment**

```python
# app/services/opensearch_service.py
import paramiko

def deploy_opensearch(instance_ip, ssh_key_path):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        ssh.connect(instance_ip, username='ubuntu', key_filename=ssh_key_path)
        
        commands = [
            "sudo apt update",
            "sudo apt install -y wget apt-transport-https",
            "wget -qO - https://artifacts.opensearch.org/GPG-KEY-opensearch | sudo apt-key add -",
            "echo 'deb https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/opensearch.list",
            "sudo apt update",
            "sudo apt install -y opensearch",
            "sudo systemctl enable opensearch",
            "sudo systemctl start opensearch"
        ]
        
        for command in commands:
            stdin, stdout, stderr = ssh.exec_command(command)
            stdout.channel.recv_exit_status()  # Ensure command runs successfully
        
        ssh.close()
        return {"status": "success", "message": "OpenSearch deployed successfully"}
    
    except Exception as e:
        ssh.close()
        return {"status": "error", "message": str(e)}
```

---

## **4. Idempotency: Ensuring Stable Operations**

In keeping with the FountainAI way, all API routes and services are **idempotent**. This means that if a user triggers the same action (e.g., deploying OpenSearch) multiple times, the system will handle it gracefully without causing issues such as redundant deployments.

Example of ensuring idempotency in the OpenSearch service:
```python
# app/services/opensearch_service.py

def deploy_opensearch(instance_ip, ssh_key_path):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        ssh.connect(instance_ip, username='ubuntu', key_filename=ssh_key_path)
        
        # Check if OpenSearch is already installed
        stdin, stdout, stderr = ssh.exec_command("dpkg -l | grep opensearch")
        installed = stdout.read().decode()
        
        if "opensearch" in installed:
            ssh.close()
            return {"status": "success", "message": "OpenSearch is already installed"}
        
        # Install OpenSearch if not installed
        commands = [
            "sudo apt update",
            "sudo apt install -y opensearch",
            "sudo systemctl enable opense

arch",
            "sudo systemctl start opensearch"
        ]
        
        for command in commands:
            stdin, stdout, stderr = ssh.exec_command(command)
            stdout.channel.recv_exit_status()  # Ensure command runs successfully
        
        ssh.close()
        return {"status": "success", "message": "OpenSearch deployed successfully"}
    
    except Exception as e:
        ssh.close()
        return {"status": "error", "message": str(e)}
```

---

## **5. Dockerization: Deploying the FastAPI App**

The FastAPI app itself will be containerized using **Docker**, ensuring that the app can be easily deployed on any server.

### **5.1 Dockerfile**

The **Dockerfile** for the FastAPI app will look as follows:

```dockerfile
# Use a minimal Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Run the FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### **5.2 Docker Compose**

If you’re running multiple services (e.g., OpenSearch, Kong, and Dockerized apps), **Docker Compose** can be used to manage the deployment.

```yaml
version: "3.8"
services:
  app:
    build: .
    ports:
      - "8000:8000"
    env_file:
      - .env
    depends_on:
      - opensearch
      - kong

  opensearch:
    image: opensearchproject/opensearch:1.0.0
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"

  kong:
    image: kong
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: "/usr/local/kong/kong.yml"
    ports:
      - "8001:8001"
```

---

## **6. Documentation and OpenAPI Integration**

FastAPI automatically generates **OpenAPI documentation** (Swagger UI) for all routes. You should ensure that each route has proper docstrings and parameter descriptions so users can easily interact with the API.

#### Example:
```python
@router.post("/create-instance", summary="Create AWS Lightsail Instance", description="Creates a new AWS Lightsail instance with the given parameters.")
async def create_lightsail_instance(instance_name: str, blueprint_id: str, bundle_id: str, region: str, availability_zone: str):
    """
    Create a new AWS Lightsail instance.
    
    - **instance_name**: The name of the Lightsail instance.
    - **blueprint_id**: The OS blueprint ID (e.g., `ubuntu_20_04`).
    - **bundle_id**: The instance size (e.g., `nano_2_0`).
    - **region**: The AWS region (e.g., `eu-central-1`).
    - **availability_zone**: The AWS availability zone (e.g., `eu-central-1a`).
    """
    response = create_instance(instance_name, blueprint_id, bundle_id, region, availability_zone)
    return response
```

---

## **7. Conclusion**

This **FastAPI app built the FountainAI way** is highly modular, manually controlled, idempotent, and well-documented. By splitting responsibilities into **routes**, **services**, and **utilities**, the app remains easy to maintain, scale, and extend. Leveraging **manual API triggers** ensures that users retain control over the infrastructure without needing fully automated pipelines, while **GitHub Actions** automates critical parts of the development and testing process.

The project fully aligns with the **FountainAI principles**, providing a cost-effective, manually controlled, and scalable infrastructure management solution.

---

