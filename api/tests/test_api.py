from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from main import app

client = TestClient(app)


@patch("main.r")
def test_create_job_returns_job_id(mock_redis):
    mock_redis.lpush = MagicMock(return_value=1)
    mock_redis.hset = MagicMock(return_value=1)
    response = client.post("/jobs")
    assert response.status_code == 200
    assert "job_id" in response.json()


@patch("main.r")
def test_get_job_status_returns_status(mock_redis):
    mock_redis.hget = MagicMock(return_value=b"queued")
    response = client.get("/jobs/test-id-123")
    assert response.status_code == 200
    assert response.json()["status"] == "queued"


@patch("main.r")
def test_get_job_not_found(mock_redis):
    mock_redis.hget = MagicMock(return_value=None)
    response = client.get("/jobs/nonexistent-id")
    assert response.status_code == 200
    assert response.json()["error"] == "not found"


@patch("main.r")
def test_health_endpoint(mock_redis):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"