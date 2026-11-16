const API = '/api/tareas';
const formulario = document.getElementById('formulario');
const campoTitulo = document.getElementById('titulo');
const lista = document.getElementById('tareas');
const vacio = document.getElementById('vacio');
const resumen = document.getElementById('resumen');

async function cargarTareas() {
  const respuesta = await fetch(API);
  mostrarTareas(await respuesta.json());
}

function mostrarTareas(tareas) {
  lista.innerHTML = '';
  tareas.forEach((tarea) => lista.appendChild(crearElemento(tarea)));

  const pendientes = tareas.filter((tarea) => !tarea.completada).length;
  vacio.hidden = tareas.length > 0;
  resumen.textContent = tareas.length ? `${pendientes} pendientes de ${tareas.length}` : '';
}

function crearElemento(tarea) {
  const item = document.createElement('li');
  if (tarea.completada) {
    item.classList.add('completada');
  }

  const casilla = document.createElement('input');
  casilla.type = 'checkbox';
  casilla.checked = tarea.completada;
  casilla.addEventListener('change', () => cambiarEstado(tarea.id, casilla.checked));

  const titulo = document.createElement('span');
  titulo.textContent = tarea.titulo;

  const eliminar = document.createElement('button');
  eliminar.textContent = 'Eliminar';
  eliminar.addEventListener('click', () => eliminarTarea(tarea.id));

  item.append(casilla, titulo, eliminar);
  return item;
}

async function cambiarEstado(id, completada) {
  await fetch(`${API}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ completada }),
  });
  cargarTareas();
}

async function eliminarTarea(id) {
  await fetch(`${API}/${id}`, { method: 'DELETE' });
  cargarTareas();
}

formulario.addEventListener('submit', async (evento) => {
  evento.preventDefault();
  const titulo = campoTitulo.value.trim();
  if (!titulo) {
    return;
  }

  await fetch(API, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ titulo }),
  });
  campoTitulo.value = '';
  cargarTareas();
});

cargarTareas();
