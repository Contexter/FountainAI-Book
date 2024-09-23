
## **Chapter 16: Secure Management and Deployment of GitHub Personal Access Token (PAT) for FastAPI**

### **Introduction**

In this chapter, we will guide you through the following steps:

1. **Generating a GitHub Personal Access Token (PAT)** for use in a FastAPI application.
2. **Persisting the PAT** using environment variables on a Lightsail Ubuntu instance.
3. Updating **FastAPI** to securely load and use the PAT for GitHub API requests.
4. **Restarting FastAPI and NGINX** to apply the changes without rebooting the instance.

---

### **1. How to Generate a GitHub Personal Access Token (PAT)**

The **PAT** allows your FastAPI app to authenticate and interact with GitHub’s API. Follow these steps to create a token:

#### **Step 1: Log in to GitHub**
- Go to [GitHub](https://github.com/) and log in.

#### **Step 2: Access the Personal Access Token Page**
1. In the top-right corner, click your profile picture, then click **Settings**.
2. Scroll down and click **Developer settings**.
3. Under **Personal access tokens**, click **Tokens (classic)**.
4. Click **Generate new token**.

#### **Step 3: Configure the Token**
1. **Name the token** (e.g., `FastAPI GitHub Token`).
2. Set the **Expiration**: Choose between **30 days**, **60 days**, or **No expiration** based on your security preferences.
3. **Select Scopes**: You need at least the following permissions:
   - **`repo`**: Full control of repositories.
   - **`read:user`**: Read access to your user profile.

#### **Step 4: Generate and Copy the Token**
Once the token is generated, **copy it** immediately as GitHub will not show it again. You’ll need this token to configure your FastAPI app.

---

### **2. Persisting the PAT on a Lightsail Ubuntu Instance**

Now that you have your **GitHub PAT**, you need to securely store it on the **Lightsail instance** using environment variables.

#### **Step 1: SSH into the Lightsail Instance**
In your terminal, run the following command to SSH into your instance:

```bash
ssh -i /path/to/key.pem ubuntu@your-instance-ip
```

Replace `/path/to/key.pem` with the path to your SSH key, and `your-instance-ip` with your instance’s IP address.

#### **Step 2: Open the `.bashrc` File**
Once logged in, open the **`.bashrc`** file (this file is executed when you start a session):

```bash
nano ~/.bashrc
```

#### **Step 3: Add the GitHub PAT**
Add the following line to the end of the **`.bashrc`** file:

```bash
export GITHUB_TOKEN="your_actual_github_token"
```

Replace `your_actual_github_token` with the PAT you generated from GitHub.

#### **Step 4: Apply the Changes**
To apply the changes immediately without rebooting the instance, run:

```bash
source ~/.bashrc
```

#### **Step 5: Verify the PAT**
Check that the **GITHUB_TOKEN** is correctly set by running:

```bash
echo $GITHUB_TOKEN
```

If the token is printed, it has been set correctly and is available to use.

---

### **3. FastAPI: How the Environment Variable is Used**

Now that the **GitHub PAT** is set as an environment variable, your **FastAPI** application can load and use it to authenticate GitHub API requests.

Here is the **complete `main.py`** file retrieved from the repository, updated to load the **GITHUB_TOKEN** from the environment:

#### **Code View: `main.py`**

```python
import os
from fastapi import FastAPI, HTTPException, Query
import requests
from typing import Optional
import logging

# Set up FastAPI app with OpenAPI versioning and custom settings
app = FastAPI(
    title="FountainAI GitHub Repository File Content API",
    version="1.1.0",
    description="This API enables efficient retrieval and management of file content from GitHub repositories. It returns file paths in the same format as GitHub's 'Copy file path' feature.",
    openapi_version="3.1.0",
    servers=[
        {
            "url": "https://proxy.fountain.coach",
            "description": "Production server"
        }
    ]
)

# Load the GitHub token from environment variables for security
GITHUB_API_URL = "https://api.github.com"
GITHUB_GRAPHQL_API_URL = "https://api.github.com/graphql"
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")  # Now loaded securely from environment variables
if not GITHUB_TOKEN:
    raise HTTPException(status_code=500, detail="GitHub token not found in environment variables")

CHUNK_SIZE = 50000  # 50 KB chunk size for large files
MAX_FILE_SIZE_BYTES = 1024 * 1024  # 1 MB soft limit for comprehensive retrieval

# Set up logging to capture all log levels and write to a log file
logging.basicConfig(
    filename='app.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Helper function to make requests to GitHub API using the token from env variables
def github_request(endpoint: str, headers=None):
    url = f"{GITHUB_API_URL}/{endpoint}"
    if headers is None:
        headers = {"Accept": "application/vnd.github.v3+json", "Authorization": f"Bearer {GITHUB_TOKEN}"}
    response = requests.get(url, headers=headers)
    if response.status_code not in [200, 206]:
        logging.error(f"GitHub API error: {response.status_code}, {response.text}")
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response

# Helper function to query GitHub GraphQL API
def github_graphql_query(query: str, variables: dict = {}):
    headers = {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Content-Type": "application/json"
    }
    response = requests.post(GITHUB_GRAPHQL_API_URL, json={"query": query, "variables": variables}, headers=headers)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()

# Root endpoint with welcome message
@app.get("/", summary="Welcome")
def welcome():
    return {"message": "Welcome to FountainAI GitHub Repository File Content API"}

# Fetch the repository directory structure (recursive tree)
@app.get("/repo/{owner}/{repo}/tree",
    operation_id="getRepositoryTree",
    summary="Retrieve repository directory structure with 'Copy file path' format",
    description="Fetches the recursive directory structure of a GitHub repository. Returns file paths in the same format as GitHub's 'Copy file path' feature."
)
def get_repo_tree(owner: str, repo: str):
    logging.info(f"Fetching repository tree for {repo} by {owner}")
    try:
        endpoint = f"repos/{owner}/{repo}/git/trees/main?recursive=1"
        tree_data = github_request(endpoint)
        paths = []
        for item in tree_data.json().get("tree", []):
            if item["type"] == "blob":  # Only include files, not directories
                paths.append(item["path"])  # 'path' is in "Copy file path" format
        return {"file_paths": paths}
    except requests.exceptions.RequestException as e:
        error_info = {
            "error": str(e),
            "endpoint": endpoint,
            "owner": owner,
            "repo": repo,
            "suggestions": [
                "Check if the repository is public or accessible with proper permissions.",
                "Ensure the repository name and owner are correct.",
                "Check if the repository has a 'main' branch or if it's using a different default branch.",
                "Consider if GitHub API rate limits or access restrictions are being applied."
            ],
        }
        logging.error(f"Repository tree retrieval failed for {repo} by {owner}: {error_info}")
        raise HTTPException(status_code=500, detail=error_info)

# Fetch file content by its path, chunked if necessary
@app.get("/repo/{owner}/{repo}/file/{path:path}/content",
    operation_id="getFileContent",
    summary="Get file content from repository using 'Copy file path' format",
    description="Retrieves the content of a file from a GitHub repository using the path format from GitHub's 'Copy file path' feature. For smaller files, the entire content is returned in one response."
)
def get_file_content(owner: str, repo: str, path: str):
    logging.info(f"Fetching file content for {path} in {repo} by {owner}")
    try:
        metadata = github_request(f"repos/{owner}/{repo}/contents/{path}")
        file_data = metadata.json()
        file_size = file_data.get("size", 0)
        sha = file_data.get("sha")
    except requests.exceptions.RequestException as e:
        error_info = {
            "error": str(e),
            "endpoint": f"repos/{owner}/{repo}/contents/{path}",
            "owner": owner,
            "repo": repo,
            "path": path,
            "suggestions": [
                "Ensure the file path exists within the repository (in 'Copy file path' format).",
                "Check if the file is accessible and not too large for API retrieval.",
                "Verify that the repository is public or your API token has sufficient access."
            ],
        }
        logging.error(f"Failed to retrieve file content for {path} in {repo}: {error_info}")
        raise HTTPException(status_code=500, detail=error_info)

    total_content = ""
    start_byte = 0

    while start_byte < file_size:
        chunk = get_file_chunk(owner, repo, sha, start_byte, CHUNK_SIZE)
        total_content += chunk
        start_byte += CHUNK_SIZE

    return {"content": total_content}

# Helper function to retrieve file chunk by byte range
def get_file_chunk(owner: str, repo: str, sha: str, start_byte: int, chunk_size: int):
    url = f"https://api.github.com/repos/{owner}/{repo}/git/blobs/{sha}"
    headers = {"Accept": "application/vnd.github.v3.raw", "Range": f"bytes={start_byte}-{start_byte + chunk_size - 1}"}
    response = requests.get(url, headers=headers)
    if response.status_code != 206 and response.status_code != 200:
        raise HTTPException(status_code=500, detail="Error fetching file chunk.")
    return response.content.decode("utf-8")

# Fetch file lines by range
@app.get("/repo/{owner}/{repo}/file/{path:path}/lines",
    operation_id="getFileLinesByRange",
    summary="Get file lines by range",
    description="Retrieves a specific range of lines from a file in a GitHub repository. This route is optimized to prevent out-of-range errors by validating the requested line range."
)
def get_lines_by_range(owner: str, repo: str, path: str, start_line: int = 0, end_line: Optional[int] = None):
    logging.info(f"Fetching lines from file: {path} in repo: {repo}")
    try:
        total_lines = count_total_lines(owner, repo, path)

        if start_line < 0 or start_line >= total_lines:
            raise HTTPException(status_code=400, detail=f"Start line is out of range. The file has {total_lines} lines.")

        if end_line is None or end_line > total_lines:
            end_line = total_lines

        total_content = get_file_content(owner, repo, path)["content"]
        lines = total_content.splitlines()
        return {"lines": lines[start_line:end_line], "max_lines": total_lines}

    except requests.exceptions.RequestException as e:
        error_info = {
            "error": str(e),
            "endpoint": f"repos/{owner}/{repo}/contents/{path}",
            "owner": owner,
            "repo": repo,
            "path": path,
            "suggestions": [
                "Check if the line range is valid.",
                "Ensure the file exists in the repository and contains readable content.",
                "If this is a large file, consider chunking your requests for better performance."
            ],
        }
        logging.error(f"Failed to retrieve lines from {path} in {repo}: {error_info}")
        raise HTTPException(status_code=500, detail=error_info)

# Function to calculate total lines in a file
def count_total_lines(owner: str, repo: str, path: str):
    logging.info(f"Counting lines for {path} in {repo}")
    
    try:
        metadata = github_request(f"repos/{owner}/{repo}/contents/{path}")
        file_data = metadata.json()
        file_size = file_data.get("size", 0)
        sha = file_data.get("sha")
    except requests.exceptions.RequestException as e:
        error_info = {
            "error": str(e),
            "endpoint": f"repos/{owner}/{repo}/contents/{path}",
            "owner": owner,
            "repo": repo,
            "path": path,
            "suggestions": [
                "Check if the file exists and is accessible.",
                "Ensure that the repository and file path are correct."
            ],
        }
        logging.error(f"Failed to count lines for {path} in {repo}: {error_info}")
        raise HTTPException(status_code=500, detail=error_info)
    
    total_lines = 0
    carry_over = ""
    start_byte = 0
    
    while start_byte < file_size:
        chunk = get_file_chunk(owner, repo, sha, start_byte, CHUNK_SIZE)
        lines, carry_over = process_chunk(chunk, carry_over)
        total_lines += len(lines)
        start_byte += CHUNK_SIZE

    logging.info(f"Total number of lines in {path}: {total_lines}")
    return total_lines

# Helper function to process chunk into lines
def process_chunk(chunk, carry_over):
    content = carry_over + chunk
    lines = content.splitlines(keepends=True)
    if not content ends with "\n":
        carry_over = lines.pop()
    else:
        carry_over = ""
    return lines, carry_over

# Get the maximum number of lines in the file
@app.get("/repo/{owner}/{repo}/file/{path:path}/max-lines",
    operation_id="getMaxLinesInFile",
    summary="Get maximum line count in file",
    description="Calculates and returns the total number of lines in a file. This is useful for validating line ranges before making a request for specific lines."
)
def get_max_lines(owner: str, repo: str, path: str):
    try:
        total_lines = count_total_lines(owner, repo, path)
        return {"max_lines": total_lines}
    except requests.exceptions.RequestException as e:
        error_info = {
            "error": str(e),
            "endpoint": f"repos/{owner}/{repo}/contents/{path}",
            "owner": owner,
            "repo": repo,
            "path": path,
            "suggestions": [
                "Check if the file exists and is accessible.",
                "Ensure that the repository and file path are correct."
            ],
        }
        logging.error(f"Failed to calculate max lines for {path} in {repo}: {error_info}")
        raise HTTPException(status_code=500, detail=error_info)

# Fetch recent commits for the repository
@app.get("/repo/{owner}/{repo}/commits", summary="Fetch GitHub commit history with pagination support")
def get_commits_by_date(
    owner: str, 
    repo: str, 
    limit: int = Query(5, description="Number of commits to fetch per page"), 
    cursor: Optional[str] = Query(None, description="Cursor for fetching the next page of commits"),
    start_date: Optional[str] = Query(None, description="Filter commits starting from this date (YYYY-MM-DD)"),
    end_date: Optional[str] = Query(None, description="Filter commits until this date (YYYY-MM-DD)")
):
    """
    Fetch the most recent commits from a GitHub repository, with pagination support and optional date filtering.
    """
    query = """
    query($owner: String!, $repo: String!, $limit: Int!, $cursor: String) {
      repository(owner: $owner, name: $repo) {
        ref(qualifiedName: "main") {
          target {
            ... on Commit {
              history(first: $limit, after: $cursor) {
                edges {
                  cursor
                  node {
                    message
                    committedDate
                  }
                }
                pageInfo {
                  hasNextPage
                  endCursor
                }
              }
            }
          }
        }
      }
    }
    """
    
    variables = {"owner": owner, "repo": repo, "limit": limit, "cursor": cursor}
    result = github_graphql_query(query, variables)
    
    # Filter commits by date if start_date and end_date are provided
    commits = []
    for commit in result["data"]["repository"]["ref"]["target"]["history"]["edges"]:
        commit_date = commit["node"]["committedDate"]
        
        # Only add the commit if it's within the specified date range
        if (not start_date or commit_date >= start_date) and (not end_date or commit_date <= end_date):
            commits.append({
                "message": commit["node"]["message"],
                "cursor": commit["cursor"],
                "committedDate": commit_date
            })
    
    page_info = result["data"]["repository"]["ref"]["target"]["history"]["pageInfo"]
    
    return {
        "commits": commits,
        "pageInfo": {
            "hasNextPage": page_info["hasNextPage"],
            "endCursor": page_info["endCursor"]
        }
    }
```

### **Explanation of Key Changes**:
- The **GitHub PAT** is loaded from the environment variable using `os.getenv("GITHUB_TOKEN")`.
- If the **PAT** is not found in the environment, the FastAPI app returns a **500 Internal Server Error**.
- All GitHub API requests use the **GITHUB_TOKEN** for authentication, securely loaded from the environment.
  
---

### **4. Restarting FastAPI and NGINX**

Once you’ve updated the FastAPI app, you need to restart the **FastAPI** and **NGINX** services to apply the changes.

#### **Restart FastAPI**

If you’re using **systemd** to manage FastAPI, restart it by running:

```bash
sudo systemctl restart fastapi
```

Check the status to ensure the service is running:

```bash
sudo systemctl status fastapi
```

#### **Restart NGINX**

To restart **NGINX** and ensure everything works properly, run:

```bash
sudo systemctl restart nginx
```

Check the NGINX status:

```bash
sudo systemctl status nginx
```

Both services should be running, and your FastAPI application should now load the **GitHub PAT** from the environment.

---

### **Conclusion**

In this chapter, you have learned how to:
1. **Generate a GitHub PAT**.
2. **Store the PAT securely** using environment variables in **`.bashrc`** on a Lightsail instance.
3. **Update the FastAPI app** to load the PAT from the environment.
4. **Restart the FastAPI and NGINX services** to apply changes without rebooting the instance.

Your FastAPI app can now securely interact with the GitHub API, using environment variables to manage sensitive tokens.