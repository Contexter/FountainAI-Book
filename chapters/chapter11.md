## Chapter 11: Deploying the FastAPI Proxy for the GPT Repository Controller

### Introduction: Extending the Feedback Loop

In **Chapter 10**, we introduced the **custom GPT model** integrated with **GitHub’s OpenAPI** ( - actually *RestAPI* - but we wrap it into the **OpenAPI** format). This setup allows real-time monitoring and feedback on the repository’s activity. In **Chapter 11**, we will focus on deploying the **FastAPI Proxy**, which serves as the communication interface between the GPT model and the GitHub repository.

A crucial aspect of this workflow is setting up **SSH keys** for secure communication between the **Lightsail Ubuntu machine** and **GitHub**. This setup will allow you to edit code locally, push the changes to **GitHub**, and then pull them onto the **Lightsail Ubuntu server** using the **AWS-provided shell**.

The deployed FastAPI proxy can be accessed and tested here:  
**[Deployed Proxy Server](https://proxy.fountain.coach/docs)**

The source code for the FastAPI proxy is available here:  
**[FastAPI Proxy GitHub Repository](https://github.com/Contexter/fountainai-fastapi-proxy)**

---

### Setting Up SSH Keys for GitHub Integration

#### Why SSH Keys are Needed

To securely pull changes from GitHub to the Ubuntu server on AWS, we will configure **SSH keys**. This ensures the Lightsail instance can communicate with GitHub securely, allowing you to **push changes from your local machine to GitHub** and **pull those changes on the Ubuntu server**.

### Step-by-Step Deployment Guide

---

#### Step 1: Create and Configure an AWS Lightsail Instance

1. **Log in to AWS Lightsail** and create a new instance:
   - **Platform**: Linux/Unix.
   - **Operating System**: Ubuntu 22.04 LTS.
   - **Instance plan**: Start with a plan that suits your needs (512MB RAM should be sufficient).
2. **Name your instance** and take note of the **public IP address**.

---

#### Step 2: DNS Configuration with AWS Route 53

Since AWS is the registrar for **fountain.coach**, use **AWS Route 53** for DNS management.

1. **Access Route 53** and ensure a **Hosted Zone** exists for **fountain.coach**.
2. **Create an A Record**:
   - **Name**: Set this to `proxy.fountain.coach`.
   - **Value**: Enter the **public IP address** of your Lightsail instance.
3. Use tools like **dig** or **nslookup** to verify DNS propagation.

---

#### Step 3: Networking and Firewall Configuration on Lightsail

1. In the **Networking tab** of your Lightsail instance, add the following **firewall rules**:
   - **Port 80** for HTTP traffic.
   - **Port 443** for HTTPS traffic.
   - **Port 22** for SSH, enabling secure access to your instance.
2. **Save the firewall settings** and verify that your instance can be accessed via HTTP and HTTPS.

---

#### Step 4: SSH into the Lightsail Instance Using the AWS-Provided Shell

1. Use the **AWS-provided shell** to access your Lightsail instance:
   - Open your instance in AWS Lightsail and click **Connect** using the browser-based shell.

2. **Update your system**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **Install the necessary packages**:
   ```bash
   sudo apt install python3-pip python3-venv nginx git -y
   ```

---

#### Step 5: Set Up SSH Keys for GitHub Access

1. **Generate SSH keys** on your Lightsail instance:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   Press **Enter** to accept the default location. When prompted for a passphrase, you can leave it blank or add one.

2. **View and copy the public SSH key**:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   Copy the output of this command.

3. **Add the SSH key to GitHub**:
   - In GitHub, go to **Settings** > **SSH and GPG keys** > **New SSH key**.
   - Paste the copied public key into the key field and give it a name.
   - Click **Add SSH Key**.

4. **Test the SSH connection** between your Lightsail instance and GitHub:
   ```bash
   ssh -T git@github.com
   ```
   You should see a message confirming that the connection is successful.

---

#### Step 6: Local Code Editing and Push-Pull Workflow

To avoid formatting issues with editors like **nano** in the AWS-provided shell, **edit your code locally** on your development machine. Once changes are ready:

1. **Push the changes to GitHub** from your local machine:
   ```bash
   git add .
   git commit -m "Update FastAPI proxy"
   git push origin main
   ```

2. **Pull the changes on your Lightsail instance** using the AWS-provided shell:
   ```bash
   git pull origin main
   ```

This workflow ensures that code is edited locally, pushed to GitHub, and securely pulled onto the server.

---

#### Step 7: Deploy the FastAPI Proxy

1. **Clone the FastAPI Proxy repository** to your Lightsail instance:
   ```bash
   git clone git@github.com:Contexter/fountainai-fastapi-proxy.git
   ```

2. **Set up a Python virtual environment**:
   ```bash
   cd fountainai-fastapi-proxy
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install the required dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Test the FastAPI app** by running it locally:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000
   ```

   Visit `http://<instance-public-ip>:8000` to ensure the proxy is running.

---

#### Step 8: Configure Nginx as a Reverse Proxy

To serve the FastAPI app publicly, configure **Nginx** to forward requests.

1. Open the Nginx configuration file:
   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```

2. Modify the configuration:
   ```nginx
   server {
       listen 80;
       server_name proxy.fountain.coach;

       location / {
           proxy_pass http://127.0.0.1:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Restart Nginx**:
   ```bash
   sudo systemctl restart nginx
   ```

---

#### Step 9: Running the FastAPI Proxy as a Systemd Service

To ensure that the FastAPI Proxy runs in the background and automatically starts on boot, configure it using **systemd**.

1. Create a **systemd service file** for FastAPI:
   ```bash
   sudo nano /etc/systemd/system/fastapi.service
   ```

2. Add the following configuration:
   ```ini
   [Unit]
   Description=FastAPI Proxy
   After=network.target

   [Service]
   User=ubuntu
   WorkingDirectory=/home/ubuntu/fountainai-fastapi-proxy
   Environment="PATH=/home/ubuntu/fountainai-fastapi-proxy/venv/bin"
   ExecStart=/home/ubuntu/fountainai-fastapi-proxy/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000

   [Install]
   WantedBy=multi-user.target
   ```

3. **Reload systemd**:
   ```bash
   sudo systemctl daemon-reload
   ```

4. **Start and enable the service**:
   ```bash
   sudo systemctl start fastapi
   sudo systemctl enable fastapi
   ```

---

#### Step 10: Securing the Proxy with SSL

1. Install **Certbot**:
   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   ```

2. Obtain an SSL certificate for your domain:
   ```bash
   sudo certbot --nginx -d proxy.fountain.coach
   ```

3. **Restart Nginx** to apply SSL:
   ```bash
   sudo systemctl restart nginx
   ```

---

### Conclusion: A Key Component in the Feedback Loop

By deploying the **FastAPI Proxy**, you enable the custom GPT model to securely interact with the FountainAI GitHub repository, continuing the feedback loop introduced in **Chapter 10**. This deployment provides the platform with real-time access to repository data and ensures secure, scalable operations.

**[Deployed Proxy Server](https://proxy.fountain.coach/docs)**  
**[FastAPI Proxy GitHub Repository](https://github.com/Contexter/fountainai-fastapi-proxy)**

---

Let me know if this version fits your expectations!