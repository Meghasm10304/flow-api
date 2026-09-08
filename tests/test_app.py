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
