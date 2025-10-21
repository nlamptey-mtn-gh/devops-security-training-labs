Here’s a refined and properly formatted version of your lab instructions, organized in logical order and cleaned up for clarity:

***

### Mario Game Docker Lab Instructions

**1. Build the Docker image**
```bash
docker build . -t mario-game
```

**2. Verify the image**
```bash
docker images
```

**3. Run the container (interactive test)**
```bash
docker run --rm -it mario-game
```

**4. Run the container with port mapping**
```bash
docker run --rm -it -p 8080:8080 mario-game
```

***

### Tag and Push to Docker Hub

**5. Log in to Docker Hub**
```bash
docker login -u brudex
```

**6. Tag the image for your repository**
```bash
docker tag mario-game devops-tools/mario-game:1.0.0
```

**7. Verify tagged images**
```bash
docker images
```

**8. Push image to Docker Hub repository**
```bash
docker push devops-tools/mario-game:1.0.0
```

**9. (Optional) Tag under your Docker Hub username**
```bash
docker tag devops-tools/mario-game:1.0.0 brudex/devops-tools:mario-game-1.0.0
```

**10. Push tagged image**
```bash
docker push brudex/devops-tools:mario-game-1.0.0
```

***

### Connect to GitHub Repository

**11. Add GitHub remote**
```bash
git remote add origin https://github.com/brudex/devops-training-mario-docker.git
```

***

### SonarQube Setup for Code Quality Analysis

**12. Pull SonarQube image**
```bash
docker pull sonarqube:25.8.0.112029-community
```

**13. Run SonarQube container**
```bash
docker run -d --name sonarqube \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  -p 9000:9000 \
  sonarqube:25.8.0.112029-community
```

***

### Software Bill of Materials (SBOM) with Docker Scout

**14. Analyze SBOM for mario-game**
```bash
docker scout sbom mario-game
```
