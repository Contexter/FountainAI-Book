#!/bin/bash

# Define the chapters and their corresponding files
declare -A chapters=(
    ["Chapter 1: FountainAI Architecture Overview"]="chapters/chapter1.md"
    ["Chapter 2: Microservices Communication"]="chapters/chapter2.md"
    ["Chapter 3: API Management with Kong Gateway"]="chapters/chapter3.md"
    ["Chapter 4: Data Flow and Storage in OpenSearch"]="chapters/chapter4.md"
    ["Chapter 5: Deployment Strategy and Continuous Integration"]="chapters/chapter5.md"
    ["Chapter 6: Security and Scalability Considerations"]="chapters/chapter6.md"
    ["Chapter 7: AWS Deployment of Kong and OpenSearch"]="chapters/chapter7.md"
    ["Chapter 8: Case Studies: FountainAI in Action"]="chapters/chapter8.md"
)

# Create a directory for the chapters if it doesn't exist
mkdir -p chapters

# Generate the README file with the full structure and interlinked chapters
cat <<EOL > README.md
# FountainAI: Designing a Scalable AI-Driven Storytelling System

> Managing AWS, Kong Gateway, and OpenSearch with OpenAPI as the Single Source of Truth

## Introduction

FountainAI is a scalable, AI-driven platform designed to create dynamic and interactive storytelling experiences. It operates on a microservices architecture, where each service is responsible for a specific aspect of storytelling, such as generating sequences, managing characters, handling scripts, and overseeing session contexts. These microservices communicate through APIs, ensuring smooth collaboration to deliver cohesive narratives.

The system relies on **OpenAPI** as the single source of truth for defining, deploying, and documenting each microservice. OpenAPI ensures every service is consistently described, allowing all stakeholders—from developers to automated systems—to work from a unified framework. This approach promotes flexibility and consistency as the system evolves.

## Table of Contents
EOL

# Loop over the chapters and append them to the README
for chapter in "${!chapters[@]}"; do
    file=${chapters[$chapter]}
    echo "- [${chapter}](${file})" >> README.md
done

cat <<EOL >> README.md

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

EOL

# Create detailed markdown files for each chapter
cat <<EOL > chapters/chapter1.md
# Chapter 1: FountainAI Architecture Overview

## Overview

This chapter provides an overview of the **FountainAI system architecture**, highlighting the microservices approach and explaining the roles of each service. It introduces how OpenAPI is used as the core method for managing service documentation and deployment.

### Key Topics
- **FountainAI Microservices**:
  - **Central Sequence Service**: Manages sequence identifiers.
  - **Story Factory Service**: Assembles and manages story elements.
  - **Session Context Service**: Tracks and manages interactive sessions.
  - **Core Script Management Service**: Ensures that scripts evolve with the narrative.
  - **Character Management Service**: Manages character traits and behavior.

- **OpenAPI as the Single Source of Truth**:
  - Discussion of how OpenAPI drives consistent service descriptions across the entire platform, enabling seamless integration and scalability.

EOL

cat <<EOL > chapters/chapter2.md
# Chapter 2: Microservices Communication

## Overview

This chapter dives into the **communication patterns** between FountainAI’s microservices, ensuring seamless integration and continuity throughout the storytelling process.

### Key Topics
- **Service-to-Service Communication**:
  - RESTful communication via OpenAPI-defined endpoints using Kong Gateway.
  
- **Data Exchange**:
  - Description of how story sequences, session contexts, and character states are exchanged between services.

- **Event-Driven Communication (Future Implementation)**:
  - Possible extensions using event-driven architecture for more scalable asynchronous communication.

EOL

cat <<EOL > chapters/chapter3.md
# Chapter 3: API Management with Kong Gateway

## Overview

This chapter explains how **Kong Gateway** is used in FountainAI to manage API traffic, ensuring secure, scalable, and reliable interactions between services.

### Key Topics
- **Kong Gateway as the API Manager**:
  - Detailed explanation of Kong’s role in managing API routing, SSL termination, rate-limiting, and security.
  
- **Deploying Kong on AWS Using Docker**:
  - Step-by-step guide to deploying Kong as a Docker container on an AWS EC2 instance, including how to configure SSL with Let’s Encrypt.

- **OpenAPI and Kong Configuration**:
  - How OpenAPI definitions drive Kong's configuration, including routes, services, and plugins.

EOL

cat <<EOL > chapters/chapter4.md
# Chapter 4: Data Flow and Storage in OpenSearch

## Overview

This chapter explores how **OpenSearch** is deployed and used to manage data indexing and retrieval for FountainAI.

### Key Topics
- **OpenSearch as the Search Engine**:
  - How OpenSearch stores and indexes data, including session contexts and character information.

- **Deploying OpenSearch on AWS**:
  - Step-by-step guide to deploying OpenSearch using Docker on AWS EC2, including storage considerations (EBS volumes) and performance tuning.

EOL

cat <<EOL > chapters/chapter5.md
# Chapter 5: Deployment Strategy and Continuous Integration

## Overview

This chapter covers the deployment strategy for FountainAI, focusing on how microservices, Kong Gateway, and OpenSearch are deployed on AWS, and how OpenAPI is used in the CI/CD pipeline.

### Key Topics
- **Deployment Strategy**:
  - Overview of deploying FountainAI microservices and infrastructure on AWS, using EC2 instances for both Kong and OpenSearch.
  
- **CI/CD Pipeline**:
  - How OpenAPI definitions are integrated into the CI/CD pipeline for automated deployment and updates.
  
- **Scaling Strategy**:
  - Options for manual and automated scaling on AWS, including horizontal scaling of microservices and vertical scaling of infrastructure.

EOL

cat <<EOL > chapters/chapter6.md
# Chapter 6: Security and Scalability Considerations

## Overview

This chapter focuses on security and scalability within FountainAI, highlighting how Kong Gateway handles security and how FountainAI can scale over time.

### Key Topics
- **Security**:
  - How Kong Gateway manages SSL, authentication, and rate limiting for FountainAI’s microservices.

- **Scalability**:
  - Strategies for scaling OpenSearch and Kong Gateway to handle increasing traffic or data volume.
  
EOL

cat <<EOL > chapters/chapter7.md
# Chapter 7: AWS Deployment of Kong and OpenSearch

## Overview

This chapter explains the process of deploying **Kong Gateway** and **OpenSearch** on AWS using EC2 instances and Docker.

### Key Topics
- **Setting Up EC2 Instances**:
  - Guide for creating and configuring EC2 instances for running Kong and OpenSearch using Docker.

- **Deploying Kong with SSL**:
  - Step-by-step instructions for deploying Kong on AWS with Let’s Encrypt SSL for secure API management.

- **Deploying OpenSearch**:
  - How to deploy OpenSearch with persistent storage using EBS volumes, and how to optimize it for FountainAI’s use case.

EOL

cat <<EOL > chapters/chapter8.md
# Chapter 8: Case Studies: FountainAI in Action

## Overview

This chapter presents case studies showcasing how FountainAI was implemented to drive dynamic storytelling in different real-world scenarios.

### Key Topics
- **Use Case 1: Interactive Storytelling for Games**
- **Use Case 2: AI-Powered Narratives for Educational Platforms**
- **Use Case 3: Automated Script Management for Writers**

EOL

# Success message
echo "Chapter structure with OpenAPI links created successfully with interlinked markdown files."
