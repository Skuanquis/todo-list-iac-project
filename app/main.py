from flask import Flask, jsonify, render_template, request

app = Flask(__name__)

tareas = []
siguiente_id = 1


def buscar_tarea(tarea_id):
    return next((t for t in tareas if t["id"] == tarea_id), None)


@app.get("/")
def inicio():
    return render_template("index.html")


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/api/tareas")
def listar_tareas():
    return jsonify(tareas)


@app.post("/api/tareas")
def crear_tarea():
    global siguiente_id
    datos = request.get_json(silent=True) or {}
    titulo = str(datos.get("titulo", "")).strip()
    if not titulo:
        return jsonify(error="El titulo es obligatorio"), 400

    tarea = {"id": siguiente_id, "titulo": titulo, "completada": False}
    siguiente_id += 1
    tareas.append(tarea)
    return jsonify(tarea), 201


@app.put("/api/tareas/<int:tarea_id>")
def actualizar_tarea(tarea_id):
    tarea = buscar_tarea(tarea_id)
    if tarea is None:
        return jsonify(error="Tarea no encontrada"), 404

    datos = request.get_json(silent=True) or {}
    if "titulo" in datos:
        titulo = str(datos["titulo"]).strip()
        if not titulo:
            return jsonify(error="El titulo es obligatorio"), 400
        tarea["titulo"] = titulo
    if "completada" in datos:
        tarea["completada"] = bool(datos["completada"])
    return jsonify(tarea)


@app.delete("/api/tareas/<int:tarea_id>")
def eliminar_tarea(tarea_id):
    tarea = buscar_tarea(tarea_id)
    if tarea is None:
        return jsonify(error="Tarea no encontrada"), 404

    tareas.remove(tarea)
    return "", 204


if __name__ == "__main__":
    app.run(port=8000)
