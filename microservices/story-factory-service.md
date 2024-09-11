```
openapi: 3.1.0
info:
  title: Story Factory API
  description: API for assembling and retrieving complete stories in the FountainAI system, integrated directly with OpenSearch.
  version: 1.0.0
servers:
  - url: https://stories.fountain.coach
    description: FountainAI Story Factory API via Kong Gateway
paths:
  /stories/{scriptId}/_search:
    post:
      summary: Retrieve a complete story
      description: Assembles a complete story by querying and combining related components (characters, actions, spoken words, sections) for a specific script from the OpenSearch index.
      operationId: searchCompleteStory
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose complete story is being assembled.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A complete story
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CompleteStory'
      x-kong-route:
        methods: ['POST']
        paths: ['/stories/{scriptId}/_search']
        service: 'opensearch-service'
  /stories/sections/{sectionId}/_doc:
    get:
      summary: Retrieve a specific section of a story by ID
      description: Retrieves a specific section of a story by its ID from the OpenSearch index.
      operationId: getStorySectionById
      parameters:
        - name: sectionId
          in: path
          required: true
          description: The ID of the section to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: A story section
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/StorySection'
        '404':
          description: Section not found
      x-kong-route:
        methods: ['GET']
        paths: ['/stories/sections/{sectionId}/_doc']
        service: 'opensearch-service'
  /stories/search/_search:
    post:
      summary: Search for stories or story components
      description: Searches for stories or specific story components (like characters, actions, sections) within the OpenSearch index based on provided criteria.
      operationId: searchStoryComponents
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: Search results
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/StoryComponent'
      x-kong-route:
        methods: ['POST']
        paths: ['/stories/search/_search']
        service: 'opensearch-service'
  /stories/orchestration/{scriptId}/_search:
    post:
      summary: Retrieve orchestration data for a script
      description: Retrieves orchestration data (e.g., music, sound cues) linked to a specific script from the OpenSearch index.
      operationId: searchOrchestrationData
      parameters:
        - name: scriptId
          in: path
          required: true
          description: The ID of the script whose orchestration data is being retrieved.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: Orchestration data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrchestrationData'
      x-kong-route:
        methods: ['POST']
        paths: ['/stories/orchestration/{scriptId}/_search']
        service: 'opensearch-service'
components:
  schemas:
    OpenSearchQuery:
      type: object
      properties:
        query:
          type: object
          description: The OpenSearch Query DSL to filter and retrieve data.
    CompleteStory:
      type: object
      properties:
        scriptId:
          type: string
        title:
          type: string
        author:
          type: string
        sections:
          type: array
          items:
            type: object
            properties:
              sectionId:
                type: string
              title:
                type: string
              sequence:
                type: integer
        characters:
          type: array
          items:
            type: object
            properties:
              characterId:
                type: string
              name:
                type: string
              description:
                type: string
        actions:
          type: array
          items:
            type: object
            properties:
              actionId:
                type: string
              description:
                type: string
        spokenWords:
          type: array
          items:
            type: object
            properties:
              dialogueId:
                type: string
              text:
                type: string
    StorySection:
      type: object
      properties:
        sectionId:
          type: string
        title:
          type: string
        sequence:
          type: integer
        content:
          type: string
    StoryComponent:
      type: object
      properties:
        id:
          type: string
        title:
          type: string
        type:
          type: string
        description:
          type: string
    OrchestrationData:
      type: object
      properties:
        orchestrationId:
          type: string
        csoundFilePath:
          type: string
        lilyPondFilePath:
          type: string
        midiFilePath:
          type: string
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
security:
  - ApiKeyAuth: []
```