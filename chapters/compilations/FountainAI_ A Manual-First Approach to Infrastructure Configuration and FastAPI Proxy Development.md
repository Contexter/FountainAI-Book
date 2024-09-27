

## **FountainAI: A Manual-First Approach to Infrastructure Configuration and FastAPI Proxy Development**

---

### **Abstract**

This paper outlines a practical, **manual-first approach** to managing infrastructure configurations using **AWS Lightsail**, **Kong**, **Docker**, and **OpenSearch** within the **FountainAI system**. By using **FastAPI proxies** to wrap external APIs, this architecture ensures that all actions are secure, idempotent, and manually controlled. The focus is on creating **expressive OpenAPI documentation**, which acts as the **single source of truth** for the entire system. This paper breaks down the core principles of FountainAI, guidelines for FastAPI proxy creation, and the importance of clear, actionable OpenAPI documentation.

---

### **Chapter 1: The Principles of FountainAI**

---

#### **Introduction**

FountainAI is built on a set of guiding **principles** that ensure a **manual-first**, **secure**, **modular**, and **traceable** approach to managing infrastructure. These principles are designed to maintain human control over all critical tasks while allowing for automation that is deterministic and predictable.

---

#### **1. Manual-First Control**

At the core of FountainAI is the **manual-first control** principle. Unlike fully automated systems that risk triggering changes without human oversight, FountainAI ensures:
- Every action is **manually triggered** by an authorized human operator.
- There are **no unintended changes** to the system. Every update, deployment, or configuration change is performed with full awareness and approval.

This allows for **deterministic execution**, where actions are predictable and fully understood by the user before they are carried out. By prioritizing manual control, FountainAI minimizes the risk of errors or unintended actions that can arise in overly automated environments.

---

#### **2. Modularity**

FountainAI promotes a highly **modular architecture**, where each component is designed to perform a specific, isolated task:
- **Separation of Concerns**: Every module or proxy handles a single responsibility, such as managing Docker containers, interacting with AWS, or handling requests to Kong's API Gateway.
- **Reusability**: Modular components are easy to reuse across the system, allowing for flexibility and scalability.
- **Ease of Maintenance**: Modularity ensures that components can be maintained, debugged, or replaced individually without affecting other parts of the system.

This modular approach helps FountainAI remain agile and scalable, allowing new functionality to be added without disruption.

---

#### **3. Idempotency**

**Idempotency** is critical to ensuring consistent and predictable behavior in FountainAI:
- **Consistent Outcomes**: Repeated execution of the same action should result in the same outcome. Whether creating a resource, updating a configuration, or managing infrastructure, idempotency ensures no duplicate or conflicting results.
- **Safe Re-Execution**: If an operation is performed multiple times (intentionally or by accident), it will not create unintended side effects.

This principle safeguards the system against redundant or conflicting changes and ensures that infrastructure remains stable.

---

#### **4. Security**

Security is integral to FountainAI's design. Every interaction with the system is subject to strict **authentication** and **authorization**:
- **Authenticated Access**: Users must be authenticated using **OAuth2**, **API Keys**, or **JWT tokens** to perform actions within the system.
- **Authorization Controls**: Authorization ensures that sensitive operations, like creating or deleting instances, are restricted to authorized personnel.
- **Secure Secrets Management**: Sensitive information like API keys and credentials are stored securely using **GitHub Secrets**, **AWS Secrets Manager**, or other secure storage systems.

By embedding security deeply into the system, FountainAI prevents unauthorized access and ensures that sensitive data is protected.

---

#### **5. Traceability and Logging**

**Traceability** is essential for maintaining accountability within FountainAI. All actions performed through the system are **logged** and **auditable**:
- **Comprehensive Logging**: Every action—whether successful or not—is logged. Logs include details about who performed the action, what the action was, and when it occurred.
- **Auditable**: Logs provide a complete audit trail, allowing system administrators to trace and verify every action taken within the system.

This traceability ensures that the system can be monitored effectively and that all actions are accountable.

---

#### **6. OpenAPI as the Source of Truth**

**OpenAPI** serves as the **single source of truth** for all interactions within the FountainAI system. Every service exposes its endpoints, inputs, outputs, and security requirements through a standardized OpenAPI specification:
- **Self-Documenting APIs**: Each FastAPI proxy generates an OpenAPI specification, detailing all available endpoints, models, and security mechanisms.
- **Consistency and Transparency**: OpenAPI provides a clear, unified view of how the system operates, ensuring that all actions are consistent and transparent.
- **Deterministic Execution**: The system relies on OpenAPI documentation to ensure that every action is predictable and well-defined.

By making OpenAPI the foundation of the system, FountainAI ensures that its interactions are clear, maintainable, and secure.

---

### **Chapter 2: The FountainAI Way of Creating FastAPI Proxies**

---

#### Introduction

In the **FountainAI** architecture, **FastAPI proxies** are central components that act as interfaces to external services like **Docker**, **AWS Lightsail**, **Kong**, and **GitHub**. These proxies allow system administrators and developers to interact with these services in a secure, modular, and traceable way, while adhering to the **FountainAI principles**.

The primary goal of FastAPI proxies is to ensure **manual-first control**, enforce **security**, and make **OpenAPI the single source of truth**. This chapter outlines the specific design principles and practices for building FastAPI proxies the **FountainAI way**.

---

#### The Design Principles for FastAPI Proxies in FountainAI

When building FastAPI proxies, it is essential to adhere to the following principles, ensuring that the proxies align with the broader goals of the FountainAI system:

1. **Manual-First Control**:
   - FastAPI proxies must always require **manual triggers** for critical actions. Whether it's deploying an AWS instance, managing Docker containers, or configuring Kong services, every action should be explicitly initiated by a user.

2. **Modularity**:
   - Each FastAPI proxy must focus on a single service or component, ensuring **separation of concerns**. This makes the system easier to scale, maintain, and secure.

3. **Security**:
   - Every API interaction within a FastAPI proxy must be authenticated and authorized. Sensitive information such as API keys or credentials must be stored securely and managed through services like **GitHub Secrets** or **AWS Secrets Manager**.

4. **Idempotency**:
   - Each operation exposed by a FastAPI proxy should be **idempotent**. If an operation (such as creating a Docker container or adding a Kong service) is triggered multiple times, the result should be the same, with no unintended side effects.

5. **OpenAPI as the Source of Truth**:
   - Each FastAPI proxy must generate an **OpenAPI specification** that serves as the **single source of truth** for all interactions. This ensures that the system is well-documented and that every action is traceable.

---

### **Chapter 3: Building FastAPI Proxies in Practice**

---

#### Introduction

In this chapter, we will look at practical examples of how to build **FastAPI proxies** in the FountainAI system. These proxies wrap external services such as **Docker**, **AWS Lightsail**, and **Kong**, allowing for controlled, secure, and idempotent operations that align with FountainAI's principles.

---

### 1. Example: FastAPI Proxy for Docker

---

#### a. Setting Up the FastAPI Application

```python
from fastapi import FastAPI, HTTPException, Depends
import requests
import os

app = FastAPI()

# Environment variable for Docker API URL
DOCKER_API_URL = os.getenv("DOCKER_API_URL", "http://localhost:2375")
```

#### b. API Endpoint to Create a Docker Container

This endpoint allows a user to manually create a Docker container by providing an image name and optional container name.

```python
@app.post(
    "/containers/create",
    summary="Create Docker Container",
    description="Manually create a Docker container by specifying an image and optional container name. Ensures no duplicate containers are created.",
    operation_id="createDockerContainer",  # Clear command-like operation ID
    responses={
        201: {"description": "Container created successfully"},
        400: {"description": "Invalid request"},
        409: {"description": "Container already exists"},
    },
    security=[{"ApiKeyAuth": []}],
    tags=["Docker Management"]
)
async def create_container(image: str, name: str = None):
    payload = {"Image": image}
    if name:
        payload["name"] = name

    response = requests.post(f"{DOCKER_API_URL}/containers/create", json=payload)
    
    if response.status_code == 201:
        return {"message": "Container created successfully"}
    else:
        raise HTTPException(status_code=response.status_code, detail=response.json())
```

---

### 2. Example: FastAPI Proxy for AWS Lightsail

---

#### a. Setting Up the FastAPI Application

```python
import boto3
from fastapi import FastAPI, HTTPException

app = FastAPI()

aws_region = os.getenv("AWS_REGION", "eu-central-1")
client = boto3.client("lightsail", region_name=aws_region)
```

#### b. API Endpoint to Create an AWS Instance

```python
@app.post(
    "/lightsail/create-instance",
    summary="

Create AWS Lightsail Instance",
    description="Manually create an AWS Lightsail instance by providing the instance name and blueprint ID. The operation is idempotent and returns an error if the instance already exists.",
    operation_id="createLightsailInstance",
    responses={
        201: {"description": "Instance created successfully"},
        400: {"description": "Invalid request"},
        409: {"description": "Instance already exists"},
    },
    security=[{"ApiKeyAuth": []}],
    tags=["AWS Management"]
)
async def create_instance(instance_name: str, blueprint_id: str):
    try:
        response = client.create_instances(
            instanceNames=[instance_name],
            blueprintId=blueprint_id,
            bundleId="nano_2_0",
            availabilityZone=f"{aws_region}a",
        )
        return {"message": f"Instance {instance_name} created successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

---

### 3. Example: FastAPI Proxy for Kong API Gateway

---

#### a. Setting Up the FastAPI Application

```python
from fastapi import FastAPI, HTTPException
import requests
import os

app = FastAPI()

KONG_ADMIN_URL = os.getenv("KONG_ADMIN_URL", "http://localhost:8001")
```

#### b. API Endpoint to Add a Service in Kong

```python
@app.post(
    "/kong/add-service",
    summary="Add Service to Kong",
    description="Manually add a service to Kong Gateway by specifying the service name and upstream URL. Ensures no duplicate services are created.",
    operation_id="addKongService",
    responses={
        201: {"description": "Service added successfully"},
        400: {"description": "Invalid request"},
        409: {"description": "Service already exists"},
    },
    security=[{"ApiKeyAuth": []}],
    tags=["Kong Management"]
)
async def add_service(name: str, url: str):
    payload = {"name": name, "url": url}
    
    response = requests.post(f"{KONG_ADMIN_URL}/services", json=payload)
    
    if response.status_code == 201:
        return {"message": f"Service {name} added successfully"}
    else:
        raise HTTPException(status_code=response.status_code, detail=response.json())
```

---

### Chapter 4: Writing Expressive OpenAPI Documentation in FountainAI

---

#### Introduction

While FastAPI generates OpenAPI specifications automatically, these default docs are often **not human-readable** or **expressive enough** to meet the needs of a **manual-first** system like FountainAI. To ensure **OpenAPI becomes the single source of truth**, it’s essential to provide **expressive, human-friendly documentation** that aligns with the guiding principles of FountainAI.

---

### 1. Overwriting `operationId` with Command-like Expressions

By default, FastAPI generates operation IDs based on the path and method (e.g., `post_containers_create`). These default IDs are not always intuitive or helpful when generating client code or understanding API functionality. To make the OpenAPI spec **actionable and clear**, we will overwrite these defaults with **command-like camelCase expressions** that explicitly describe what each operation does.

**Example**:
```python
@app.post(
    "/containers/create",
    summary="Create Docker Container",
    description="Manually create a Docker container by specifying an image and optional container name. Ensures no duplicate containers are created.",
    operation_id="createDockerContainer",  # Clear command-like operation ID
    responses={
        201: {"description": "Container created successfully"},
        400: {"description": "Invalid request"},
        409: {"description": "Container already exists"},
    },
    security=[{"ApiKeyAuth": []}],
    tags=["Docker Management"]
)
```

---

### 2. Guidelines for Descriptions

Descriptions are meant to provide quick and easy-to-read explanations of what each endpoint does. To avoid overwhelming the user with too much information, descriptions should be kept **concise** and **limited to 300 characters**.

**Example**:

```python
@app.post(
    "/lightsail/create-instance",
    summary="Create AWS Lightsail Instance",
    description="Manually create an AWS Lightsail instance by providing the instance name and blueprint ID. The operation is idempotent and returns an error if the instance already exists.",
    operation_id="createLightsailInstance",
    responses={
        201: {"description": "Instance created successfully"},
        400: {"description": "Invalid request"},
        409: {"description": "Instance already exists"},
    },
    security=[{"ApiKeyAuth": []}],
    tags=["AWS Management"]
)
async def create_instance(instance_name: str, blueprint_id: str):
    # ...
```

---

### 3. Best Practices for Writing Summaries

Summaries should provide a **short, actionable** description of what the endpoint does. They are particularly helpful when reviewing the API documentation quickly or when generating client libraries.

**Example**:

```python
@app.post(
    "/kong/add-service",
    summary="Add Service to Kong",
    description="Manually add a service to Kong Gateway by specifying the service name and upstream URL. Ensures no duplicate services are created.",
    operation_id="addKongService",
    security=[{"ApiKeyAuth": []}],
    tags=["Kong Management"]
)
async def add_service(name: str, url: str):
    # ...
```

---

### 4. Security Documentation in OpenAPI

Each FastAPI proxy must also **document security mechanisms** clearly within the OpenAPI specification. Users need to know **how** to authenticate, which headers to include, and what kind of **permissions** are required for specific actions.

---

### Conclusion

By following these guidelines, the **OpenAPI documentation** generated by FastAPI proxies becomes far more **expressive**, **human-readable**, and **self-explanatory**. This aligns with the **FountainAI way**, ensuring that every action taken is secure, traceable, and fully intentional, with **OpenAPI** serving as the **single source of truth** for the entire system.


### **Chapter 5: Refactoring a Monolithic FastAPI Application – A Step-by-Step Guide**

---

#### **5.1 Introduction**

As applications grow in complexity, a monolithic structure can make it challenging to maintain, extend, and test effectively. To ensure that APIs are scalable and modular, we adopt **FountainAI principles**—**manual-first control**, **modularity**, and **idempotency**. This chapter walks you through the process of refactoring a **monolithic FastAPI application** following these principles.

We will explore the existing **monolith**, dissect its structure, and transform it into a modular design. We'll introduce **OpenAPI documentation** as the **single source of truth** and use **FountainAI shell scripting** to automate deployments, ensuring **manual-first control** and **deterministic execution**. The chapter will culminate in a **comprehensive project tree** for the refactored system and encourage **assisted coding practices** that empower developers to build infrastructure in a **FountainAI-compliant** manner.

---

#### **5.2 Exploring the Monolith**

The starting point for this refactor is the **fountainai-fastapi-proxy** repository, which contains the original **monolithic application** in the [`main.py`](https://github.com/Contexter/fountainai-fastapi-proxy/blob/main/main.py) file. This single file houses all the routing, services, error handling, and logging, leading to a tightly coupled design that suffers from several limitations:
- **Single Responsibility Violations**: Routes are responsible for too many tasks, such as calling external APIs, managing responses, and handling errors.
- **Hardcoded Configuration**: Sensitive information like the **GitHub token** is hardcoded directly in the application, making it difficult to manage across environments.
- **Testability and Scalability Issues**: The lack of modularization makes the application harder to scale and test effectively.

Here’s an example of what you will find in the original monolith:
```python
@app.get("/repos/{owner}/{repo}/issues")
def list_issues(owner: str, repo: str, first: int = 10):
    query = """..."""
    headers = {"Authorization": f"Bearer {GITHUB_TOKEN}"}
    
    response = requests.post(GITHUB_GRAPHQL_API_URL, json={"query": query, "variables": {"owner": owner, "repo": repo, "first": first}}, headers=headers)
    if response.status_code != 200:
        logging.error(f"Error fetching issues: {response.status_code}")
        raise HTTPException(status_code=response.status_code, detail="Error fetching issues")
    
    return response.json()
```

This file demonstrates that the routing logic is tightly coupled with API calls and error handling, making it difficult to maintain as the application grows.

The **README** of the repository provides an overview of the **FountainAI way** of building proxies with **FastAPI**, emphasizing modularity and automation. You can find it [here](https://github.com/Contexter/fountainai-fastapi-proxy/blob/main/README.md), where it outlines best practices for modular design, including the separation of **routes**, **services**, and **utilities** into distinct layers.

---

#### **5.3 Refactoring into a Modular Architecture**

To address the limitations of the monolith, we will transform the project into a modular architecture. This refactor separates the routing logic, API interaction logic, and utility functions into different components, adhering to the **FountainAI principle of modularity**.

##### **5.3.1 Project Structure**

The refactored project will adopt the following structure, as suggested by the [README](https://github.com/Contexter/fountainai-fastapi-proxy/blob/main/README.md) in the original repository:

```
project/
├── app/
│   ├── main.py                    # FastAPI app creation, dynamic route loading
│   ├── api/                       # API routes for proxying external APIs
│   │   ├── github/                # Domain-specific folder (e.g., GitHub API)
│   │   │   ├── issues.py          # GitHub issues routes
│   │   │   ├── pull_requests.py   # GitHub pull request routes
│   │   │   ├── repositories.py    # GitHub repository routes
│   ├── services/                  # Business logic for external API interactions
│   │   ├── github/                # Services for GitHub API
│   │   │   ├── issues_service.py  # GitHub issues service
│   │   │   ├── pull_requests_service.py
│   │   │   ├── repositories_service.py
│   ├── utils/                     # Utility functions (e.g., logging)
│   ├── config.py                  # Configuration management (e.g., API keys)
├── scripts/                       # FountainAI-style automation scripts
│   ├── fountainai_docker_deploy.sh
│   ├── generate_github_actions.sh
├── Dockerfile                     # Dockerfile for FastAPI proxy
├── docker-compose.yml             # Docker Compose for orchestration
├── requirements.txt               # Python dependencies
├── .env                           # Environment variables (API keys, etc.)
```

This structure separates **routes** from **services** and **utilities**, making the codebase easier to extend, maintain, and test.

##### **5.3.2 Modularization of Routes and Services**

Each route should focus on request handling, delegating the business logic to **service layers**. For example, the **GitHub Issues** route in the monolith is refactored into:

```python
# app/api/github/issues.py
from fastapi import APIRouter
from app.services.github.issues_service import get_github_issues, create_github_issue

router = APIRouter()

@router.get("/issues", summary="Fetch GitHub Issues")
async def list_github_issues(owner: str, repo: str):
    return get_github_issues(owner, repo)

@router.post("/issues", summary="Create a GitHub Issue")
async def create_github_issue(owner: str, repo: str, title: str, body: str = None):
    return create_github_issue(owner, repo, title, body)
```

Here, the **business logic** for interacting with the GitHub API is encapsulated within the **service layer**, which handles external API calls:
```python
# app/services/github/issues_service.py
import requests
from app.config import settings

GITHUB_API_URL = "https://api.github.com/repos"

def get_github_issues(owner: str, repo: str):
    url = f"{GITHUB_API_URL}/{owner}/{repo}/issues"
    headers = {"Authorization": f"Bearer {settings.GITHUB_TOKEN}"}
    response = requests.get(url, headers=headers)
    return response.json()

def create_github_issue(owner: str, repo: str, title: str, body: str = None):
    url = f"{GITHUB_API_URL}/{owner}/{repo}/issues"
    headers = {"Authorization": f"Bearer {settings.GITHUB_TOKEN}"}
    payload = {"title": title, "body": body}
    response = requests.post(url, json=payload, headers=headers)
    return response.json()
```

---

#### **5.4 OpenAPI as the Single Source of Truth**

In **FountainAI**, **OpenAPI** is not just a documentation tool—it is the **single source of truth** for all API interactions. Every route must include descriptive summaries, operation IDs, and responses to ensure that the API is easy to use and maintain.

Here’s how we apply these principles to the **GitHub Issues** route:
```python
# app/api/github/issues.py
@router.get("/issues",
    summary="Fetch GitHub Issues",
    description="Retrieve issues from a specific GitHub repository.",
    operation_id="list_github_issues"
)
async def list_github_issues(owner: str, repo: str):
    return get_github_issues(owner, repo)
```
This ensures that each route is fully documented, allowing FastAPI’s automatic OpenAPI generation to produce detailed, clear, and actionable API documentation.

---

#### **5.5 FountainAI Shell Scripting for Automation**

To automate deployment and other tasks, we use **FountainAI shell scripts**. These scripts are **manual-first**, **idempotent**, and **deterministic**, ensuring that they can be executed multiple times without unintended consequences.

One example is the **`fountainai_docker_deploy.sh`** script, which automates the process of building and deploying the FastAPI application using Docker:
```bash
#!/bin/bash
set -e  # Exit immediately if a command fails

# Function to build Docker image
build_docker_image() {
    echo "Building Docker image..."
    docker build -t fastapi-proxy .
}

# Function to run Docker container
run_docker_container() {
    container_name="fastapi-proxy"
    if [ "$(docker ps -q -f name=$container_name)" ]; then
        echo "Container $container_name is already running."
    else
        echo "Running Docker container..."
        docker run -d -p 8000:8000 --name $container_name fastapi-proxy
    fi
}

# Execute the deployment
build_docker_image
run_docker_container
```

This script builds and runs the FastAPI proxy inside a Docker container, checking if the container is already running to avoid duplication. The script follows **FountainAI principles** by ensuring **manual control** and **idempotency**—running the script multiple times will not result in duplicate containers or errors.

---

#### **5.6 Comprehensive Project Tree After Refactor**

After refactoring the monolith into a modular architecture, the project structure should resemble the following:

```
project/
├── app/
│   ├── main.py                    # FastAPI app creation, dynamic route loading
│   ├── api/                       # API routes for proxying external APIs
│   │   ├── github/
│   │   │   ├── issues.py          # GitHub issues routes
│   │   │   ├── pull_requests.py   # GitHub pull request routes
│   │   │   ├── repositories.py    # GitHub repository routes
│   ├── services/                  # Business logic for external API interactions
│   │   ├── github/
│   │   │   ├── issues_service.py  # GitHub issues service
│   │   │   ├── pull_requests_service.py
│   │   │   ├── repositories_service.py
│   ├── utils/                     # Utility functions (e.g., logging)
│   ├── config.py                  # Configuration management (e.g., API keys)
├── scripts/                       # FountainAI-style automation scripts
│   ├── fountainai_docker_deploy.sh
│   ├── generate_github_actions.sh
├── Dockerfile                     # Dockerfile for FastAPI proxy
├── docker-compose.yml             # Docker Compose for orchestration
├── requirements.txt               # Python dependencies
├── .env                           # Environment variables (API keys, etc.)
```

This modular design aligns with **FountainAI’s principles** and is ready for scalable deployment.

---

#### **5.7 Conclusion**

In this chapter, we explored the **monolithic FastAPI application**, identified its limitations, and refactored it into a **modular, scalable architecture**. We implemented **OpenAPI documentation** as the single source of truth and used **FountainAI shell scripts** to automate deployment while ensuring **manual-first control** and **idempotency**. The resulting project is maintainable, scalable, and ready for future extensions.

By adhering to these principles, you can now build APIs that are modular, well-documented, and easy to maintain.


