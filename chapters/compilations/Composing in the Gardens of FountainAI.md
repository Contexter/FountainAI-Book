# Composing in the Gardens of FountainAI
> OpenAPI Composability in FountainAI: A GPT Prompt for FastAPI App Generation 

---

## **Introduction: The Process of OpenAPI to FastAPI and Kong**

In the **FountainAI** infrastructure, handling API requests is built upon **manually written OpenAPI documents** that serve as blueprints for defining the structure, behavior, and security mechanisms of the API. These **OpenAPI documents** are used to generate **FastAPI apps** through a GPT model, ensuring that the FastAPI app not only implements the given OpenAPI specification but also outputs an **OpenAPI schema** that **exactly matches** the original input.

Once the FastAPI app is generated, **Kong API Gateway** manages broader aspects such as traffic control, security enforcement, and routing, ensuring a robust and scalable infrastructure.

The goal of this paper is to present the process of manually composing expressive OpenAPI documents, generating a FastAPI app through a GPT prompt, and integrating this process with **Kong** for a fully composable and scalable API system.

---

## **Step 1: Manual Composition of OpenAPI Documents**

The foundation of the system begins with manually composing an **OpenAPI document** that defines the API's paths, methods, request bodies, responses, and security mechanisms. In FountainAI, these documents are written to follow the principles of expressiveness, ensuring clarity and adherence to linting standards.

### **Three Pillars of Expressive OpenAPI Documents**
1. **OperationID**: A unique identifier for each API operation that ensures consistency in routing and documentation.
2. **Summary**: A concise, one-line description of what each API operation does.
3. **Description**: A detailed explanation of the operation (up to 300 characters) that clarifies its purpose for API consumers.

### **Example: Character Management API (Handwritten OpenAPI)**

Below is an example of an **expressive OpenAPI document** for the **Character Management API** in FountainAI, which handles the creation, retrieval, and management of characters within screenplays:

```yaml
openapi: 3.1.0
info:
  title: Character Management API
  description: >
    This API handles characters within screenplays, including their creation, management, actions, and spoken words. It integrates with the Central Sequence Service to ensure logical sequence numbers for each element, allowing a coherent flow within the story.
  version: 1.0.0
servers:
  - url: https://character.fountain.coach
    description: Production server for Character Management API
  - url: http://localhost:8080
    description: Development server
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
        '500':
          description: Internal server error indicating a failure to process the request.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
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
        '500':
          description: Internal server error indicating a failure in creating the character.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
# Additional paths omitted for brevity
```

You can explore more **FountainAI OpenAPIs** here:  
[**FountainAI OpenAPIs**](https://github.com/Contexter/FountainAI-API-Docs/tree/gh-pages/openAPI-Yaml)

---

## **Step 2: Using a GPT Prompt to Generate the FastAPI App**

After the OpenAPI document is manually composed, the next step is to use a **GPT prompt** to generate a **FastAPI app** that implements the OpenAPI specification. The generated FastAPI app must implement the routes, methods, and security mechanisms exactly as defined, and it must also generate an **OpenAPI schema** that **exactly matches** the input OpenAPI document.

### **Comprehensive GPT Prompt for FastAPI App Generation**

---

**[START OF GPT PROMPT]**

You are tasked with generating a **FastAPI app** based on a provided **OpenAPI document**. The FastAPI app must implement the exact routes, operations, and security mechanisms as described in the OpenAPI document, and it must generate an OpenAPI schema that **exactly matches** the provided input.

### **Instructions**:

1. **OperationID**: Every route in the app must use the exact **OperationID** specified in the OpenAPI document. This OperationID should be used as a function name or a route identifier in the FastAPI code.

2. **Summary**: Include the provided **Summary** for each operation. This serves as a concise one-liner describing the purpose of the route. The Summary should be included in both the route definition and the OpenAPI output.

3. **Description**: The **Description** must be included as inline documentation within the FastAPI code and in the generated OpenAPI schema. The description should **strictly adhere to the input**, and must not exceed 300 characters. This description will appear in the auto-generated OpenAPI output, and it should be identical to the input.

4. **Request and Response Schemas**: Ensure that all request bodies, response bodies, and parameters are implemented in the FastAPI app exactly as defined in the OpenAPI document. The FastAPI app must validate incoming requests based on the defined schemas and return responses in the exact format defined by the OpenAPI document.

5. **Security**: Implement API key security as described in the OpenAPI document. Every route that requires security must enforce the presence of a valid **X-API-Key** in the header. Ensure that security mechanisms are also reflected in the generated OpenAPI output.

6. **Auto-Generated OpenAPI Output**:
    - Ensure that the FastAPI app automatically generates an **OpenAPI schema** at `/openapi.json` and `/docs`.
    - The **generated OpenAPI schema** must be **identical** to the input OpenAPI document.
    - The input OpenAPI document will be compared with the output OpenAPI schema to ensure they match exactly, including all paths, methods, parameters, and security definitions.

7. **Exact Matching Requirement**:
    - **No deviations** are allowed between the input and output OpenAPI schema.
    - The generated OpenAPI output must include the same **OperationIDs**, **Summaries**, **Descriptions**, **Request/Response Schemas**, and **Security definitions** as the input.
    - If there are any discrepancies between the input and output OpenAPI documents, the FastAPI app implementation will be considered incorrect.

---

**[END OF GPT PROMPT]**

---

### Key Instructions in the Prompt:

- **OperationID**, **Summary**, and **Description**: These must be exactly reflected in both the generated FastAPI routes and the OpenAPI schema output.
- **Request/Response Schemas**: Requests and responses in the FastAPI app must adhere strictly to the input OpenAPI definitions.
- **Security**: Security mechanisms like API key validation must be enforced as per the OpenAPI specification.
- **Exact OpenAPI Matching**: The output OpenAPI document generated by FastAPI must be identical to the input OpenAPI document, ensuring there is no discrepancy between what was provided and what the FastAPI app outputs.

---

## **Step 3: Request Flow in the FastAPI App and Kong Integration**

### **FastAPI App Request Handling**

Once the FastAPI app is generated, it becomes the **primary handler** of client requests. Each request is processed by the FastAPI app, which:
1. **Receives the request** based on the path and method defined in the OpenAPI document.
2. **Validates inputs**: The FastAPI app checks that the request conforms to the specifications laid out in the OpenAPI document (e.g., required parameters, payload structure).
3. **Processes the request**: The app performs the required operations, potentially interacting with external services or processing data internally.
4. **Generates a response**: The app returns the appropriate response to the client, as specified by the OpenAPI document.

### **Kong API Gateway**

After the FastAPI app processes a request, **Kong API Gateway** handles traffic control and security. Kong’s responsibilities include:
- **Routing**: Directing traffic to upstream services if required.
- **Security enforcement**: Applying additional security policies such as rate-limiting, logging, or further authorization.
- **Scaling**: Managing load distribution and traffic balancing based on demand.

Kong complements the FastAPI app by ensuring robust traffic management, while the FastAPI app focuses on implementing the API itself.

---

## **Step 4: Transforming OpenAPI into Kong Configuration Using decK**

Once the FastAPI app is validated, the **OpenAPI document** is transformed into

 **Kong’s declarative configuration** using **decK**. This step ensures that Kong manages:
- **Traffic routing**: Managing which upstream services requests are routed to.
- **Security policies**: Enforcing API security mechanisms such as authentication and rate-limiting.
- **Traffic scaling**: Managing load balancing and traffic distribution.

### **Using decK in a CI/CD Pipeline**:

1. **Fetch the OpenAPI Document** from FastAPI:
   - The pipeline automatically fetches the **OpenAPI schema** from the FastAPI app at `/openapi.json`.
   
   Example:
   ```bash
   curl http://your-fastapi-app/openapi.json -o openapi.json
   ```

2. **Parse the OpenAPI** and convert it to **Kong declarative YAML**. You can write a custom script or use decK to process the document.

3. **Push the Configuration to Kong** using **decK**:
   - Once the configuration file is generated, **decK** can be used to push the configuration to **Kong Gateway**.

   Example:
   ```bash
   deck sync --config kong.yml
   ```

By converting the OpenAPI document into Kong’s configuration, the system ensures that the **FastAPI app** and **Kong** work together seamlessly to handle all aspects of the API’s lifecycle.

---

## **Conclusion: Orchestrating FastAPI Proxies in the Gardens of FountainAI**

In **FountainAI**, the process of handling API requests starts with the **manual composition of OpenAPI documents**, which are then used to generate **FastAPI apps** via concise GPT prompts. These apps implement the full API specification, ensuring compliance with the OpenAPI document for request validation, processing, and response generation.

Once the FastAPI app is deployed, **Kong API Gateway** takes over broader traffic management, security enforcement, and scalability concerns, ensuring that the system can handle traffic efficiently and securely.

By validating that the generated FastAPI app matches the input OpenAPI document and transforming the OpenAPI into **Kong’s declarative configuration** using **decK**, the system maintains composability, scalability, and consistency across all API operations.
