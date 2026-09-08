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
