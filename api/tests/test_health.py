from fastapi.testclient import TestClient

from app.main import app


def test_liveness_does_not_require_database() -> None:
    response = TestClient(app).get("/health/live")

    assert response.status_code == 200
    assert response.json() == {"status": "alive"}
