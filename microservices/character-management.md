```
openapi: 3.1.0
info:
  title: Character Management API
  description: API for managing characters, dialogues, actions, and paraphrases in the FountainAI system, integrated directly with OpenSearch.
  version: 1.0.0
servers:
  - url: https://characters.fountain.coach
    description: FountainAI Character Management API via Kong Gateway
paths:
  # Character-related endpoints
  /characters/_search:
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

  /characters/_doc:
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

  /characters/_doc/{characterId}:
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

  /characters/_doc/{characterId}:
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

  /characters/_doc/{characterId}:
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

  # Paraphrase-related endpoints for characters
  /characters/_doc/{characterId}/paraphrases/_search:
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

  /characters/_doc/{characterId}/paraphrases/_doc:
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

  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
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

  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
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

  /characters/_doc/{characterId}/paraphrases/_doc/{paraphraseId}:
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

  # Action-related endpoints for characters
  /characters/_doc/{characterId}/actions/_search:
    post:
      summary: Retrieve actions for a character
      description: Queries the OpenSearch index for actions linked to a specific character.
      operationId: searchActions
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose actions are being queried.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object for actions.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of actions
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Action'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/actions/_search']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/_doc:
    post:
      summary: Create an action for a character
      description: Adds a new action document to the OpenSearch index linked to a specific character.
      operationId: createAction
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the action is linked.
          schema:
            type: string
      requestBody:
        description: Action data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ActionInput'
      responses:
        '201':
          description: Action created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/actions/_doc']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/_doc/{actionId}:
    get:
      summary: Retrieve an action by ID
      description: Retrieves a specific action document from the OpenSearch index by its ID.
      operationId: getActionById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action is being retrieved.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Action document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Action'
        '404':
          description: Action not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}/actions/_doc/{actionId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/_doc/{actionId}:
    put:
      summary: Update an action by ID
      description: Updates an existing action document in the OpenSearch index.
      operationId: updateActionById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action is being updated.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action to update.
          schema:
            type: string
      requestBody:
        description: The new action data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ActionInput'
      responses:
        '200':
          description: Action updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Action not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}/actions/_doc/{actionId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/_doc/{actionId}:
    delete:
      summary: Delete an action by ID
      description: Deletes an action document from the OpenSearch index by its ID.
      operationId: deleteActionById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action is being deleted.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action to delete.
          schema:
            type: string
      responses:
        '200':
          description: Action deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Action not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}/actions/_doc/{actionId}']
        service: 'opensearch-service'

  # Paraphrase-related endpoints for actions
  /characters/_doc/{characterId}/actions/{actionId}/paraphrases/_search:
    post:
      summary: Retrieve paraphrases for an action
      description: Queries the OpenSearch index for paraphrases linked to a specific action.
      operationId: searchActionParaphrases
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action paraphrases are being queried.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action whose paraphrases are being queried.
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
          description: A list of action paraphrases
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Paraphrase'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/actions/{actionId}/paraphrases/_search']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc:
    post:
      summary: Create a paraphrase for an action
      description: Adds a new paraphrase document to the OpenSearch index linked to a specific action.
      operationId: createActionParaphrase
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the action paraphrase is linked.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action to which the paraphrase is linked.
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
          description: Action paraphrase created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}:
    get:
      summary: Retrieve an action paraphrase by ID
      description: Retrieves a specific paraphrase document from the OpenSearch index linked to an action by its ID.
      operationId: getActionParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action paraphrase is being retrieved.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action whose paraphrase is being retrieved.
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
          description: Action paraphrase document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Paraphrase'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}:
    put:
      summary: Update an action paraphrase by ID
      description: Updates an existing paraphrase document in the OpenSearch index linked to a specific action.
      operationId: updateActionParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action paraphrase is being updated.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action whose paraphrase is being updated.
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
          description: Action paraphrase updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}:
    delete:
      summary: Delete an action paraphrase by ID
      description: Deletes an action paraphrase document from the OpenSearch index by its ID.
      operationId: deleteActionParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose action paraphrase is being deleted.
          schema:
            type: string
        - name: actionId
          in: path
          required: true
          description: The ID of the action whose paraphrase is being deleted.
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
          description: Action paraphrase deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}/actions/{actionId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'

  # Dialogue-related endpoints for characters
  /characters/_doc/{characterId}/dialogues/_search:
    post:
      summary: Retrieve dialogues for a character
      description: Queries the OpenSearch index for dialogues linked to a specific character.
      operationId: searchDialogues
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogues are being queried.
          schema:
            type: string
      requestBody:
        description: The OpenSearch query object for dialogues.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OpenSearchQuery'
      responses:
        '200':
          description: A list of dialogues
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Dialogue'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/dialogues/_search']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/_doc:
    post:
      summary: Create a dialogue for a character
      description: Adds a new dialogue document to the OpenSearch index linked to a specific character.
      operationId: createDialogue
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the dialogue is linked.
          schema:
            type: string
      requestBody:
        description: Dialogue data to be added.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DialogueInput'
      responses:
        '201':
          description: Dialogue created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/dialogues/_doc']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/_doc/{dialogueId}:
    get:
      summary: Retrieve a dialogue by ID
      description: Retrieves a specific dialogue document from the OpenSearch index by its ID.
      operationId: getDialogueById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue is being retrieved.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue to retrieve.
          schema:
            type: string
      responses:
        '200':
          description: Dialogue document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Dialogue'
        '404':
          description: Dialogue not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}/dialogues/_doc/{dialogueId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/_doc/{dialogueId}:
    put:
      summary: Update a dialogue by ID
      description: Updates an existing dialogue document in the OpenSearch index.
      operationId: updateDialogueById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue is being updated.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue to update.
          schema:
            type: string
      requestBody:
        description: The new dialogue data.
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DialogueInput'
      responses:
        '200':
          description: Dialogue updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Dialogue not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}/dialogues/_doc/{dialogueId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/_doc/{dialogueId}:
    delete:
      summary: Delete a dialogue by ID
      description: Deletes a dialogue document from the OpenSearch index by its ID.
      operationId: deleteDialogueById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue is being deleted.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue to delete.
          schema:
            type: string
      responses:
        '200':
          description: Dialogue deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Dialogue not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}/dialogues/_doc/{dialogueId}']
        service: 'opensearch-service'

  # Paraphrase-related endpoints for dialogues
  /characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_search:
    post:
      summary: Retrieve paraphrases for a dialogue
      description: Queries the OpenSearch index for paraphrases linked to a specific dialogue.
      operationId: searchDialogueParaphrases
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue paraphrases are being queried.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue whose paraphrases are being queried.
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
          description: A list of dialogue paraphrases
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Paraphrase'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_search']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc:
    post:
      summary: Create a paraphrase for a dialogue
      description: Adds a new paraphrase document to the OpenSearch index linked to a specific dialogue.
      operationId: createDialogueParaphrase
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character to which the dialogue paraphrase is linked.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue to which the paraphrase is linked.
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
          description: Dialogue paraphrase created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateResponse'
      x-kong-route:
        methods: ['POST']
        paths: ['/characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}:
    get:
      summary: Retrieve a dialogue paraphrase by ID
      description: Retrieves a specific paraphrase document from the OpenSearch index linked to a dialogue by its ID.
      operationId: getDialogueParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue paraphrase is being retrieved.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue whose paraphrase is being retrieved.
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
          description: Dialogue paraphrase document retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Paraphrase'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['GET']
        paths: ['/characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}:
    put:
      summary: Update a dialogue paraphrase by ID
      description: Updates an existing paraphrase document in the OpenSearch index linked to a specific dialogue.
      operationId: updateDialogueParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue paraphrase is being updated.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue whose paraphrase is being updated.
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
          description: Dialogue paraphrase updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UpdateResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['PUT']
        paths: ['/characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}']
        service: 'opensearch-service'

  /characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}:
    delete:
      summary: Delete a dialogue paraphrase by ID
      description: Deletes a dialogue paraphrase document from the OpenSearch index by its ID.
      operationId: deleteDialogueParaphraseById
      parameters:
        - name: characterId
          in: path
          required: true
          description: The ID of the character whose dialogue paraphrase is being deleted.
          schema:
            type: string
        - name: dialogueId
          in: path
          required: true
          description: The ID of the dialogue whose paraphrase is being deleted.
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
          description: Dialogue paraphrase deleted successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/DeleteResponse'
        '404':
          description: Paraphrase not found
      x-kong-route:
        methods: ['DELETE']
        paths: ['/characters/_doc/{characterId}/dialogues/{dialogueId}/paraphrases/_doc/{paraphraseId}']
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
    Dialogue:
      type: object
      properties:
        dialogueId:
          type: string
        text:
          type: string
        characterId:
          type: string
    DialogueInput:
      type: object
      properties:
        text:
          type: string
          example: "Heroic dialogue"
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
    Action:
      type: object
      properties:
        actionId:
          type: string
        description:
          type: string
    ActionInput:
      type: object
      properties:
        description:
          type: string
          example: "The hero saves the day"
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