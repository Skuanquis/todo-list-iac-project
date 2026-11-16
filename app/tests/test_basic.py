import pytest

import main


@pytest.fixture
def cliente():
    main.tareas.clear()
    main.siguiente_id = 1
    return main.app.test_client()


def test_health(cliente):
    respuesta = cliente.get("/health")

    assert respuesta.status_code == 200
    assert respuesta.get_json() == {"status": "ok"}


def test_pagina_principal(cliente):
    respuesta = cliente.get("/")

    assert respuesta.status_code == 200
    assert "Lista de tareas" in respuesta.get_data(as_text=True)


def test_lista_vacia_al_inicio(cliente):
    assert cliente.get("/api/tareas").get_json() == []


def test_crear_tarea(cliente):
    respuesta = cliente.post("/api/tareas", json={"titulo": "Estudiar Terraform"})

    assert respuesta.status_code == 201
    assert respuesta.get_json() == {"id": 1, "titulo": "Estudiar Terraform", "completada": False}
    assert len(cliente.get("/api/tareas").get_json()) == 1


def test_crear_tarea_sin_titulo(cliente):
    respuesta = cliente.post("/api/tareas", json={"titulo": "   "})

    assert respuesta.status_code == 400


def test_completar_tarea(cliente):
    cliente.post("/api/tareas", json={"titulo": "Escribir el playbook"})

    respuesta = cliente.put("/api/tareas/1", json={"completada": True})

    assert respuesta.status_code == 200
    assert respuesta.get_json()["completada"] is True


def test_actualizar_tarea_inexistente(cliente):
    respuesta = cliente.put("/api/tareas/99", json={"completada": True})

    assert respuesta.status_code == 404


def test_eliminar_tarea(cliente):
    cliente.post("/api/tareas", json={"titulo": "Configurar Jenkins"})

    respuesta = cliente.delete("/api/tareas/1")

    assert respuesta.status_code == 204
    assert cliente.get("/api/tareas").get_json() == []


def test_eliminar_tarea_inexistente(cliente):
    assert cliente.delete("/api/tareas/99").status_code == 404
