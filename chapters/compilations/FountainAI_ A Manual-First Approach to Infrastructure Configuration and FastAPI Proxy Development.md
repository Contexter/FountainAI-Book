

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

