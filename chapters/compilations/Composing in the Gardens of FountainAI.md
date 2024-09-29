# **Composing in the Gardens of FountainAI**
> OpenAPI Composability in FountainAI: A GPT Prompt for FastAPI App Generation



# **Introduction: The Process of OpenAPI to FastAPI and Kong**

The **FountainAI** infrastructure is designed to handle dynamic, interactive storytelling by building APIs around **manually written OpenAPI documents**. These documents serve as the blueprints for structuring, managing, and securing the APIs, and are used to generate **FastAPI apps** via a **GPT prompt**. The **FastAPI apps** must strictly follow the **OpenAPI specification** and output an OpenAPI schema that matches the initial input.

Once generated, **Kong API Gateway** takes over the broader management of traffic control, security, and routing, operating in **db-less mode**, with all configurations declared via **decK**. These configurations assign API services to specific subdomains under the **fountain.coach** domain, and traffic routing is handled by **AWS Route 53**. This setup ensures both flexibility and scalability for each subdomain and corresponding API.

For a more in-depth view of **FountainAI's OpenAPI specifications**, you can explore the **FountainAI OpenAPIs** [here](https://github.com/Contexter/FountainAI-API-Docs/tree/gh-pages/openAPI-Yaml).

---

# **Traffic Routing and Security with AWS Route 53 and Let's Encrypt**

In **FountainAI**, routing for API services is managed through **AWS Route 53**, which maps subdomains like `character.fountain.coach` to their corresponding API services. Once the request is directed through Route 53, it reaches the **Kong Gateway**, where it is routed based on the configurations defined in **kong.yml**.

## **TLS/SSL Certificates with Let's Encrypt**

To ensure secure communication between the API services and clients, **Let's Encrypt** is used for issuing SSL/TLS certificates. This is handled via the **Kong Let's Encrypt plugin**, which automatically provisions and renews certificates for subdomains. By utilizing **HTTPS**, all traffic between the clients and the API services is encrypted, ensuring the protection of sensitive data.

The Kong Let's Encrypt plugin ensures that the SSL certificates are continuously managed without manual intervention, providing seamless encryption for API communications across all **fountain.coach** subdomains.

---

# **Request Routing with Kong API Gateway**

**Kong Gateway** plays a central role in managing traffic and routing API requests in **FountainAI**. Kong operates in **db-less mode**, meaning that all of its configurations are declarative and stored in a single **kong.yml** file. Kong routes requests based on the assigned subdomains, such as `character.fountain.coach`, which are mapped through **AWS Route 53**.

## **Declarative Kong Configuration (kong.yml)**

```yaml
_format_version: "2.1"
services:
  - name: character-api
    url: http://redis-upstream-service
    routes:
      - name: character-route
        hosts:
          - character.fountain.coach

  - name: script-api
    url: http://redis-upstream-service
    routes:
      - name: script-route
        hosts:
          - script.fountain.coach
```

This configuration enables **Kong Gateway** to receive requests at `character.fountain.coach`, which are then forwarded to Redis as the upstream service. Redis checks for any cached responses and returns them directly, without needing to reprocess the request through FastAPI, which has no interaction with Redis. Kong manages the entire process of routing and caching.

Kong also allows for the application of various **plugins**, such as **rate-limiting**, ensuring that the system can handle heavy traffic while maintaining high performance and security.

---

# **Redis Caching and Persistence**

In the **FountainAI** architecture, **Redis** plays a key role by providing caching for API responses. By caching frequently accessed data, Redis reduces the load on the backend services and ensures faster response times for repeat requests. This is particularly useful for high-traffic APIs like the **Character Management API**.

Redis is configured with **Append-Only File (AOF) persistence** to ensure that all cached data can be recovered in the event of a system restart. This level of persistence ensures that API responses remain durable and available, even after system downtimes.

It is important to note that **FastAPI** is not responsible for managing Redis or interacting with the cache directly. The **Kong Gateway** forwards requests to Redis as the upstream service to retrieve cached responses. FastAPI only handles API logic, while Redis handles caching independently, managed by Kong.

## **Redis Configuration in Docker Compose**

```yaml
redis:
  image: redis:latest
  command: redis-server --appendonly yes
  volumes:
    - redis-data:/data
  ports:
    - "6379:6379"
```

In this setup:
- **Kong Gateway** routes requests to **Redis** as the upstream service.
- Redis stores the API responses for future requests, allowing for quick retrieval of cached data, without needing to interact with FastAPI beyond the initial response processing.

---

# **Manual Composition of OpenAPI Documents**

The process of creating the APIs in FountainAI starts with **handwritten OpenAPI documents**. These documents define all aspects of the API, from paths and methods to security mechanisms and response types. A key focus of the OpenAPI document is ensuring clarity and adherence to best practices, allowing seamless integration with the FastAPI app generation process.

## **The Three Pillars of an Expressive OpenAPI Document**

1. **OperationID**: A unique identifier for each API operation that ensures consistency and precision when routing and documenting operations.
2. **Summary**: A concise, one-line description summarizing the function of each API endpoint.
3. **Description**: A more detailed explanation (up to 300 characters) that provides clarity about what each API operation does, designed to help both developers and API consumers understand the purpose of the operation.

### **Example: Character Management API (Handwritten OpenAPI)**

The following example demonstrates a **handwritten OpenAPI document** for the **Character Management API**:

```yaml
openapi: 3.1.0
info:
  title: Character Management API
  description: >
    This API handles characters within screenplays, including their creation, management, actions, and spoken words.
  version: 1.0.0
servers:
  - url: https://character.fountain.coach
    description: Production server for Character Management API
paths:
  /characters:
    get:
      summary: Retrieve All Characters
      operationId: listCharacters
      description: Lists all characters stored within the application.
      responses:
        '200':
          description: A JSON array of character entities.
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Character'
    post:
      summary: Create a New Character
      operationId: createCharacter
      description: Allows for the creation of a new character.
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CharacterCreateRequest'
      responses:
        '201':
          description: Character successfully created, returning the new character entity.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Character'
        '400':
          description: Bad request due to invalid input data.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
```

---

# **Using a GPT Prompt to Generate the FastAPI App**

Once the OpenAPI document is manually composed, the next step is to **generate a FastAPI app** based on that OpenAPI specification. This process is handled through a **GPT prompt** that instructs the model to generate a FastAPI app adhering to the exact structure and rules defined in the OpenAPI document. The generated FastAPI app must implement the routes, methods, security, and validation mechanisms as specified.

## **GPT Prompt for Generating a FastAPI App**

Here is the full prompt that is used to instruct the model to generate a FastAPI app from an OpenAPI document:

> You are tasked with generating a FastAPI app based on a provided OpenAPI document. The FastAPI app must implement the exact routes, operations, and security mechanisms as described in the OpenAPI document. The app should also automatically generate an OpenAPI schema that exactly matches the provided input. Additionally, the following requirements must be adhered to:
>
> 1. **OperationID**: Each route must use the exact OperationID specified in the OpenAPI document as the function name or identifier in FastAPI.
> 2. **Summary**: The provided summary for each operation should be used as the concise description for each FastAPI route.
> 3. **Description**: Descriptions must be included both in the code comments and in the auto-generated OpenAPI schema. The descriptions should match the input text exactly, and they must not exceed 300 characters.
> 4. **Request and Response Validation**: The FastAPI app should validate incoming requests based on the schemas provided in the OpenAPI document. Likewise, responses should follow the OpenAPI specifications.
> 5. **Security**: The app must implement any security mechanisms defined in the OpenAPI document (e.g., API key validation).
> 6. **Exact Matching Requirement**: The output OpenAPI schema, generated at `/openapi.json`, must match the input schema exactly, with no deviations allowed.

---

# **Declarative and Modular Deployment with Docker Compose**

The deployment of the **FountainAI** infrastructure is handled through **Docker Compose**, which allows for a modular and scalable architecture. Docker Compose ensures that **Kong Gateway**, **Redis**, and all associated services are containerized, making them easy to manage and scale.

## **Docker Compose Configuration for Kong and Redis**

```yaml
version: '3.8'

services:
  kong:
    image: kong
    environment:
      KONG_DATABASE: "off"  # db-less mode
      KONG_DECLARATIVE_CONFIG: /kong.yml
      KONG_PROXY_CACHE_REDIS_HOST: redis
    volumes:
      - ./kong.yml:/kong.yml
    ports:
      - "8000:8000"
      - "8443:8443"  # HTTPS
    networks:
      - kong-net

  redis:
    image: redis:latest
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"
    networks:
      - kong-net

networks:
  kong-net:
    driver: bridge

volumes:
  redis-data:
    driver: local
```

This setup ensures:
- **Kong Gateway** operates in **db-less mode**, with configurations stored in the `kong.yml` file.
- **Redis** handles upstream service caching, ensuring fast retrieval of frequently requested API data.
- All components are easily scalable and maintainable through **Docker Compose**.

---

# **Conclusion: Orchestrating API Proxies with FountainAI**

The **FountainAI** infrastructure uses a combination of **handwritten OpenAPI documents**, **FastAPI app generation**, **Kong Gateway** for routing, and **Redis** for caching and persistence. Together, these components form a robust, scalable system that enables efficient and dynamic API management for interactive storytelling experiences.

By incorporating **AWS Route 53** for subdomain routing and **Let's Encrypt** for SSL provisioning, the infrastructure ensures secure, high-performance API management under the **fountain.coach** domain. This declarative and modular setup provides the necessary scalability and flexibility to support the evolving demands of the **FountainAI** platform.

---

# **Composing the Architecture of FountainAI**
> A GoF Design Pattern Perspective 

## **Abstract**

Here we explore the architecture of **FountainAI** through the lens of **Gang of Four (GoF)** design patterns. We detail how **FastAPI**, **Kong Gateway**, and **Redis** interact to provide a scalable, modular, and efficient infrastructure for handling dynamic API requests. Special emphasis is placed on clarifying the roles of each component, particularly the way **Kong Gateway** serves as the central orchestrator, handling traffic control, security, caching, and request validation, while **FastAPI** enforces routing rules defined by **OpenAPI specifications**. The paper also examines the request flow through **FountainAI**, highlighting key GoF patterns such as **Facade**, **Decorator**, **Chain of Responsibility**, **Factory Method**, and **Observer**.

---

# **1. Introduction**

In modern API-driven architectures, ensuring that systems are modular, scalable, and maintainable is critical. **FountainAI** exemplifies such an architecture, composed of a set of services designed to manage interactive storytelling experiences via APIs. The system is composed of **FastAPI** for routing, **Kong Gateway** for traffic management and caching, and **Redis** for efficient caching.

This paper dissects the **FountainAI** architecture using classic **Gang of Four** (GoF) design patterns, demonstrating how each pattern plays a key role in enabling the system to handle API requests efficiently. 

---

# **2. Key System Components**

## **2.1 FastAPI**

**FastAPI** is a modern web framework for building APIs, enforcing routing and adherence to the **OpenAPI specification**. In **FountainAI**, FastAPI serves as the **entry and exit point** for requests, enforcing structure and ensuring that the API routes conform to defined schemas. However, **FastAPI** is a pass-through mechanism that doesn't handle caching, validation, or any heavy processing—these tasks are delegated to **Kong Gateway**.

## **2.2 Kong Gateway**

**Kong Gateway** is the central component of the **FountainAI** architecture. It handles **traffic control**, **rate-limiting**, **security**, **request validation**, and **caching**. Kong abstracts away the complexity of interacting with **Redis** for caching, serving as the central orchestrator of all request-related operations.

## **2.3 Redis**

**Redis** is used as a **caching layer** in the system, storing frequently requested data and enhancing the performance of **FountainAI** by reducing the need to repeatedly forward requests to **FastAPI** or the upstream services. **Kong Gateway** interacts directly with **Redis** to check for cached responses and retrieve them when available.

---

# **3. Gang of Four Design Patterns in FountainAI**

## **3.1 Factory Method Pattern**

The **Factory Method Pattern** is employed in **FountainAI** when generating **FastAPI apps** from **OpenAPI specifications**. The OpenAPI specification defines the structure and routing for the API, while the **Factory Method** (through GPT-based prompts) creates a FastAPI app that adheres to the specification. FastAPI’s role is limited to enforcing routing rules and does not extend into handling business logic or validation.

- **How It Works**: The **OpenAPI specification** is used as a blueprint, and the **Factory Method** generates a corresponding FastAPI app. FastAPI ensures that the request follows the correct routing rules, forwarding the request to **Kong Gateway** for further processing.
  
- **Benefit**: This pattern ensures that FastAPI apps are consistently generated according to the defined API schema, providing a standardized interface for handling API requests without introducing processing complexity.

---

## **3.2 Facade Pattern**

The **Facade Pattern** is central to **Kong Gateway's** role in **FountainAI**. **Kong Gateway** abstracts the complexity of managing caching, validation, security, and traffic control, simplifying the interaction for clients. While **FastAPI** serves as the entry point, **Kong Gateway** performs the majority of the operations behind the scenes.

- **How It Works**: Clients interact with **FastAPI**, which routes the request to **Kong Gateway**. **Kong** handles traffic management, rate-limiting, security enforcement, and caching, presenting a simplified interface to the client. Kong abstracts away interactions with Redis, security rules, and other internal complexities.

- **Benefit**: By implementing the **Facade Pattern**, **Kong Gateway** allows external clients to interact with the system through a simple interface, while handling complex internal logic, including cache checks and security management.

---

## **3.3 Decorator Pattern**

**Redis** in **FountainAI** implements the **Decorator Pattern**, enhancing the request-response flow by adding caching functionality. **Kong Gateway** interacts directly with **Redis** to check for cached data before forwarding a request to **FastAPI**. On cache hits, the request is served directly from Redis, bypassing the need to reprocess the request through **FastAPI**.

- **How It Works**: When a request enters **Kong Gateway**, it checks **Redis** for cached responses. If the requested data is cached, **Kong Gateway** serves it from **Redis** without invoking **FastAPI**. If no cached data is available, **Kong** forwards the request to **FastAPI**, processes the response, and caches the result for future use.

- **Benefit**: The **Decorator Pattern** improves system performance by caching responses and serving frequently requested data without unnecessary reprocessing. This reduces the load on **FastAPI** and enhances response times for clients.

---

## **3.4 Chain of Responsibility Pattern**

The **Chain of Responsibility Pattern** is used within **Kong Gateway's** plugin architecture. Each request passes through a series of plugins that handle different aspects of request management, such as **rate-limiting**, **SSL verification**, and **checking Redis for cached responses**. Each plugin

 processes or modifies the request as needed before it is passed to the next handler.

- **How It Works**: A request entering **Kong Gateway** moves through various plugins, each responsible for a specific task (e.g., rate-limiting, security validation, cache checks). Each plugin processes the request based on its configuration, and the request is either served from the cache or forwarded for further processing.

- **Benefit**: The **Chain of Responsibility Pattern** enables modular and flexible request handling, allowing for the dynamic processing of requests based on the needs of each stage in the chain.

---

## **3.5 Observer Pattern**

**Kong Gateway** implements the **Observer Pattern** by monitoring configuration changes and SSL certificate updates. **Kong Gateway** dynamically applies changes to its traffic rules, rate limits, and security settings based on updates to its **declarative configuration** (via **decK**) or automatic SSL certificate renewals from **Let's Encrypt**.

- **How It Works**: **Kong Gateway** observes changes in its configuration or SSL certificates and applies these changes in real-time, without requiring manual intervention. This ensures that the system is always secure and up to date.

- **Benefit**: The **Observer Pattern** allows **Kong Gateway** to dynamically adapt to changes in configuration and security settings, maintaining system integrity and reducing downtime.

---

# **4. Flow of Requests in FountainAI**

Here is the detailed flow of requests through **FountainAI**, highlighting the use of **GoF design patterns** at each stage.

## **4.1 Request Entry via FastAPI (Factory Method Pattern)**
   - The client sends a request to **FastAPI**, which enforces the routing structure defined by the **OpenAPI specification**. **FastAPI** does not perform validation or processing but ensures that the request conforms to the correct route. The request is forwarded to **Kong Gateway**.

## **4.2 Kong Gateway (Facade Pattern)**
   - Once the request reaches **Kong Gateway**, it abstracts the complexity of managing traffic, caching, and validation. **Kong** handles the lifecycle of the request from this point, forwarding it to **Redis** for a cache check and applying various plugins to manage rate-limiting, security, and more.

## **4.3 Kong Plugin Chain (Chain of Responsibility Pattern)**
   - As the request moves through **Kong**, it is processed by multiple plugins that handle different tasks such as **rate-limiting**, **SSL validation**, and **checking Redis** for cached responses. Each plugin processes the request as per the system’s configuration.

## **4.4 Redis Caching (Decorator Pattern)**
   - **Kong Gateway** checks **Redis** for cached responses. If the requested data is found in the cache, **Kong Gateway** retrieves it from Redis and bypasses **FastAPI** entirely. If no cache is found, the request is forwarded to **FastAPI** for further processing, and the result is cached for future requests.

## **4.5 Response Delivery via FastAPI**
   - Once **Kong Gateway** processes the request or retrieves the cached response, the data is passed back through **FastAPI** and delivered to the client. **FastAPI** serves as the exit point, ensuring that the response follows the correct API route.

---

# **5. Conclusion**

The **FountainAI** architecture, powered by **FastAPI**, **Kong Gateway**, and **Redis**, is an excellent example of how **GoF design patterns** can be applied to build a scalable, modular, and efficient API-driven system. **FastAPI** serves as a lightweight entry and exit point for routing, while **Kong Gateway** handles the heavy lifting of traffic control, security, and caching, and **Redis** provides enhanced performance through caching.

Key design patterns, including the **Facade Pattern**, **Decorator Pattern**, **Factory Method**, **Chain of Responsibility**, and **Observer Pattern**, enable **FountainAI** to process requests dynamically, ensure fast responses, and maintain high security and flexibility. These patterns ensure that **FountainAI** can manage the complexities of dynamic storytelling APIs with ease, efficiency, and maintainability.

