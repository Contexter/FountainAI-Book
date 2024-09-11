```
openapi: 3.1.0
info:
  title: Central Sequence Service API
  description: API for managing sequence numbers within the FountainAI system, integrated directly with Kong Gateway and Opensearch.
  version: 1.0.0
servers:
  - url: https://central-sequence.fountain.coach
    description: Central Sequence Service API (Kong Gateway)
paths:
  /sequences/_doc:
    post:
      summary: Generate a new sequence number
      description: Generates a new sequence number and stores it in the Opensearch index.
      operationId: createSequence
      requestBody:
        description: Data related to the sequence number to be generated.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SequenceRequest'
      responses:
        '201':
          description: Sequence number created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SequenceResponse'
      x-kong-route:
        methods:
          - POST
        uris: ["/sequences/_doc"]
  /sequences/_search:
    post:
      summary: Retrieve sequence numbers
      description: Queries the Opensearch index to retrieve sequence numbers for specific elements.
      operationId: searchSequences
      requestBody:
        description: The Opensearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SearchRequest'
      responses:
        '200':
          description: A list of sequences
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SearchResponse'
      x-kong-route:
        methods:
          - POST
        uris: ["/sequences/_search"]
  /sequences/_bulk:
    post:
      summary: Reorder sequence numbers
      description: Reorders sequence numbers for elements and updates them in the Opensearch index using bulk operations.
      operationId: reorderSequences
      requestBody:
        description: Bulk data to reorder sequence numbers.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReorderRequest'
      responses:
        '200':
          description: Sequence numbers reordered successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
      x-kong-route:
        methods:
          - POST
        uris: ["/sequences/_bulk"]
  /sequences/_doc/{sequenceId}/_update:
    post:
      summary: Create a new version of a sequence number
      description: Creates a new version of an existing sequence number in the Opensearch index.
      operationId: createSequenceVersion
      parameters:
        - name: sequenceId
          in: path
          required: true
          description: The ID of the sequence whose version is being created.
          schema:
            type: string
      requestBody:
        description: Data related to the new version of the sequence number.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/VersionRequest'
      responses:
        '200':
          description: Sequence version created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SuccessResponse'
      x-kong-route:
        methods:
          - POST
        uris: ["/sequences/_doc/{sequenceId}/_update"]
components:
  schemas:
    SequenceRequest:
      type: object
      properties:
        elementType:
          type: string
          description: Type of the element (e.g., script, section, character, action, spokenWord).
        elementId:
          type: string
          description: Unique identifier of the element.
        sequenceNumber:
          type: integer
          description: The sequence number.
      required: [elementType, elementId]
    SequenceResponse:
      type: object
      properties:
        _id:
          type: string
          description: ID of the created sequence document
        result:
          type: string
          description: "created"
    SearchRequest:
      type: object
      properties:
        query:
          type: object
          description: The query DSL to filter sequences in Opensearch.
    SearchResponse:
      type: array
      items:
        type: object
        properties:
          id:
            type: string
          elementType:
            type: string
          elementId:
            type: string
          sequenceNumber:
            type: integer
    ReorderRequest:
      type: object
      properties:
        elements:
          type: array
          items:
            type: object
            properties:
              elementId:
                type: string
              newSequence:
                type: integer
    VersionRequest:
      type: object
      properties:
        elementType:
          type: string
          description: Type of the element.
        elementId:
          type: string
        versionNumber:
          type: integer
    SuccessResponse:
      type: object
      properties:
        result:
          type: string
          description: success

securitySchemes:
  ApiKeyAuth:
    type: apiKey
    in: header
    name: X-API-Key
security:
  - ApiKeyAuth: []
  ```
