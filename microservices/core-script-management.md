```
openapi: 3.1.0
info:
  title: Core Script Management API
  description: API for managing scripts and their sections in the FountainAI system, integrated directly with OpenSearch.
  version: 1.0.0
servers:
  - url: https://scripts.fountain.coach
    description: FountainAI Core Script Management API via Kong Gateway
paths:
  /scripts/_search:
    post:
      summary: Retrieve all scripts
      description: Queries the OpenSearch index to retrieve all script documents.
      operationId: searchScripts
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of scripts
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Script'
      x-kong-route:
        methods: ['POST']
        paths: ['/scripts/_search']
        service: 'opensearch-service'
  /scripts/_doc:
    post:
      summary: Create a new script
      description: Adds a new script document to the OpenSearch index.
      operationId: createScript
      requestBody:
        description: Script data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ScriptInput'
      responses:
        '201':
          description: Script created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/scripts/_doc']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}:
    get:
      summary: Retrieve a script by ID
      description: Retrieves a specific script document from the OpenSearch index by its ID.
      operationId: getScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Script document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Script'
        '404':
          description: Script not found
      x-kong-route:
        methods: ['GET']
        paths: ['/scripts/_doc/{scriptId}']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}:
    put:
      summary: Update a script by ID
      description: Updates an existing script document in the OpenSearch index.
      operationId: updateScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to update.
          schema:
            type: string
      requestBody:
        description: The new script data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ScriptInput'
      responses:
        '200':
          description: Script updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Script not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/scripts/_doc/{scriptId}']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}:
    delete:
      summary: Delete a script by ID
      description: Deletes a script document from the OpenSearch index by its ID.
      operationId: deleteScriptById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to delete.
          schema:
            type: string
      responses:
        '200':
          description: Script deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Script not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/scripts/_doc/{scriptId}']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}/sections/_search:
    post:
      summary: Retrieve sections of a script
      description: Queries the OpenSearch index for sections linked to a specific script.
      operationId: searchSections
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose sections are being queried.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object for sections.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of sections
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Section'
      x-kong-route:
        methods: ['POST']
        paths: ['/scripts/_doc/{scriptId}/sections/_search']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}/sections/_doc:
    post:
      summary: Create a section for a script
      description: Adds a new section document to the OpenSearch index linked to a specific script.
      operationId: createSection
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script to which the section is linked.
          schema:
            type: string
      requestBody:
        description: Section data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SectionInput'
      responses:
        '201':
          description: Section created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/scripts/_doc/{scriptId}/sections/_doc']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    get:
      summary: Retrieve a section by ID
      description: Retrieves a specific section document from the OpenSearch index by its ID.
      operationId: getSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being retrieved.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Section document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Section'
        '404':
          description: Section not found
      x-kong-route:
        methods: ['GET']
        paths: ['/scripts/_doc/{scriptId}/sections/_doc/{sectionId}']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    put:
      summary: Update a section by ID
      description: Updates an existing section document in the OpenSearch index.
      operationId: updateSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being updated.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to update.
          schema:
            type: string
      requestBody:
        description: The new section data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SectionInput'
      responses:
        '200':
          description: Section updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Section not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/scripts/_doc/{scriptId}/sections/_doc/{sectionId}']
        service: 'opensearch-service'
  /scripts/_doc/{scriptId}/sections/_doc/{sectionId}:
    delete:
      summary: Delete a section by ID
      description: Deletes a section document from the OpenSearch index by its ID.
      operationId: deleteSectionById
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose section is being deleted.
          schema:
            type: string
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to delete.
          schema:
            type: string
      responses:
        '200':
          description: Section deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Section not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/scripts/_doc/{scriptId}/sections/_doc/{sectionId}']
        service: 'opensearch-service'
components:
  schemas:
    Script:
      type: object
      properties:
        id:
          type: string
        title:
          type: string
        author:
          type: string
        description:
          type: string
    ScriptInput:
      type: object
      properties:
        title:
          type: string
          example: "The Great Adventure"
        author:
          type: string
          example: "John Smith"
        description:
          type: string
          example: "An epic tale of adventure."
    Section:
      type: object
      properties:
        sectionId:
          type: string
        title:
          type: string
        sequence:
          type: integer
    SectionInput:
      type: object
      properties:
        title:
          type: string
          example: "Introduction"
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
    UpdateResponse:
      type: object
      properties:
        _id:
          type: string
        result:
          type: string
          example: "updated"
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