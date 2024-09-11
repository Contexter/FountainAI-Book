# Refactoring Guidelines for FountainAI Microservices

> Transitioning from AWS API Gateway to Kong Gateway and OpenSearch Integration

## Overview

The following guidelines outline the steps to refactor FountainAI's microservice OpenAPI specifications from their deprecated **AWS API Gateway** state (A) to a new architecture (B), utilizing **Kong Gateway** for API management and **OpenSearch** for data storage. These rules are based on the current model provided by the **Central Sequence Service API**.

## Refactoring Steps

### 1. Kong Gateway Integration

#### 1.1 Remove AWS API Gateway References
- Remove any instances of `x-amazon-apigateway-integration` across all paths and replace them with the necessary Kong gateway routing configuration (e.g., service URL, proxy configuration).
- Eliminate AWS-specific configurations such as `REGIONAL` in `x-amazon-apigateway-endpoint-configuration`.

#### 1.2 Replace with Kong Routes
- Define routes and services that Kong will use to forward API requests to OpenSearch. In the OpenAPI spec, ensure the `servers` section refers to the **Kong Gateway** URL (e.g., `https://kong.fountain.coach`).

### 2. OpenSearch Integration

#### 2.1 Maintain OpenSearch Endpoints
- Preserve the current paths that call **OpenSearch** for storing, updating, and retrieving data, such as `_doc`, `_search`, `_bulk`, etc.
- Ensure every `POST`, `GET`, `PUT`, `DELETE` action has the correct corresponding OpenSearch endpoint.

### 3. Server Definitions

#### 3.1 Use FountainAI Domains
- Change server URLs to **fountain.coach** domain instead of using AWS Gateway endpoints. For example:
  ```
  servers:
    - url: https://api.characters.fountain.coach
  ```

### 4. OpenAPI Components

#### 4.1 Ensure Comprehensive Documentation
- Include all necessary `components` definitions, such as:
  - **Schemas**: Clearly define the structure of request and response bodies.
  - **Security Schemes**: Ensure `ApiKeyAuth` is correctly configured for API security.

### 5. Consistency Across Microservices

#### 5.1 Uniformity in Format
- All OpenAPI specifications for the **Central Sequence Service**, **Character Management**, **Story Factory**, **Session Context**, and **Core Script Management** must follow the same structure.
- Ensure that each microservice contains **Kong Gateway routes**, **OpenSearch integration**, and follows the consistent formatting of schemas and paths.

### 6. Security Considerations

#### 6.1 API Key Authentication
- Retain the `ApiKeyAuth` mechanism across all OpenAPI specifications to ensure secure access to microservices. This includes defining security schemes and ensuring all paths are protected by the API key.

### 7. General Cleanup

#### 7.1 Remove Deprecated Fields
- Remove any deprecated or unnecessary fields related to AWS that no longer apply in the Kong/OpenSearch model. Clean up responses and ensure they align with current system needs.

---

This document provides the essential guidelines to refactor each microservice's OpenAPI specification from its deprecated AWS-dependent form to the current system design with Kong and OpenSearch.