```
openapi: 3.1.0
info:
  title: Session and Context Management API
  description: API for managing sessions and contextual data in the FountainAI system, integrated directly with OpenSearch.
  version: 1.0.0
servers:
  - url: https://sessions.fountain.coach
    description: FountainAI Session and Context Management API via Kong Gateway
paths:
  /sessions/_search:
    post:
      summary: Retrieve all sessions
      description: Queries the OpenSearch index to retrieve all session documents.
      operationId: searchSessions
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of sessions
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Session'
      x-kong-route:
        methods: ['POST']
        paths: ['/sessions/_search']
        service: 'opensearch-service'
  /sessions/_doc:
    post:
      summary: Create a new session
      description: Adds a new session document to the OpenSearch index.
      operationId: createSession
      requestBody:
        description: Session data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SessionInput'
      responses:
        '201':
          description: Session created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/sessions/_doc']
        service: 'opensearch-service'
  /sessions/_doc/{sessionId}:
    get:
      summary: Retrieve a session by ID
      description: Retrieves a specific session document from the OpenSearch index by its ID.
      operationId: getSessionById
      parameters:
        - name: sessionId
          in: path
          required: true
          description: The ID of the session to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Session document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Session'
        '404':
          description: Session not found
      x-kong-route:
        methods: ['GET']
        paths: ['/sessions/_doc/{sessionId}']
        service: 'opensearch-service'
  /sessions/_doc/{sessionId}:
    delete:
      summary: Delete a session by ID
      description: Deletes a session document from the OpenSearch index by its ID.
      operationId: deleteSessionById
      parameters:
        - name: sessionId
          in: path
          required: true
          description: The ID of the session to delete.
          schema:
            type: string
      responses:
        '200':
          description: Session deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Session not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/sessions/_doc/{sessionId}']
        service: 'opensearch-service'
  /contexts/_search:
    post:
      summary: Retrieve all contexts
      description: Queries the OpenSearch index to retrieve all context documents.
      operationId: searchContexts
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of contexts
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Context'
      x-kong-route:
        methods: ['POST']
        paths: ['/contexts/_search']
        service: 'opensearch-service'
  /contexts/_doc:
    post:
      summary: Create a new context
      description: Adds a new context document to the OpenSearch index.
      operationId: createContext
      requestBody:
        description: Context data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ContextInput'
      responses:
        '201':
          description: Context created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/contexts/_doc']
        service: 'opensearch-service'
  /contexts/_doc/{contextId}:
    get:
      summary: Retrieve a context by ID
      description: Retrieves a specific context document from the OpenSearch index by its ID.
      operationId: getContextById
      parameters:
        - name: contextId
          in: path
          required: true
          description: The ID of the context to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Context document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Context'
        '404':
          description: Context not found
      x-kong-route:
        methods: ['GET']
        paths: ['/contexts/_doc/{contextId}']
        service: 'opensearch-service'
  /contexts/_doc/{contextId}:
    delete:
      summary: Delete a context by ID
      description: Deletes a context document from the OpenSearch index by its ID.
      operationId: deleteContextById
      parameters:
        - name: contextId
          in: path
          required: true
          description: The ID of the context to delete.
          schema:
            type: string
      responses:
        '200':
          description: Context deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Context not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/contexts/_doc/{contextId}']
        service: 'opensearch-service'
components:
  schemas:
    Session:
      type: object
      properties:
        id:
          type: string
        characterId:
          type: string
        sequence:
          type: integer
    SessionInput:
      type: object
      properties:
        characterId:
          type: string
          example: "abc123"
        sequence:
          type: integer
          example: 1
    Context:
      type: object
      properties:
        id:
          type: string
        characterId:
          type: string
        sequence:
          type: integer
    ContextInput:
      type: object
      properties:
        characterId:
          type: string
          example: "abc123"
        sequence:
          type: integer
          example: 1
    OpenSearchQuery:
      type: object
      properties:
        query:
          type: object
          description: "The OpenSearch Query DSL to filter documents."
    CreateResponse:
      type: object
      properties:
        _id:
          type: string
        result:
          type: string
          example: "created"
    DeleteResponse:
      type: object
      properties:
        _id:
          type: string
        result:
          type: string
          example: "deleted"
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
security:
  - ApiKeyAuth: []
```