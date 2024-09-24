# FountainAI

> **Building a Scalable, AI-Driven Storytelling Platform**

## Introduction

FountainAI is a platform designed to create dynamic, interactive storytelling experiences using cutting-edge AI technology. Its architecture leverages modular microservices, each focused on a specific task—such as sequence generation, character management, script handling, and session control. These components work together, creating a collaborative ecosystem that adapts and evolves with user input.

The goal is to enable flexible and interactive narratives where every element—from plot to characters—is generated, managed, and refined dynamically. **FountainAI** aims to be a comprehensive tool for AI-assisted storytelling, using its modular design to scale and adapt to a wide variety of narrative forms.

However, **FountainAI** isn’t just about technology—it is built with a development philosophy that emphasizes reliability, traceability, and intentional control over the entire system. This is where the **Manual-First Approach** comes in.

## The Manual-First Approach: A Development Philosophy

The **Manual-First Approach** isn’t just about deploying FountainAI—it’s about ensuring that the platform evolves in a stable, controlled manner. While AI-driven systems are often highly automated, **FountainAI** deliberately uses **manual control** in its infrastructure management and configuration, ensuring that changes are always intentional, documented, and reviewed.

This approach is crucial to maintain the **integrity** and **scalability** of the system while ensuring transparency and traceability. The **Manual-First Approach** allows developers and operators to retain full control over every configuration and update, especially as the platform scales.

### Key Principles of the Manual-First Approach:
1. **Deliberate Control over Automation**: Every configuration change is manually triggered to avoid unintended updates or changes.
2. **Idempotency**: Scripts and actions can be safely re-run without side effects, ensuring stability at every layer.
3. **Structured Repository and Clear Documentation**: A rigorously organized repository ensures traceability, allowing every update and change to be clearly documented and tracked.

### The Development Process:
FountainAI’s development relies on **modular microservices** and idempotent shell scripts to manage infrastructure components like **Kong (DB-less)**, **Docker-based services**, and **OpenSearch**. These services work together to maintain a scalable and adaptable platform, ensuring that as FountainAI grows, it remains stable and transparent.

This philosophy is put into practice through the **Manual-First Approach to Infrastructure Configuration Management**, a detailed plan that outlines how infrastructure is managed manually while ensuring consistency and reliability. For the full implementation, see the paper here:  
[Paper: A Manual-First Approach to Infrastructure Configuration Management with AWS Lightsail, Kong, Docker, and OpenSearch](./chapters/Paper_%20A%20Manual-First%20Approach%20to%20Infrastructure%20Configuration%20Management%20with%20AWS%20Lightsail,%20Kong,%20Docker,%20and%20OpenSearch.md)

## FountainAI Microservices and APIs

FountainAI’s architecture is built on a series of microservices, each designed to handle a specific aspect of the storytelling process. These microservices communicate through APIs, ensuring that the platform remains flexible, scalable, and easily adaptable to different storytelling needs.

### Microservices Overview:

1. **Central Sequence Service API**  
   This service manages the generation of sequential identifiers (IDs) for key elements like scripts and characters, ensuring consistency across the system.  
   [Central Sequence Service OpenAPI](./microservices/central-sequence-service.md)

2. **Story Factory Service API**  
   Handles the creation, organization, and management of stories. It ensures that narrative elements are dynamically assembled based on user inputs, allowing for an interactive storytelling experience.  
   [Story Factory Service OpenAPI](./microservices/story-factory-service.md)

3. **Session Context Service API**  
   Tracks and manages the real-time state of storytelling sessions. By monitoring inputs and adjusting narratives on the fly, it helps maintain continuity and flow within the interactive experience.  
   [Session Context Service OpenAPI](./microservices/session-context-service.md)

4. **Core Script Management Service API**  
   Manages the evolution of scripts throughout the storytelling process. It ensures that scripts are adaptable to changes, character interactions, and the overall narrative flow.  
   [Core Script Management Service OpenAPI](./microservices/core-script-management.md)

5. **Character Management Service API**  
   This service is responsible for tracking character traits, behaviors, and development throughout the story, ensuring that characters grow and remain consistent.  
   [Character Management Service OpenAPI](./microservices/character-management.md)

These APIs enable FountainAI to function as a dynamic, adaptable system, where every piece of the story—from characters to plot elements—is managed in real time.

## The FountainAI Book: A Documentation of the Journey

The **FountainAI Book** is an evolving documentation of the platform's development process. It chronicles the strategies, ideas, and insights gained while creating FountainAI, with a strong emphasis on the **Manual-First Approach** and the critical lessons learned along the way.

### A Fully Automated Book Review

As of today, the **FountainAI Book** also stands as a remarkable case study in itself—it includes the, to my experience, first-ever **fully automated book review**, created with the very precursor of FountainAI. This automated review lays out a detailed plan to rewrite the book, offering a glimpse into how AI-driven processes can assist in refining and revising complex documentation. This achievement showcases the system’s capabilities in automating intricate tasks like book reviews, using the same methods that underpin FountainAI’s storytelling functionalities.

For more on the refactoring plan and the automated book review, see the detailed plan here:  
[Refactor the FountainAI Book](./chapters/Refactor%20the%20FountainAI%20Book.md)

### Table of Contents:

- [Chapter 1: FountainAI Architecture Overview](chapters/chapter1.md)
- [Chapter 2: GPT as OpenSearch QueryDSL Controller](chapters/chapter2.md)
- [Chapter 3: API Management with Kong Gateway](chapters/chapter3.md)
- [Chapter 4: Data Flow and Storage in OpenSearch](chapters/chapter4.md)
- [Chapter 5: Deployment Strategy and Continuous Integration](chapters/chapter5.md)
- [Chapter 6: Security and Scalability Considerations](chapters/chapter6.md)
- [Chapter 7: Shell Scripting in FountainAI: From Automation to Code Generation](chapters/chapter7.md)
- [Chapter 8: Enter Ansible](chapters/chapter8.md)
- [Chapter 9: Creating the FountainAI Deployment Blueprint Format](chapters/chapter9.md)
- [Chapter 10: Feedback and Introspection via Custom GPT and GitHub OpenAPI](chapters/chapter10.md)
- [Chapter 11: Deploying the FastAPI Proxy for the GPT Repository Controller](chapters/chapter11.md)
- [Chapter 12: Demonstrating Automated Book Revision with FountainAI](chapters/chapter12.md)
- [Chapter 13: Creating Lean Microservices](chapters/chapter13.md)
- [Chapter 14: Setting Up a Control Machine for Ansible Using Amazon Lightsail](chapters/chapter14.md)
- [Chapter 15: From REST API to GraphQL – Efficient Pagination and Date Filtering with FastAPI](chapters/chapter15.md)
- [Chapter 16: Secure Management and Deployment of GitHub Personal Access Token (PAT) for FastAPI](chapters/chapter16.md)

