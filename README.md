# FountainAI: Designing a Scalable AI-Driven Storytelling System

> Managing AWS, Kong Gateway, and OpenSearch with OpenAPI as the Single Source of Truth ...well, almost :)

## Introduction

FountainAI is a scalable, AI-driven platform designed to create dynamic and interactive storytelling experiences. It operates on a microservices architecture, where each service is responsible for a specific aspect of storytelling, such as generating sequences, managing characters, handling scripts, and overseeing session contexts. These microservices communicate through APIs, ensuring smooth collaboration to deliver cohesive narratives.

The system relies on **OpenAPI** as the single source of truth for defining, deploying, and documenting each microservice. OpenAPI ensures every service is consistently described, allowing all stakeholders—from developers to automated systems—to work from a unified framework. This approach promotes flexibility and consistency as the system evolves.

## Table of Contents

## FountainAI Microservices

1. **Central Sequence Service**  
   Manages the generation of sequential identifiers for core elements in the storytelling system. Every component, from scripts to characters, is assigned a unique and consistent sequence number to maintain coherence across the platform.
[Central Sequence Service API](./microservices/central-sequence-service.md)

2. **Story Factory Service**  
   Handles the creation and management of stories within the platform. This service organizes narrative elements into a structured format, ensuring stories are dynamically assembled and managed according to user inputs.
[Story Factory API](./microservices/story-factory-service.md)

3. **Session Context Service**  
   Tracks and manages the state and context of interactive storytelling sessions. It enables the system to adjust the flow of the narrative based on real-time inputs and interactions, maintaining continuity throughout the experience.
[Session and Context Management API](./microservices/session-context-service.md)

4. **Core Script Management Service**  
   Organizes and manages scripts, enabling real-time updates and editing. This service ensures that the script evolves as the story progresses, adapting to changing contexts or character interactions.
[Core Script Management API](./microservices/core-script-management.md)

5. **Character Management Service**  
   Manages the creation and development of characters, tracking traits, behaviors, and backgrounds. This service ensures characters are consistent and grow over time, adapting to the narrative flow.
 [Character Management API](./microservices/character-management.md)

## OpenSearch: The Backbone of Data Continuity

At the core of **FountainAI** is **OpenSearch**, a distributed search and analytics engine that handles data continuity and query capabilities for all microservices. OpenSearch ensures critical elements such as sequence generation, story retrieval, session context, and other key components are indexed and easily retrievable. This ensures high performance and data integrity across the system, even as data volumes grow.

## Kong Gateway: Managing API Interactions

**Kong Gateway** acts as the API gateway for FountainAI, controlling the flow of requests between microservices and their consumers. Kong handles key features such as routing, authentication, rate-limiting, and monitoring, ensuring secure, efficient, and reliable access to each microservice. This gateway enables the system to scale effectively while managing complex service interactions, offering visibility and governance over all API-driven exchanges.

## Table of Contents

- [Chapter 1: FountainAI Architecture Overview](chapters/chapter1.md)
- [Chapter 2: Microservices Communication](chapters/chapter2.md)
- [Chapter 3: API Management with Kong Gateway](chapters/chapter3.md)
- [Chapter 4: Data Flow and Storage in OpenSearch](chapters/chapter4.md)
- [Chapter 5: Deployment Strategy and Continuous Integration](chapters/chapter5.md)
- [Chapter 6: Security and Scalability Considerations](chapters/chapter6.md)
- [Chapter 7: AWS Deployment of Kong and OpenSearch (New Chapter)](chapters/chapter7.md)
- [Chapter 8: Case Studies: FountainAI in Action](chapters/chapter8.md)

