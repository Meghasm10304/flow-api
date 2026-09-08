# 1. Create the project folder
# mkdir flow-api && cd flow-api

# 2. Create directory structure
mkdir -p app tests docs

# 3. Create .gitignore
cat <<EOT > .gitignore
__pycache__/
*.pyc
.pytest_cache/
.env
venv/
*.log
EOT

# 4. Create requirements.txt
cat <<EOT > requirements.txt
flask==3.0.3
pytest==8.2.0
gunicorn==22.0.0
EOT

# 5. Create app/__init__.py (Empty file for Python package)
touch app/__init__.py

# 6. Create app/main.py (The App + Documentation Page)
cat <<EOT > app/main.py
from flask import Flask, jsonify, render_template_string
import os

app = Flask(__name__)

ABOUT_HTML = """
<!doctype html>
<html>
<head>
  <title>Flow-API — Project Overview</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; line-height: 1.5; color: #222; background: #fafafa; }
    .container { max-width: 900px; margin: 0 auto; background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    h1 { font-size: 1.8rem; margin-bottom: 0.5rem; color: #1a1a1a; }
    h2 { font-size: 1.3rem; margin-top: 1.5rem; border-bottom: 1px solid #eee; padding-bottom: 0.5rem; }
    pre { background: #f6f6f6; padding: 1rem; border-radius: 6px; overflow-x: auto; font-size: 0.9rem; }
    .badge { display: inline-block; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.8rem; background: #e3f2fd; color: #0d47a1; margin-right: 5px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin: 1rem 0; }
    .card { border: 1px solid #e0e0e0; border-radius: 8px; padding: 1rem; background: #fcfcfc; }
    a { color: #1a6eff; text-decoration: none; }
    .fail { color: #d32f2f; font-weight: bold; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Flow-API: Automated Deployment</h1>
    <p>
      <span class="badge">Flask</span>
      <span class="badge">Docker</span>
      <span class="badge">Jenkins</span>
      <span class="badge">CI/CD</span>
    </p>
    
    <h2>📌 What is this?</h2>
    <p>This is a production-ready API demonstration showing how code moves from a developer's machine to a running container automatically.</p>

    <h2>🏗️ Architecture</h2>
    <p><em>(Diagram: Developer → Git → Jenkins → Docker → Health Check)</em></p>

    <h2>🛠️ Endpoints</h2>
    <ul>
      <li><code>/</code> — Welcome message</li>
      <li><code>/health</code> — Liveness probe (used by CI)</li>
      <li><code>/version</code> — Build version info</li>
    </ul>

    <h2>🧠 Engineering Decisions</h2>
    <div class="grid">
      <div class="card"><strong>Why Docker?</strong><br/>Consistent runtime. No "works on my machine" issues.</div>
      <div class="card"><strong>Why Jenkins?</strong><br/>Pipeline-as-code. Visible, debuggable automation.</div>
      <div class="card"><strong>Why pytest?</strong><br/>Fast feedback. Tests run before deployment.</div>
    </div>

    <h2>🐛 Failure Log</h2>
    <ul>
      <li><span class="fail">Issue:</span> Jenkins permission denied.<br><strong>Fix:</strong> Mounted Docker socket.</li>
      <li><span class="fail">Issue:</span> Health check timeout.<br><strong>Fix:</strong> Added sleep delay in pipeline.</li>
    </ul>
  </div>
</body>
</html>
"""

@app.route("/")
def index():
    return jsonify({"message": "Flow-API is running", "docs": "/about"})

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

@app.route("/version")
def version():
    return jsonify({
        "version": os.getenv("APP_VERSION", "0.1.0"),
        "environment": os.getenv("ENVIRONMENT", "development")
    })

@app.route("/about")
def about():
    return render_template_string(ABOUT_HTML)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOT

# 7. Create tests/test_app.py
cat <<EOT > tests/test_app.py
import pytest
from app.main import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as c:
        yield c

def test_index(client):
    assert client.get("/").status_code == 200

def test_health(client):
    assert client.get("/health").json["status"] == "healthy"

def test_version(client):
    assert "version" in client.get("/version").json
EOT

# 8. Create Dockerfile
cat <<EOT > Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.main:app"]
EOT

# 9. Create Jenkinsfile
cat <<EOT > Jenkinsfile
pipeline {
    agent any
    environment {
        APP_VERSION = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Install') { steps { sh 'pip install -r requirements.txt' } }
        stage('Test') { steps { sh 'pytest tests/ -v' } }
        stage('Build') { steps { sh 'docker build -t flow-api:${BUILD_NUMBER} .' } }
        stage('Deploy') {
            steps {
                sh 'docker stop flow-api || true'
                sh 'docker rm flow-api || true'
                sh 'docker run -d -p 5000:5000 --name flow-api flow-api:${BUILD_NUMBER}'
            }
        }
        stage('Verify') { steps { sh 'sleep 3 && curl -f http://localhost:5000/health' } }
    }
}
EOT

# 10. Create README.md (The Professional Documentation)
cat <<EOT > README.md
# Flow-API

**Automated Python API Deployment Pipeline**

A lightweight Flask API demonstrating a complete CI/CD workflow using Git, Jenkins, and Docker. The focus is not on the application logic, but on the **automation infrastructure** surrounding it.

## 🚀 Quick Start

\`\`\`bash
# Run locally
pip install -r requirements.txt
python -m app.main

# Run with Docker
docker build -t flow-api .
docker run -p 5000:5000 flow-api
\`\`\`

## 🏗️ Architecture

Developer → Git → Jenkins (CI) → Docker Build → Deploy → Health Check

## 🧠 Why This Project?

This project demonstrates that I understand how software moves from source code to production. It covers:
- **Containerization:** Docker for consistent environments.
- **CI/CD:** Jenkins for automated testing and deployment.
- **Reliability:** Health checks and failure handling.

## 📚 Documentation

Visit the live documentation endpoint:
\`\`\`
GET /about
\`\`\`
EOT

# 11. Initialize Git and Push
git init
git add .
git commit -m "feat: initial commit - Flow-API project structure"
git branch -M main

echo "✅ Project created. Now go to GitHub, create a new repo named 'flow-api', and run the commands below:"