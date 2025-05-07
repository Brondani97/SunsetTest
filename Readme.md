# Sunrise Sunset App

Este repositorio contiene dos proyectos: el **backend** en Ruby on Rails y el **frontend** en React (Vite).

## 🖥️ Backend (Rails API)

### Requisitos

- Ruby 3.x
- Rails 8.x
- SQLite3
- Bundler

### Setup

1. Clonar el repositorio y entrar al directorio del backend:
git clone <URL_DEL_REPO>
cd back-end

2. Instalar dependencias:
* run bundle install en bash

3. Crear y migrar la base de datos:
* rails db:create db:migrate

4. Arrancar el servidor:
rails s -p 3000

### Endpoints

- **GET** `/api/v1/day_records`
Parámetros:
- `name` (string): Nombre de la ubicación.
- `start_date` (MM-DD-YYYY): Fecha de inicio.
- `end_date` (MM-DD-YYYY): Fecha de fin.

Ejemplo:
curl "http://localhost:3000/api/v1/day_records?name=Lisbon&start_date=05-05-2025&end_date=05-07-2025"


Respuesta (JSON):
[
  {
    "date": "05-05-2025",
    "sunrise_time": "05-05-2025 06:35",
    "sunset_time": "05-05-2025 18:45",
    "golden_hour_start": "05-05-2025 07:35",
    "golden_hour_end": "05-05-2025 17:45"
  }
]


🌐 Frontend (React + Vite)


Requisitos
* Node.js ≥ 16.x
* npm

Setup
1.Entrar al directorio del frontend:
cd front-end

2. Instalar dependencias
npm install
npm install chart.js react-chartjs-2

3. Levantar el servidor de desarrollo
npm run dev

Encontraras la app en http://localhost:5173


--------------------------------------------------------------------------
Validaciones y estilos
Se valida que Ciudad no esté vacío y que las fechas cumplan el formato MM-DD-YYYY.

El botón Consultar queda deshabilitado hasta que los campos sean válidos.

Mensajes de error se muestran debajo del formulario.

El layout es responsive: en móvil los inputs se apilan, en desktop se alinean en fila.

Uso:
Ingresar el nombre de la ciudad.

Ingresar fecha de inicio y fecha de fin en formato MM-DD-YYYY.

Hacer click en Consultar.

Ver los resultados en la tabla y el gráfico.



📄 Notas
El backend maneja caching: una vez consultado un rango, los datos se guardan en la base y se reutilizan.
Para producción, configura CORS de forma restrictiva y reemplaza SQLite por PostgreSQL u otra base de datos.



TESTEO:
TRANSACTION (0.1ms)  COMMIT TRANSACTION /*action='index',application='BackEnd',controller='day_records'*/
↳ app/controllers/api/v1/day_records_controller.rb:53:in `day_record_for'
Completed 200 OK in 199890ms (Views: 1.5ms | ActiveRecord: 1275.9ms (734 queries, 0 cached) | GC: 1.4ms)


SE TESTEO CON UN RANGO DE FECHAS DE 1 AÑO:

"Parana 05-05-2025 05-07-2026"
