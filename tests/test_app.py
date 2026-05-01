import importlib


def test_index_route_returns_active_color(monkeypatch):
    monkeypatch.setenv("APP_COLOR", "blue")
    monkeypatch.setenv("APP_VERSION", "1.0.0-blue")

    import app.main as main

    importlib.reload(main)
    client = main.app.test_client()

    response = client.get("/")
    payload = response.get_json()

    assert response.status_code == 200
    assert payload["active_color"] == "blue"
    assert "/health" in payload["endpoints"]


def test_health_route_returns_color(monkeypatch):
    monkeypatch.setenv("APP_COLOR", "green")

    import app.main as main

    importlib.reload(main)
    client = main.app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"
    assert response.get_json()["color"] == "green"


def test_version_route_returns_metadata(monkeypatch):
    monkeypatch.setenv("APP_COLOR", "green")
    monkeypatch.setenv("APP_VERSION", "1.1.0-green")

    import app.main as main

    importlib.reload(main)
    client = main.app.test_client()

    response = client.get("/version")
    payload = response.get_json()

    assert response.status_code == 200
    assert payload["app"] == "blue-green-deployment-demo"
    assert payload["color"] == "green"
    assert payload["version"] == "1.1.0-green"
