
## **Chapter 13: Creating Lean Microservices**

---

#### **Introduction**

In the previous chapter, we demonstrated FountainAI running a live demo. From this experience, we learned an essential lesson: **handling external resources**, particularly large text files hosted on GitHub, needs to be robust and efficient. One key challenge that FountainAI faced was that it did not know the **maximum number of lines** in files being fetched, causing significant issues with file reading and content retrieval.

This chapter focuses on **creating lean microservices** to address those challenges. Specifically, we aim to establish a simple, automated way to handle GitHub-hosted resources using FastAPI and Docker. The outcome is **deploy_fastapi_service.sh**, a shell script that automates microservice setup and deployment to a public GitHub repository. Although security will be addressed in future deployment steps (such as through API gateways), this chapter highlights how simplicity and automation can improve the robustness of our system.

---

#### **Lessons Learned from Chapter 12: The Hiccups**

During the Chapter 12 demo of FountainAI, several hiccups highlighted weaknesses in how FountainAI handled fetching content from GitHub. The primary issue stemmed from its inability to properly handle large files or determine how many lines a file had before attempting to read it. This led to:
- **Timeouts**: FountainAI didn’t know the size of the file in terms of lines, causing incomplete file reads and failures.
- **Dropped Processes**: Without properly knowing the maximum lines in a file, FountainAI sometimes dropped out of the process entirely.

These issues made it clear that we needed a more robust, scalable solution for **handling line-by-line reading** of GitHub-hosted resources. This is where the development of a lean microservice came in—**a single-purpose service** to fetch, read, and count lines efficiently, capable of handling large resources with precision.

---

#### **The Solution: Deploying a Lean, FastAPI Microservice**

The solution to this challenge was simple: automate the process of creating and deploying a **Dockerized FastAPI microservice** capable of efficiently fetching and processing files from GitHub repositories. The goal was to create a single-purpose microservice for **fetching GitHub-hosted files**, **detecting the file type**, and **counting the lines**—whether it’s text, PDF, or DOCX.

This microservice eliminates the guesswork FountainAI previously struggled with by fetching files intelligently, processing them according to their type, and responding with the required line count or CSV output.

---

### **The deploy_fastapi_service.sh Script**

Here is the **deploy_fastapi_service.sh** script. This script automates the creation of a GitHub repository, initializes a FastAPI microservice, and deploys it using Docker.

```bash
#!/bin/bash

# FountainAI Shell Script: Deploy a FastAPI Microservice to GitHub and Dockerize It
# Author: Contexter
# Description: Automates the creation of a public GitHub repo, initializes a FastAPI app with Docker, and pushes it to GitHub

# --- Configuration ---
REPO_NAME="github-line-counter-service"
GITHUB_USER="Contexter"
PROJECT_DIR="$HOME/$REPO_NAME"
MAIN_PY="$PROJECT_DIR/main.py"
DOCKERFILE="$PROJECT_DIR/Dockerfile"
REQUIREMENTS_FILE="$PROJECT_DIR/requirements.txt"

# --- Functions ---

# Function to create a new public GitHub repository using the GitHub CLI
create_github_repo() {
  echo "Creating GitHub repository: $REPO_NAME"
  gh repo create "$GITHUB_USER/$REPO_NAME" --public --confirm
  if [ $? -eq 0 ]; then
    echo "Repository created successfully."
  else
    echo "Error: Failed to create GitHub repository."
    exit 1
  fi
}

# Function to initialize the project directory and add necessary files
initialize_project() {
  echo "Initializing project directory at $PROJECT_DIR"
  mkdir -p "$PROJECT_DIR"

  # Create the main.py file with FastAPI application code
  cat > "$MAIN_PY" <<EOL
from fastapi import FastAPI, HTTPException, Query
from typing import Optional
import mimetypes
import requests
from pdfminer.high_level import extract_text
from docx import Document
import io
import csv
from fastapi.responses import StreamingResponse, JSONResponse

app = FastAPI(
    title="GitHub Line Counter Service",
    description="Counts lines in text, PDF, DOCX files from GitHub and provides results in JSON or CSV.",
    version="1.1.0"
)

GITHUB_API_URL = "https://api.github.com"

def fetch_file_from_github(owner: str, repo: str, path: str):
    url = f"\${GITHUB_API_URL}/repos/\${owner}/\${repo}/contents/\${path}"
    headers = {"Accept": "application/vnd.github.v3.raw"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.content
    else:
        raise HTTPException(status_code=response.status_code, detail="Error fetching file from GitHub")

def detect_file_type(path: str):
    mime_type, _ = mimetypes.guess_type(path)
    return mime_type

def convert_pdf_to_text(file_content):
    return extract_text(io.BytesIO(file_content))

def convert_docx_to_text(file_content):
    doc = Document(io.BytesIO(file_content))
    return '\\n'.join([para.text for para in doc.paragraphs])

def count_lines_in_text(text_content: str):
    return text_content.count('\\n')

@app.get(
    "/repo/{owner}/{repo}/file/{path:path}/line_count",
    response_model=dict,
    summary="Get total line count of a GitHub file",
    description="Fetch a file from a GitHub repository, detect its type (text, PDF, DOCX), and return the total number of lines.",
    operation_id="count_lines_in_github_file",
    status_code=200
)
def get_file_line_count(owner: str, repo: str, path: str, response_format: str = Query("json", enum=["json", "csv"])):
    try:
        file_content = fetch_file_from_github(owner, repo, path)
        mime_type = detect_file_type(path)
        if mime_type == 'application/pdf':
            text_content = convert_pdf_to_text(file_content)
        elif mime_type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
            text_content = convert_docx_to_text(file_content)
        elif mime_type.startswith('text'):
            text_content = file_content.decode('utf-8')
        else:
            raise HTTPException(status_code=400, detail="Unsupported file type.")
        total_lines = count_lines_in_text(text_content)
        result = {"file_path": path, "line_count": total_lines}
        if response_format == "csv":
            def iter_csv():
                output = io.StringIO()
                writer = csv.writer(output)
                writer.writerow(["File Path", "Total Lines"])
                writer.writerow([path, total_lines])
                output.seek(0)
                yield output.read()
            return StreamingResponse(iter_csv(), media_type="text/csv")
        return JSONResponse(content=result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error counting lines: {str(e)}")

@app.get("/", summary="Root route - Welcome to the GitHub Line Counter Service")
def root_route():
    return {"message": "Welcome to the GitHub Line Counter Service. Use /repo/{owner}/{repo}/file/{path}/line_count to get started."}

@app.get("/health", summary="Health check")
def health_check():
    return {"status": "Service is up and running!"}
EOL

  # Create the Dockerfile for containerization
  cat > "$DOCKERFILE" <<EOL
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
COPY ./main.py /app/main.py

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL

  # Create requirements.txt
  cat > "$REQUIREMENTS_FILE" <<EOL
fastapi
uvicorn
requests
pdfminer.six
python-docx
EOL

  echo "Project files created successfully."
}

# Function to commit and push the project to GitHub
commit_and_push_to_github() {
  echo "Committing and pushing project to GitHub."
  cd "$PROJECT_DIR"
  git init
  git add .
  git commit -m "Initial commit: FastAPI line counter microservice"
  git branch -M main
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
  git push -u origin main
  if [ $? -eq 0 ]; then
    echo "Project pushed to GitHub successfully."
  else
    echo "Error: Failed to push project to GitHub."
    exit 1
  fi
}

# --- Main Script Execution ---

create_github_repo
initialize_project
commit_and_push_to_github

echo "FastAPI microservice deployed and pushed to GitHub."
```

---

### **Integrating OpenAPI and FastAPI Practices**

With the microservice deployed using the script, it’s crucial to ensure the **OpenAPI specification** generated by FastAPI meets the necessary standards for external integration. Here are the key steps to make sure the FastAPI app produces high-quality OpenAPI documentation.

#### **1. Always Define `operationId` Explicitly**
FastAPI auto-generates `operationId` by combining the HTTP method and path. However, manually defining this ensures clarity and ease of use, especially when interacting with the API programmatically.

```python
@app.get("/repo/{owner}/{repo}/file/{path:path}/line_count",
         operation_id="count_lines_in_github_file",  # Explicit operationId
         summary="Count lines in a GitHub file",
         description="Fetch a file from GitHub and return the total number of lines.")
```

#### **2. Manually Define the Server in OpenAPI**
FastAPI does not include a **server directive** by default. To ensure the OpenAPI specification works in production, we manually add this directive:

```python
from fastapi.openapi.utils import get_openapi

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
    )
    openapi_schema["servers"] = [
        {
            "url": "https://api.example.com",  # Replace with actual production URL
            "description": "Dummy server URL. Replace this with your actual deployment URL."
        }
    ]
    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi
```

#### **3. Explicit Response Models and Status Codes**
Always provide **explicit response models** and status codes to ensure clarity in the OpenAPI documentation.

```python
@app.get("/repo/{owner}/{repo}/file/{path:path}/line_count",
         response_model=LineCountResponseModel,
         summary="Count lines in a GitHub file",
         description="Fetch a file from a GitHub repository and count the total number of lines.",
         operation_id="count_lines_in_github_file",
         status_code=200,
         responses={
             200: {"description": "Successful operation", "content": {"application/json": {"example": {"file_path": "README.md", "line_count": 42}}}},
             400: {"description": "Bad Request"},
             500: {"description": "Server Error"}
         })
def get_file_line_count(owner: str, repo: str, path: str):
    # Your function logic here
```

---

### **Final OpenAPI Specification with Server Directive**

Finally, here’s the complete **OpenAPI specification** generated by FastAPI, including the **server directive**. The server URL is currently a **dummy value**, which developers should replace with the actual deployment URL when they move their microservice to production:

```yaml
openapi: 3.1.0
info:
  title: GitHub Line Counter Service
  description: This microservice fetches text, PDF, and DOCX files from public GitHub repositories and counts the number of lines. It provides results in JSON or CSV format.
  version: '1.1.0'
servers:
  - url: "https://api.example.com" # Replace with your deployment URL
    description: "Dummy server URL. Replace this with your actual deployment URL in production."
paths:
  /repo/{owner}/{repo}/file/{path}/line_count:
    get:
      summary: Count lines in a GitHub file
      description: Fetch a file from a GitHub repository, detect its type (text, PDF, DOCX), and return the total number of lines. You can request the result as JSON or CSV.
      operationId: count_lines_in_github_file
      parameters:
        - name: owner
          in: path
          required: true
          schema:
            type: string
            title: Owner
        - name: repo
          in: path
          required: true
          schema:
            type: string
            title: Repo
        - name: path
          in: path
          required: true
          schema:
            type: string
            title: Path
        - name: response_format
          in: query
          required: false
          schema:
            type: string
            description: "The format in which you want the result: 'json' for JSON or 'csv' for CSV output."
            enum:
              - json
              - csv
            default: json
            title: Response Format
          description: "The format in which you want the result: 'json' for JSON or 'csv' for CSV output."
      responses:
        '200':
          description: The line count was successfully computed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LineCountResponseModel'
              example:
                file_path: chapters/chapter8.md
                line_count: 120
        '400':
          description: Unsupported file type or bad request
        '500':
          description: Server error while processing the file
components:
  schemas:
    LineCountResponseModel:
      type: object
      required:
        - file_path
        - line_count
      properties:
        file_path:
          type: string
          title: File Path
        line_count:
          type: integer
          title: Line Count
    HTTPValidationError:
      title: HTTPValidationError
      type: object
      properties:
        detail:
          type: array
          title: Detail
          items:
            $ref: '#/components/schemas/ValidationError'
    ValidationError:
      title: ValidationError
      type: object
      required:
        - loc
        - msg
        - type
      properties:
        loc:
          type: array
          title: Location
          items:
            anyOf:
              - type: string
              - type: integer
        msg:
          type: string
          title: Message
        type:
          type: string
          title: Error Type
```

---

#### **Conclusion**

By integrating these **OpenAPI practices** into our FastAPI microservice deployment, we ensure that the generated documentation is clear, complete, and useful for both developers and machines. The **deploy_fastapi_service.sh** script automates the process, but the final OpenAPI specification requires explicit `operationId`, server definitions, and response models for production environments. 

---

**End of Chapter 13**
