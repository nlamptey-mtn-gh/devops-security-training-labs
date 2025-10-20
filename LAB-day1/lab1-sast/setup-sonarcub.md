## 🧰 **SonarQube Setup on Local Machine using Docker Desktop**

> **Disclaimer:**
> SonarQube is resource-intensive. For smooth performance, allocate **at least 2 CPUs and 4GB RAM** in Docker Desktop settings.

---

### **1️⃣ Prerequisites**

* Docker Desktop is already installed and running.
* You have a [Ngrok](https://ngrok.com/) account (free tier works fine) or any similar tunneling tool (e.g., LocalTunnel, Cloudflare Tunnel).

---

### **2️⃣ Pull the SonarQube Docker Image**

```bash
docker pull sonarqube:25.8.0.112029-community
```

This downloads the **SonarQube LTS (Long-Term Support)** version.

---

### **3️⃣ Run SonarQube Container Locally**

Run the container using Docker Desktop or the CLI:

```bash
docker run -d --name sonarqube \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  -p 9000:9000 \
  sonarqube:25.8.0.112029-community
```
fe30d59d9149c10cc

**Explanation:**

* `-d` → Run in background.
* `--name sonarqube` → Container name.
* `-e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true` → Disables Elasticsearch bootstrap checks.
* `-p 9000:9000` → Maps SonarQube to port `9000` on your host.

---

### **4️⃣ Verify Container Status**

```bash
docker ps
```

You should see a container named **sonarqube** running.
Then, open SonarQube in your browser:

👉 [http://localhost:9000](http://localhost:9000)

**Default credentials:**

* **Username:** `admin`
* **Password:** `admin`

---

### **5️⃣ Expose SonarQube via Public Domain using Ngrok**

If you want to access SonarQube remotely or connect CI/CD tools (like GitHub Actions or Azure DevOps), expose it via a tunnel.

#### **Option A: Using Ngrok**

1. Install Ngrok:

   ```bash
   brew install ngrok/ngrok/ngrok     # macOS
   choco install ngrok                 # Windows (Chocolatey)
   ```

2. Authenticate Ngrok:

   ```bash
   ngrok config add-authtoken <YOUR_NGROK_AUTHTOKEN>
   ```

3. Start a tunnel to your local SonarQube port:

   ```bash
   ngrok http 9000
   ```

4. Ngrok will output a public forwarding URL like:

   ```
   Forwarding                    https://abcd1234.ngrok.io -> http://localhost:9000
   ```

   Use this URL as your **SonarQube server URL** in CI/CD pipelines or webhooks.

---

#### **Option B: Using Cloudflare Tunnel (Persistent Custom Domain)**

If you have your own domain (e.g., `mysite.com`):

1. Install Cloudflare Tunnel (Cloudflared):

   ```bash
   brew install cloudflare/cloudflare/cloudflared
   ```

2. Authenticate:

   ```bash
   cloudflared tunnel login
   ```

3. Create a tunnel:

   ```bash
   cloudflared tunnel create sonarqube-tunnel
   ```

4. Run the tunnel:

   ```bash
   cloudflared tunnel --url http://localhost:9000
   ```

5. In your Cloudflare dashboard, map a subdomain (e.g., `sonarqube.mysite.com`) to the tunnel.

---

### **6️⃣ (Optional) Persist Data Between Restarts**

To ensure SonarQube data is not lost when the container restarts, use Docker volumes:

```bash
docker run -d --name sonarqube \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:9.9-community
```

---

### ✅ **Done!**

* Local access: [http://localhost:9000](http://localhost:9000)
* Public access: via your Ngrok/Cloudflare URL
* Default login: `admin / admin`


