# PART A
# FountainAI: 
> Building a Scalable, AI-Driven Storytelling Platform

---

### **Preface**

Storytelling is evolving, and at the heart of this transformation is FountainAI—a platform designed to make narratives truly adaptive, responsive, and interactive. This compilation provides an in-depth exploration of the core technologies and architectural choices that make FountainAI scalable and efficient. By leveraging advanced AI techniques, modular microservices, and robust data management, FountainAI is able to create dynamic storytelling experiences that evolve in real time.

In the chapters that follow, you’ll dive into how **Context** ensures that stories remain coherent as they adapt to user input. You’ll also see how the **GPT model** collaborates with **OpenSearch** to manage and retrieve narrative data efficiently, while **Kong Gateway** maintains the platform’s scalability and ensures smooth communication between services. The combination of these components enables a fluid storytelling experience that evolves as the narrative unfolds.

This compilation serves as an entry point into the technical foundations of FountainAI—designed for those interested in understanding how cutting-edge technology can elevate storytelling to new levels of interactivity and immersion.

---

### **Chapter 1: FountainAI Architecture Overview**

FountainAI is an AI-driven storytelling platform designed to create dynamic, adaptive narratives that evolve in real time. At its core, FountainAI relies on **Context**, which serves as the central driving force behind the platform’s ability to maintain narrative coherence. As the story develops and users interact with the system, **Context** ensures that the narrative adapts to the changing conditions.

The platform is built on a **modular microservices architecture**, which allows for both flexibility and scalability. Each microservice within this architecture has a distinct role in managing various aspects of the storytelling process, from characters and actions to dialogues and music. While these services operate independently, **Context** acts as the central binding force that ensures all elements of the story remain synchronized and coherent.

**Context** continuously tracks the real-time state of the narrative, ensuring that characters, actions, and dialogues evolve naturally as the story progresses. This real-time adaptation allows FountainAI to seamlessly integrate user interactions into the storyline, providing an immersive experience where every decision and input has an impact on the narrative. Each microservice relies on **Context** to ensure that it is aligned with the overall direction of the story.

To facilitate communication between its various microservices, FountainAI leverages **OpenAPI**. OpenAPI serves as the framework that defines and standardizes the communication protocols across the platform. This ensures that all services, from managing character dialogues to adjusting narrative flow, can interact efficiently and reliably. With OpenAPI in place, FountainAI can maintain a consistent approach to how data flows through the system, making it easier to scale and integrate new services without disrupting the story's coherence.

The **Session Context Service** is responsible for managing the ongoing context of the narrative. This service ensures that as users interact with the story, their inputs are reflected in the evolving narrative in real time. The **Core Script Management Service** plays a key role in storing, retrieving, and updating scripts, which are the backbone of the story. It interacts with other services, such as the **Story Factory Service** and **Character Management Service**, to dynamically adjust scripts based on the current context, ensuring the narrative remains flexible and adaptable.

The **Story Factory Service** is tasked with assembling and organizing narrative elements—such as characters, actions, and dialogues—in response to changes in context. As the story progresses and the context shifts, the Story Factory ensures that the narrative is logically reordered, allowing for seamless transitions based on user decisions or other contextual updates. The **Character Management Service** handles one of the most critical aspects of storytelling: paraphrasing. This service is responsible for adjusting how characters are described and how their actions and dialogues are presented to fit the evolving context. It manages three distinct types of paraphrasing: character paraphrase, which rephrases how a character’s behavior or traits are described; action paraphrase, which adjusts how character actions are framed within the narrative; and dialogue paraphrase, which ensures that characters’ speech remains contextually appropriate while retaining its original intent. Together, these paraphrasing functions allow characters to feel dynamic and responsive to the changing storyline.

The **Central Sequence Service** ensures continuity throughout the story by assigning unique sequence identifiers to all narrative elements. This is particularly important when narrative elements need to be reordered based on contextual shifts. By providing a system for tracking and managing these identifiers, the Central Sequence Service ensures that all elements of the story remain logically ordered and coherent, even when they are dynamically adjusted in response to user actions.

In addition to managing narrative elements, FountainAI incorporates real-time music and sound creation to enhance the storytelling experience. The platform uses **Csound** and **LilyPond** to generate and adapt music and soundscapes that reflect the emotional tone of the narrative as it evolves. **Csound** provides powerful sound synthesis capabilities, allowing FountainAI to create immersive audio experiences that align with the events of the story. **LilyPond** focuses on music engraving, dynamically generating musical scores that shift in response to the emotional and narrative context of the story. These tools ensure that the auditory elements of the story evolve in harmony with the unfolding narrative, adding depth and immersion to the storytelling experience.

At the heart of FountainAI’s architecture is the notion of **coherence through context**. **Context** is the glue that holds all the services together, ensuring that the story, characters, actions, and even music remain aligned with the user’s choices and the evolving narrative. When the context changes, all services are updated accordingly, allowing the story to adapt without losing its logical flow. This is particularly important for the **paraphrasing** system, which enables characters, actions, and dialogues to change dynamically while maintaining their relevance within the larger story. Through the interplay of **Context** and **paraphrasing**, FountainAI is able to create a narrative that feels fluid, responsive, and deeply engaging.

Finally, **OpenAPI** serves as the foundation that makes this complex system of services work together seamlessly. By defining a clear and consistent communication protocol, OpenAPI ensures that each microservice can interact with others in a way that supports the scalability and adaptability of the system. As FountainAI grows and new services are introduced, OpenAPI allows the platform to evolve without sacrificing the coherence of the narrative. In this way, OpenAPI acts as the **single source of truth** for all service interactions, ensuring that FountainAI can scale while maintaining its core strength: delivering adaptive, coherent stories.

---

### **Chapter 2: OpenSearch as the Backbone of Adaptive Storytelling**

OpenSearch is at the core of FountainAI’s architecture, serving as the powerful engine behind both real-time query generation and efficient data management. It plays a dual role in facilitating adaptive storytelling by handling complex, dynamic queries driven by a GPT model and efficiently managing large volumes of narrative data. This chapter combines the mechanics of **query generation** and **data storage**, highlighting how OpenSearch powers the flexible and scalable storytelling that is the heart of FountainAI.

#### **GPT-Driven OpenSearch Query Generation**

FountainAI’s storytelling is adaptive, constantly evolving based on user inputs and interactions. At the core of this adaptability is the ability to generate dynamic queries that fetch and filter narrative elements in real time. OpenSearch’s **Query DSL** (Domain Specific Language) is the tool that allows these queries to be both flexible and specific, ensuring that relevant story data is retrieved efficiently.

The **GPT model** in FountainAI is responsible for constructing these queries. Instead of relying on predefined data retrieval paths, the GPT model dynamically generates OpenSearch queries that align with the current context of the story. These queries go beyond simple keyword matching, involving full-text searches, filtering based on specific conditions, and performing aggregations that help analyze complex statistics, such as how often a character has spoken or the tone of dialogue throughout the story.

For example, if a user decides to modernize Hamlet’s "To be or not to be" soliloquy, the GPT model constructs an OpenSearch query that retrieves Hamlet’s speech from the script, filters to include only the relevant scene, and aggregates associated character behaviors and actions. The system then indexes any changes in real time, ensuring that modifications are immediately reflected in the narrative. The process of constructing and executing these queries happens in milliseconds, allowing FountainAI to adjust its storytelling fluidly and without noticeable delay.

Once these queries are executed, OpenSearch plays a critical role in orchestrating interactions between microservices. The **Session Context Service** updates the story’s context, reflecting the user's decision, while the **Core Script Management Service** retrieves the relevant sections of the narrative. The **Story Factory Service** adjusts and reorders the narrative elements, and the **Character Management Service** applies paraphrasing to adapt the dialogue to the modern tone. The **Central Sequence Service** assigns unique sequence identifiers to ensure continuity and logical progression in the story.

#### **Dynamic Data Creation and Real-Time Indexing**

In addition to generating queries, OpenSearch plays an essential role in managing FountainAI’s large, evolving dataset. Unlike traditional databases that require predefined schema and tables, OpenSearch allows new data—such as characters, actions, or dialogue—to "spring into existence" dynamically. This capability is critical for FountainAI, where stories are continuously evolving, and new narrative elements are introduced based on user input or automated context changes.

Every time a new narrative element is introduced or updated—whether it’s a new character, a scene change, or a dialogue update—OpenSearch immediately indexes this data. This **real-time indexing** ensures that the narrative is always in sync with the latest updates, allowing microservices to access and retrieve the most current data instantly. This is essential for maintaining a responsive and coherent narrative, especially in a system where the story adapts to user input on the fly.

Real-time data ingestion also enables the system to track narrative coherence across multiple services. For example, if a character’s actions in one scene need to be reflected in later scenes, OpenSearch efficiently retrieves that data and integrates it into the current context. This ability to manage continuous updates in real-time is a key component in ensuring FountainAI’s storytelling remains fluid and immersive.

#### **Efficient Data Retrieval and Query Execution**

With the volume of data managed by FountainAI increasing as the narrative grows, OpenSearch’s powerful querying capabilities allow the system to retrieve large datasets quickly and efficiently. Complex, multi-layered queries are essential when retrieving data like all of a character’s dialogues across multiple scenes or analyzing relationships between narrative elements in specific contexts.

For example, a user’s interaction may trigger the need to query and reorganize several story elements simultaneously—such as a character’s actions, their corresponding dialogue, and related contextual behaviors. OpenSearch allows the system to handle these sophisticated queries without compromising performance, even as the story becomes more complex and the dataset grows.

#### **Scalability: Handling Growing Data and User Demand**

As FountainAI expands—whether through the addition of more narrative elements or an increasing number of users interacting with the platform—OpenSearch’s **scalability** is one of its most critical features. The platform is designed to scale horizontally, meaning additional nodes can be added to the OpenSearch cluster as the volume of data increases. This distributed architecture ensures that data retrieval and indexing processes remain efficient and performant, even under heavy workloads.

OpenSearch’s ability to distribute both data storage and query processing tasks across multiple nodes means that FountainAI can handle larger datasets, support more complex storylines, and serve more concurrent users without sacrificing performance or responsiveness. Whether managing millions of lines of dialogue or processing real-time updates for thousands of simultaneous users, OpenSearch ensures that FountainAI’s adaptive storytelling remains smooth and efficient.

#### **Supporting Role of Kong Gateway**

While OpenSearch handles data storage, retrieval, and indexing, **Kong Gateway** plays a supporting role by managing the API traffic that interacts with OpenSearch. Kong Gateway ensures that API requests to and from OpenSearch are routed securely and efficiently, balancing traffic across services and enforcing rate limits to prevent overload. It also ensures that only authorized users and services can access sensitive narrative data, adding an additional layer of security.

This interaction between Kong Gateway and OpenSearch is essential for ensuring that the flow of data remains seamless and secure, particularly as the system scales and more users engage with the platform. As FountainAI evolves, the relationship between Kong Gateway and OpenSearch will become increasingly important, especially in the context of deployment and system-level operations.

#### **Dynamic World States: Expanding Narrative Flexibility**

A prime example of OpenSearch’s flexibility is seen in its ability to handle **Dynamic World States**. These are changes in the story’s environment, such as weather, economy, or time, that impact the narrative just as much as character interactions. For instance, if a user sets the world state to “the kingdom is in an economic downturn,” OpenSearch dynamically creates and indexes the necessary schema for this new narrative data type. This allows the system to adapt to changes in the world’s context seamlessly, making the new data available for querying by other microservices.

This flexibility ensures that the story can evolve organically, not only through character actions and dialogue but also in response to broader environmental factors, adding depth and complexity to the storytelling experience.

---

### **Chapter 3: API Management with Kong Gateway**

In FountainAI’s architecture, where multiple microservices are constantly communicating to adapt and deliver real-time, dynamic storytelling, the role of API management is critical. At the center of this communication management is **Kong Gateway**, an open-source API gateway that controls and monitors the flow of traffic between services. Kong Gateway ensures that API requests are routed correctly, secured, and efficiently handled, enabling FountainAI to scale while maintaining a seamless user experience.

Kong Gateway operates as the traffic controller for API calls, making sure that requests are properly authenticated, routed, and secured before they reach their destination microservices. In a system like FountainAI, where multiple services—from Story Factory to Character Management—are constantly exchanging data, Kong ensures that every call happens smoothly, securely, and with minimal latency. More importantly, as the platform scales and more users interact with the system, Kong Gateway ensures that performance doesn’t degrade by balancing traffic and enforcing rate limits where necessary.

Kong Gateway’s key features provide the backbone for FountainAI’s scalability and security. Through its **routing and load balancing capabilities**, Kong ensures that API requests are directed to the appropriate service and that no single service becomes overloaded. This dynamic routing allows FountainAI to handle high volumes of traffic, distributing requests evenly across available services and preventing bottlenecks. In addition, Kong’s **security features**—such as API key authentication, OAuth2, and JWT—ensure that only authorized users and services can access the platform’s APIs, protecting sensitive narrative data and user interactions.

Another key feature of Kong Gateway is its ability to enforce **rate limiting** and **traffic control**. By setting thresholds for the number of API requests that a service can handle within a specified time frame, Kong prevents services from becoming overwhelmed by excessive traffic. This rate limiting ensures that FountainAI remains responsive, even during high traffic periods, and that no single microservice is compromised by overuse. Real-time **logging and monitoring** allow system administrators to track API performance, identify bottlenecks, and troubleshoot issues as they arise, providing valuable insights into the overall health of the platform.

One of Kong’s most powerful features is its **tight integration with OpenAPI**. By leveraging OpenAPI specifications, Kong Gateway can automate much of the configuration process. As each microservice in FountainAI evolves, its OpenAPI definition outlines the available endpoints, request formats, authentication requirements, and more. Kong consumes these OpenAPI specs to automatically create routes, enforce security policies, and apply rate limits—drastically reducing the need for manual configuration. This integration also ensures that the APIs stay consistent, and any changes to a service’s OpenAPI spec are reflected in Kong’s configuration in real time.

For example, when a new endpoint is added to the **Story Factory Service**, instead of manually configuring the gateway to handle this new API, Kong simply reads the updated OpenAPI spec, automatically creating the necessary routes, applying security policies, and enforcing rate limits based on the defined parameters. This seamless process not only saves time but also reduces the risk of configuration errors, ensuring that the entire system remains consistent and secure as it grows.

In real-world use, Kong Gateway plays a vital role in managing the heavy API traffic generated by user interactions with FountainAI. For instance, a user request to modify a character’s dialogue triggers a series of API calls between the **Session Context Service**, **Character Management Service**, and **Core Script Management Service**. Kong Gateway ensures that each of these API requests is routed to the correct service, authenticated, and processed efficiently. If one of the services receives too many requests at once, Kong dynamically reroutes traffic to another instance of the service or enforces rate limits to maintain the stability of the entire system.

As FountainAI grows and more users interact with the platform, Kong Gateway ensures that the system remains scalable and secure. Its ability to scale horizontally—by distributing traffic across multiple instances of a service—allows FountainAI to handle increased traffic without compromising performance. At the same time, Kong’s security features protect API traffic, ensuring that only authorized services and users can interact with sensitive narrative elements. With robust **authentication mechanisms** and **access control**, Kong Gateway provides the necessary security framework to safeguard the platform’s APIs.

In conclusion, Kong Gateway plays a pivotal role in ensuring the scalability, security, and efficiency of FountainAI’s API management. Its integration with OpenAPI allows for automated, consistent configuration of API routes and security policies, while its features like rate limiting and load balancing ensure that the platform remains responsive and stable under heavy traffic. As FountainAI continues to evolve, Kong Gateway will remain a critical component in managing the system’s API traffic, ensuring that every user interaction is handled smoothly, securely, and efficiently.

---

### **Conclusive Summary Appendix**

This compilation offers a comprehensive overview of the key technological components that make FountainAI a powerful AI-driven storytelling platform. By examining the architecture, data management, and service interactions, we see how FountainAI achieves real-time narrative fluidity and scalability.

1. **Chapter 1** outlines the overall architecture of FountainAI, with a focus on **Context** as the driving force behind narrative coherence. Modular microservices and **OpenAPI** enable the platform’s scalability and flexibility, ensuring seamless interaction between various services.

2. **Chapter 2** combines the roles of **GPT-generated queries** and **OpenSearch** to demonstrate how real-time storytelling is achieved. The **GPT model** dynamically generates specific queries to retrieve, filter, and reorganize story elements in response to user interactions, while OpenSearch efficiently manages narrative data storage and retrieval, ensuring responsiveness.

3. **Chapter 3** explains the critical role of **Kong Gateway** in managing API traffic between microservices. Kong Gateway ensures security, scalability, and efficient communication, making sure the platform remains responsive to high user demand.

Together, these chapters illustrate how FountainAI’s architecture is designed to scale, adapt, and evolve with user interactions. The interplay of **GPT-driven queries**, **dynamic data storage**, and **Kong Gateway’s** API management enables FountainAI to deliver a storytelling experience that remains coherent, engaging, and immersive. By uniting these components, FountainAI sets the foundation for future expansions, ensuring the platform can evolve alongside the growing demands of interactive storytelling.



# PART B
# A Minimalistic, Hybrid Approach to Infrastructure
> providing a cost-effective, manually controlled, and scalable infrastructure management solution for 
## FountainAI 
> a Scalable, AI-Driven Storytelling Platform
___


## **Abstract**

This part outlines a minimalistic, single-user infrastructure for FountainAI, designed to be affordable while providing full manual control over deployment, scaling, and service management. The infrastructure leverages **AWS Lightsail** to host OpenSearch, Kong (DB-less), and Dockerized applications, controlled via a **FastAPI-based API**. The setup follows a **manual-first control philosophy**, where users manage the infrastructure through API calls rather than fully automated pipelines. A hybrid approach is applied by integrating **GitHub Actions** to automate the building, testing, and pushing of Docker images to **GitHub Container Registry (GHCR)**, while deployments are handled manually via the FastAPI app. This solution ensures cost efficiency, flexibility, and full control over the deployment process.

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

