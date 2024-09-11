```
openapi: 3.1.0
info:
  title: Character Management API
  description: API for managing characters in the FountainAI system, integrated directly with OpenSearch.
  version: 1.0.0
servers:
  - url: https://characters.fountain.coach
    description: FountainAI Character Management API via Kong Gateway
paths:
  /_search:
    post:
      summary: Retrieve all characters
      description: Queries the OpenSearch index to retrieve all character documents.
      operationId: searchCharacters
      requestBody:
        description: The OpenSearch query object.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of characters
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Character'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_search']
        service: 'opensearch-service'
  /_doc:
    post:
      summary: Create a new character
      description: Adds a new character document to the OpenSearch index.
      operationId: createCharacter
      requestBody:
        description: Character data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CharacterInput'
      responses:
        '201':
          description: Character created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc']
        service: 'opensearch-service'
  /_doc/{characterId}:
    get:
      summary: Retrieve a character by ID
      description: Retrieves a specific character document from the OpenSearch index by its ID.
      operationId: getCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Character document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Character'
        '404':
          description: Character not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}']
        service: 'opensearch-service'
  /_doc/{characterId}:
    put:
      summary: Update a character by ID
      description: Updates an existing character document in the OpenSearch index.
      operationId: updateCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to update.
          schema:
            type: string
      requestBody:
        description: The new character data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CharacterInput'
      responses:
        '200':
          description: Character updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Character not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}']
        service: 'opensearch-service'
  /_doc/{characterId}:
    delete:
      summary: Delete a character by ID
      description: Deletes a character document from the OpenSearch index by its ID.
      operationId: deleteCharacterById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to delete.
          schema:
            type: string
      responses:
        '200':
          description: Character deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Character not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}']
        service: 'opensearch-service'
  /_doc/{characterId}/paraphrases/_search:
    post:
      summary: Retrieve paraphrases for a character
      description: Queries the OpenSearch index for paraphrases linked to a specific character.
      operationId: searchParaphrases
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrases are being queried.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object for paraphrases.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of paraphrases
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Paraphrase'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/paraphrases/_search']
        service: 'opensearch-service'
  /_doc/{characterId}/paraphrases/_doc:
    post:
      summary: Create a paraphrase for a character
      description: Adds a new paraphrase document to the OpenSearch index linked to a specific character.
      operationId: createParaphrase
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the paraphrase is linked.
          schema:
            type: string
      requestBody:
        description: Paraphrase data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ParaphraseInput'
      responses:
        '201':
          description: Paraphrase created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/paraphrases/_doc']
        service: 'opensearch-service'
  /_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    get:
      summary: Retrieve a paraphrase by ID
      description: Retrieves a specific paraphrase document from the OpenSearch index by its ID.
      operationId: getParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being retrieved.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Paraphrase document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Paraphrase'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'
  /_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    put:
      summary: Update a paraphrase by ID
      description: Updates an existing paraphrase document in the OpenSearch index.
      operationId: updateParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being updated.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to update.
          schema:
            type: string
      requestBody:
        description: The new paraphrase data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ParaphraseInput'
      responses:
        '200':
          description: Paraphrase updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'
  /_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
    delete:
      summary: Delete a paraphrase by ID
      description: Deletes a paraphrase document from the OpenSearch index by its ID.
      operationId: deleteParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose paraphrase is being deleted.
          schema:
            type: string
        - name: paraphraseId
          in: path
          required: true
          description: The ID of the paraphrase to delete.
          schema:
            type: string
      responses:
        '200':
          description: Paraphrase deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'
components:
  schemas:
    Character:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        description:
          type: string
    CharacterInput:
      type: object
      properties:
        name:
          type: string
          example: "John Doe"
        description:
          type: string
          example: "A brave warrior"
    Paraphrase:
      type: object
      properties:
        paraphraseId:
          type: string
        text:
          type: string
        commentary:
          type: string
    ParaphraseInput:
      type: object
      properties:
        text:
          type: string
          example: "A wise saying"
        commentary:
          type: string
          example: "Commentary on the paraphrase"
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