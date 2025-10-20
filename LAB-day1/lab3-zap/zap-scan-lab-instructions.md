# 🧪 **OWASP ZAP DAST Lab Guide **

## **Objective**

**Perform Dynamic Application Security Testing (DAST)** using **OWASP ZAP** in a Linux environment.
You’ll install dependencies, set up ZAP, run different scan modes (Quick, Spider, Active), and export reports — all without root privileges.

---

## **A. Prerequisites**

Before starting, verify that your environment meets the following:

```bash
# Verify curl availability
curl --version

# Check Java installation (ZAP requires Java 17+)
java -version
```

If Java is missing or outdated, follow the next section.

---

## **B. Install Java (If Missing)**

```bash
# Create a directory for Java
mkdir -p ~/java
cd ~/java

# Download and extract OpenJDK 17
curl -L https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz -o openjdk17.tar.gz
tar -xzf openjdk17.tar.gz

# Add Java to PATH
echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"' > set_java_home.sh
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> set_java_home.sh
source set_java_home.sh

# Verify installation
java -version
```

✅ **Expected Result:**
`java version "17.0.2"` or higher

---

## **C. Download and Setup OWASP ZAP**

```bash
# Create directory for security tools
mkdir -p ./security-tools
cd ./security-tools

# Download OWASP ZAP
curl -L https://github.com/zaproxy/zaproxy/releases/download/v2.16.0/ZAP_2.16.0_Linux.tar.gz -o ZAP_2.16.0_Linux.tar.gz

# Extract and configure
tar -xzf ZAP_2.16.0_Linux.tar.gz
chmod +x ZAP_2.16.0/zap.sh

# Verify ZAP installation
./ZAP_2.16.0/zap.sh -version
```

✅ **Expected Result:**
Displays ZAP version `2.16.0` or higher.

---

## **D. Running DAST Scans**

### **1. Quick Scan**

Performs a basic vulnerability assessment of the target website.

```bash
mkdir -p ./zap-results
cd ./zap-results

./ZAP_2.16.0/zap.sh \
  -cmd -quickurl http://itsecgames.com/ \
  -quickprogress \
  -quickout /Users/nana/Ecobank/Devops/GitHubActions/TrainingRepos/LABS/owasp/security-tools/zap-results/bwapp_quick_scan.html
```

✅ **Expected Result:**
A quick scan report is generated at `./zap-results/bwapp_quick_scan.html`.

---

### **2. Spider Scan**

Crawls the target website to discover URLs and hidden endpoints.

```bash
cd ~/zap-results

~/security-tools/ZAP_2.16.0/zap.sh \
  -cmd -newsession bwapp_spider \
  -spider http://itsecgames.com/ \
  -savesession ~/zap-results/bwapp_spider.session
```

✅ **Expected Result:**
ZAP creates a session file (`bwapp_spider.session`) containing crawled URLs.

---

### **3. Active Scan**

Performs active exploitation attempts on discovered URLs.

```bash
cd ~/zap-results

~/security-tools/ZAP_2.16.0/zap.sh \
  -cmd -newsession bwapp_active \
  -quickurl http://itsecgames.com/ \
  -quickprogress \
  -quickout ~/zap-results/bwapp_active_scan.html
```

✅ **Expected Result:**
ZAP identifies vulnerabilities (e.g., SQLi, XSS, CSRF) and generates an HTML report.

---

## **E. Generating Reports**

ZAP supports HTML and XML reports. Run the following to export results:

```bash
cd ~/zap-results

# HTML Report
~/security-tools/ZAP_2.16.0/zap.sh \
  -cmd -session ~/zap-results/bwapp_spider.session \
  -exportreport ~/zap-results/bwapp_report.html

# XML Report
~/security-tools/ZAP_2.16.0/zap.sh \
  -cmd -session ~/zap-results/bwapp_spider.session \
  -exportreport ~/zap-results/bwapp_report.xml

# Verify output
ls -la ~/zap-results/
```

✅ **Expected Result:**
Reports `bwapp_report.html` and `bwapp_report.xml` are visible in `~/zap-results/`.

---

## **F. Troubleshooting**

| Issue                      | Symptom                    | Solution                                        |
| -------------------------- | -------------------------- | ----------------------------------------------- |
| **Java not found**         | `java: command not found`  | Reinstall using Section B                       |
| **Permission denied**      | ZAP scripts not executable | `chmod +x ~/security-tools/ZAP_2.16.0/zap.sh`   |
| **Output directory error** | “directory not writable”   | Use full writable path (e.g., `~/zap-results/`) |

---

## **G. Quick Reference Commands**

```bash
# Navigate to installation
cd ~/security-tools

# Check ZAP version
./ZAP_2.16.0/zap.sh -version

# Quick Scan
./ZAP_2.16.0/zap.sh -cmd -quickurl http://itsecgames.com/ -quickout ~/zap-results/scan.html -quickprogress

# Spider Only
./ZAP_2.16.0/zap.sh -cmd -spider http://itsecgames.com/

# Active Scan
./ZAP_2.16.0/zap.sh -cmd -newsession bwapp_active -quickurl http://itsecgames.com/ -quickout ~/zap-results/active_scan.html
```

---

## **H. Success Indicators**

* ✅ Java version ≥ 17
* ✅ ZAP version displays correctly
* ✅ Scan results successfully generated under `~/zap-results/`
* ✅ No permission or path errors encountered
* ✅ HTML reports open correctly in browser

---

## **Important Notes**

* ⚠️ **Only scan websites you own or have explicit permission to test.**
* ZAP requires **Java 17+** for reliable execution.
* The target `http://itsecgames.com` is a **safe, intentionally vulnerable test site**.
* All scans are run without `sudo` privileges for isolation.
* Results are stored in `~/zap-results/`.
