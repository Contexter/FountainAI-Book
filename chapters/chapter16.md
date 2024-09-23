## **Chapter 16: Secure Management and Deployment of GitHub Personal Access Token (PAT) for FastAPI**

### **Introduction**

In this chapter, we will guide you through the following steps:

1. **Generating a GitHub Personal Access Token (PAT)** for use in a FastAPI application.
2. **Persisting the PAT** using environment variables on a Lightsail Ubuntu instance.
3. Updating **FastAPI** to securely load and use the PAT for GitHub API requests.
4. **Restarting FastAPI and NGINX** to apply the changes without rebooting the instance.
5. **Troubleshooting issues** encountered during setup, including handling environment variables, systemd service failures, and port conflicts.

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
    description="This API enables efficient retrieval and management of file content from GitHub repositories.",
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

# More FastAPI endpoints ...
```

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

### **5. Troubleshooting and Issues**

During the process of configuring and deploying the **PAT** on the Lightsail instance, we encountered the following issues and resolutions:

#### **Issue 1: Missing `.env` File**
- Error: `fastapi.service: Failed to load environment files: No such file or directory`.
- Solution: We created the `.env` file and added the `GITHUB_TOKEN`. This was crucial because FastAPI was unable to load the environment variables without it.

#### **Issue 2: Systemd Restart Loop**
- Error: `fastapi.service: Start request repeated too quickly`.
- Solution: This occurred because of a misconfiguration in the systemd service file. We fixed this by adding a restart delay using `RestartSec=5` in the service file to prevent rapid restarts.

#### **Issue 3: Port Conflicts**
- Error: FastAPI was unable to start because port 8000 was already in use.
- Solution: We checked for port conflicts using `lsof -i :8000` and either killed the conflicting process or changed the port FastAPI was using.

---

### **Conclusion**

In this chapter, you have learned how to:
1. **Generate a GitHub PAT**.
2. **Store the PAT securely** using environment variables in **`.bashrc`** on a Lightsail instance.
3. **Update the FastAPI app** to load the PAT from the environment.
4. **Restart the FastAPI and NGINX services** to apply changes without rebooting the instance.
5. **Troubleshoot common issues**, such as missing environment files, systemd restart loops, and port conflicts.

Your FastAPI app can now securely interact with the GitHub API, using environment variables to manage sensitive tokens.

---

Let me know if you need further modifications or have additional details to include!