
## Chapter 11: Building the FastAPI Proxy for the GPT Repository Controller 

In this chapter, we will build and deploy a **FastAPI app** that acts as a **non-destructive proxy** for the GPT model, enabling it to interact with the **FountainAI GitHub deployment repository**. This app will be committed to a **GitHub repository**, then deployed to an **AWS Lightsail** instance. We will secure it using **Let's Encrypt SSL** and configure the DNS using **Route 53** for the domain `proxy.fountain.coach`.

---

### **11.1 Why Use FastAPI as a Proxy for the GPT Model?**

The **FastAPI proxy** allows the GPT model to retrieve real-time data from the **FountainAI GitHub repository** for monitoring, analysis, and introspection. The proxy will use the **GitHub API** to gather important data such as:
1. **Repository metadata** (stars, forks, watchers, visibility).
2. **File contents** and directory structure.
3. **Commit history** for tracking changes over time.
4. **Pull requests** and their statuses.
5. **Issues** and their statuses.
6. **Repository traffic insights** (views and clones).

By using FastAPI, we can create a **scalable** and **high-performance** API proxy that generates **OpenAPI documentation** automatically, ensuring developers can easily interact with the service.

---

### **11.2 Full Implementation of the FastAPI Proxy App**

In this section, we will develop the **FastAPI app** that interacts with the **GitHub API**. The app will expose **read-only endpoints**, ensuring that no destructive actions (e.g., creating or deleting files) are performed on the GitHub repository.

#### **Step 1: Setting Up the FastAPI App**

Start by creating a directory for the project:

```bash
mkdir fountainai-fastapi-proxy
cd fountainai-fastapi-proxy
```

#### **Step 2: Create the FastAPI App Files**

Create a Python file called `main.py` with the following content:

```python
from fastapi import FastAPI, HTTPException, Path
import requests
from typing import Optional

app = FastAPI(
    title="FountainAI GitHub Repository Controller",
    description="A non-destructive proxy to retrieve metadata, file contents, commit history, pull requests, issues, and traffic insights from the FountainAI GitHub repository.",
    version="1.0.0",
    contact={
        "name": "FountainAI Development Team",
        "email": "support@fountainai.dev"
    }
)

GITHUB_API_URL = "https://api.github.com"

# Helper function to make requests to GitHub API
def github_request(endpoint: str, params=None):
    url = f"{GITHUB_API_URL}/{endpoint}"
    headers = {
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers, params=params)
    
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.json())
    
    return response.json()

# 1. Get Repository Information
@app.get("/repo/{owner}/{repo}", operation_id="get_repo_info", summary="Retrieve repository metadata",
         description="Retrieve metadata about the repository, including stars, forks, watchers, open issues, default branch, visibility (public/private), and description.")
def get_repo_info(owner: str = Path(..., description="GitHub username or organization"), 
                  repo: str = Path(..., description="Repository name")):
    """
    Retrieve repository metadata such as stars, forks, watchers, open issues, default branch, visibility, and description.
    """
    endpoint = f"repos/{owner}/{repo}"
    return github_request(endpoint)

# 2. List Repository Contents
@app.get("/repo/{owner}/{repo}/contents", operation_id="list_repo_contents", summary="List repository contents",
         description="List the files and directories in the repository, including file names, file size, type (file or directory), and download URLs.")
def list_repo_contents(owner: str = Path(..., description="GitHub username or organization"), 
                       repo: str = Path(..., description="Repository name"), 
                       path: Optional[str] = Path("", description="Optional path to a specific directory or file.")):
    """
    List the contents of a repository, such as file names, file sizes, and download URLs for files. You can optionally specify a path to retrieve contents of a specific directory or file.
    """
    endpoint = f"repos/{owner}/{repo}/contents/{path}"
    return github_request(endpoint)

# 3. Get File Content
@app.get("/repo/{owner}/{repo}/file/{path:path}", operation_id="get_file_content", summary="Retrieve file content",
         description="Get the content of a specific file in the repository. The content is base64-encoded and must be decoded.")
def get_file_content(owner: str = Path(..., description="GitHub username or organization"), 
                     repo: str = Path(..., description="Repository name"), 
                     path: str = Path(..., description="Path to the file in the repository.")):
    """
    Retrieve the content of a specific file in the repository. The content is returned as a base64-encoded string, which can be decoded to view the file.
    """
    endpoint = f"repos/{owner}/{repo}/contents/{path}"
    return github_request(endpoint)

# 4. Get Commit History
@app.get("/repo/{owner}/{repo}/commits", operation_id="get_commit_history", summary="Retrieve commit history",
         description="Get a list of commits in the repository, including the author, commit message, timestamp, and files changed in each commit.")
def get_commit_history(owner: str = Path(..., description="GitHub username or organization"), 
                       repo: str = Path(..., description="Repository name")):
    """
    Retrieve the commit history of a repository, including the author, commit message, timestamp, and files changed in each commit.
    """
    endpoint = f"repos/{owner}/{repo}/commits"
    return github_request(endpoint)

# 5. List Pull Requests
@app.get("/repo/{owner}/{repo}/pulls", operation_id="list_pull_requests", summary="List pull requests",
         description="Retrieve a list of pull requests for the repository, including title, status (open, closed, merged), author, and review status.")
def list_pull_requests(owner: str = Path(..., description="GitHub username or organization"), 
                       repo: str = Path(..., description="Repository name")):
    """
    List all pull requests for a repository, including the title, status (open, closed, or merged), author, and review status.
    """
    endpoint = f"repos/{owner}/{repo}/pulls"
    return github_request(endpoint)

# 6. List Issues
@app.get("/repo/{owner}/{repo}/issues", operation_id="list_issues", summary="List issues",
         description="Retrieve a list of issues for the repository, including title, status (open or closed), author, and assigned labels.")
def list_issues(owner: str = Path(..., description="GitHub username or organization"), 
                repo: str = Path(..., description="Repository name")):
    """
    List all issues for a repository, including the title, status (open or closed), author, and assigned labels.
    """
    endpoint = f"repos/{owner}/{repo}/issues"
    return github_request(endpoint)

# 7. List Branches
@app.get("/repo/{owner}/{repo}/branches", operation_id="list_branches", summary="List repository branches",
         description="Retrieve a list of branches in the repository, including branch name and whether the branch is protected.")
def list_branches(owner: str = Path(..., description="GitHub username or organization"), 
                  repo: str = Path(..., description="Repository name")):
    """
    List all branches in the repository, including the branch name and whether the branch is protected (i.e., cannot be directly modified).
    """
    endpoint = f"repos/{owner}/{repo}/branches"
    return github_request(endpoint)

# 8. Get Traffic Insights (Views and Clones)
@app.get("/repo/{owner}/{repo}/traffic/views", operation_id="get_traffic_views", summary="Retrieve repository traffic views",
         description="Get the number of views for the repository over a specified time period.")
def get_repo_traffic_views(owner: str = Path(..., description="GitHub username or organization"), 
                           repo: str = Path(..., description="Repository name")):
    """
    Retrieve the number of views the repository has received over a specific time period, providing insights into repository visibility and popularity.
    """
    endpoint = f"repos/{owner}/{repo}/traffic/views"
    return github_request(endpoint)

@app.get("/repo/{owner}/{repo}/traffic/clones", operation_id="get_traffic_clones", summary="Retrieve repository traffic clones",
         description="Get the number of times the repository has been cloned over a specified time period.")
def get_repo_traffic_clones(owner: str = Path(..., description="GitHub username or organization"), 
                            repo: str = Path(..., description="Repository name")):
    """
    Retrieve the number of times the repository has been cloned over a specific time period,

 providing insights into how often the repository is replicated.
    """
    endpoint = f"repos/{owner}/{repo}/traffic/clones"
    return github_request(endpoint)
```

#### **Step 3: Create a `requirements.txt` File**

The `requirements.txt` file will include all the dependencies needed to run the app. Create this file:

```txt
fastapi==0.95.0
uvicorn==0.21.1
requests==2.31.0
certbot==2.5.0
python3-certbot-nginx==2.5.0
```

This file ensures that the correct versions of FastAPI, Uvicorn, Requests, and Certbot are installed.

#### **Step 4: Initialize a GitHub Repository with GitHub CLI**

We will now create a **GitHub repository** for the project using the **GitHub CLI (gh)**.

1. Initialize a Git repository:

```bash
git init
git add .
git commit -m "Initial commit of FastAPI proxy app"
```

2. Create a new repository on GitHub:

```bash
gh repo create fountainai-fastapi-proxy --public --source=. --remote=origin
```

3. Push the code to GitHub:

```bash
git push -u origin main
```

Your FastAPI app is now hosted in a **GitHub repository**.

---

### **Appendix: Quick and Dirty, Secure Deployment of the FastAPI App on AWS Lightsail**

This appendix provides a quick guide to deploying the **FastAPI proxy app** on an **AWS Lightsail** instance, securing it with **Let's Encrypt SSL**, and configuring DNS for `proxy.fountain.coach` using **Route 53**.

---

### **1. Launch a Lightsail Instance**

1. Go to **AWS Lightsail** and click **Create instance**.
2. Select **Linux/Unix** and choose **OS Only (Ubuntu 22.04)**.
3. Choose the **512 MB RAM, 1 vCPU** plan (suitable for a small app).
4. Name the instance (`fountain-proxy-server`).
5. Click **Create instance**.

#### **Step 2: Connect to the Instance**

Once the instance is running, connect to it via SSH:

```bash
ssh ubuntu@<instance-public-ip>
```

Replace `<instance-public-ip>` with the public IP of your instance, available in the Lightsail console.

---

### **2. Set Up the FastAPI App**

#### **Step 1: Update the Server and Install Necessary Packages**

Update the server and install the required packages:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip python3-dev nginx git
```

#### **Step 2: Clone the FastAPI App from GitHub**

Clone the **FastAPI app** that we pushed to GitHub:

```bash
git clone https://github.com/yourusername/fountainai-fastapi-proxy.git
cd fountainai-fastapi-proxy
```

#### **Step 3: Create a Virtual Environment and Install Dependencies**

Create a Python virtual environment and install the dependencies listed in the `requirements.txt`:

```bash
sudo pip3 install virtualenv
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### **Step 4: Test the FastAPI App**

Run the app using **Uvicorn**:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

Visit `http://<instance-public-ip>:8000` to ensure the app is running.

---

### **3. Set Up NGINX as a Reverse Proxy**

#### **Step 1: Install and Configure NGINX**

1. Install **NGINX**:

```bash
sudo apt install nginx
```

2. Create an NGINX configuration file:

```bash
sudo nano /etc/nginx/sites-available/fountain_proxy
```

Add the following configuration (replace `proxy.fountain.coach` with your domain):

```nginx
server {
    server_name proxy.fountain.coach;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen 80;
}
```

3. Enable the NGINX configuration:

```bash
sudo ln -s /etc/nginx/sites-available/fountain_proxy /etc/nginx/sites-enabled/
```

4. Restart NGINX:

```bash
sudo systemctl restart nginx
```

---

### **4. Secure the App with Let's Encrypt SSL**

#### **Step 1: Install Certbot and Obtain SSL Certificates**

Install **Certbot** and the NGINX plugin:

```bash
sudo apt install certbot python3-certbot-nginx
```

Obtain an SSL certificate for the domain:

```bash
sudo certbot --nginx -d proxy.fountain.coach
```

#### **Step 2: Test HTTPS**

Visit `https://proxy.fountain.coach` to confirm the app is running securely.

#### **Step 3: Set Up Automatic Certificate Renewal**

Certbot will automatically handle certificate renewal. You can manually test it by running:

```bash
sudo certbot renew --dry-run
```

---

### **5. Configure DNS in Route 53**

#### **Step 1: Update DNS Settings in Route 53**

1. Go to **Route 53** and select your hosted zone for `fountain.coach`.
2. Create a new **A Record**:
   - **Name**: `proxy.fountain.coach`
   - **Type**: A
   - **Value**: The public IP of your Lightsail instance.

#### **Step 2: Verify DNS Propagation**

Once DNS has propagated, visit `https://proxy.fountain.coach` to ensure the app is accessible with SSL.

---

### **6. Automate Uvicorn with Systemd**

#### **Step 1: Create a Systemd Service for Uvicorn**

Create a **systemd** service file to ensure Uvicorn runs on boot:

```bash
sudo nano /etc/systemd/system/uvicorn.service
```

Add the following configuration:

```ini
[Unit]
Description=Uvicorn instance to serve FastAPI app
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/fountainai-fastapi-proxy
ExecStart=/home/ubuntu/fountainai-fastapi-proxy/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000

[Install]
WantedBy=multi-user.target
```

#### **Step 2: Enable and Start the Service**

Enable the service:

```bash
sudo systemctl enable uvicorn
sudo systemctl start uvicorn
```

Check the status:

```bash
sudo systemctl status uvicorn
```

---

### **Conclusion**

You have now built and deployed the **FastAPI proxy app** on an **AWS Lightsail** instance, secured it with **Let's Encrypt SSL**, and configured the DNS for `proxy.fountain.coach` using **Route 53**. The app is running securely and is accessible with a valid SSL certificate.