# Flow-API

**Automated Python API Deployment Pipeline**

A lightweight Flask API demonstrating a complete CI/CD workflow using Git, Jenkins, and Docker. The focus is not on the application logic, but on the **automation infrastructure** surrounding it.

## 🚀 Quick Start

```bash
# Run locally
pip install -r requirements.txt
python -m app.main

# Run with Docker
docker build -t flow-api .
docker run -p 5000:5000 flow-api
```

## 🏗️ Architecture

Developer → Git → Jenkins (CI) → Docker Build → Deploy → Health Check

## 🧠 Why This Project?

This project demonstrates that I understand how software moves from source code to production. It covers:
- **Containerization:** Docker for consistent environments.
- **CI/CD:** Jenkins for automated testing and deployment.
- **Reliability:** Health checks and failure handling.

## 📚 Documentation

Visit the live documentation endpoint:
```
GET /about
```
