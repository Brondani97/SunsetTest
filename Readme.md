# Sunrise Sunset App

This repository contains two projects: the **backend** in Ruby on Rails and the **frontend** in React (Vite).

## 🖥️ Backend (Rails API)

### Requirements

- Ruby 3.x  
- Rails 8.x  
- SQLite3  
- Bundler  

### Setup

1. Clone the repository and navigate to the backend directory:  
   
   cd back-end

2. Install dependencies:  
   
   bundle install
   

3. Create and migrate the database:  
   
   rails db:create db:migrate
   

4. Start the server on port 3000:  
   
   rails s -p 3000
   

### Endpoints

- **GET** `/api/v1/day_records`  
  **Parameters:**  
  - `name` (string): The location name.  
  - `start_date` (MM-DD-YYYY): Start date.  
  - `end_date` (MM-DD-YYYY): End date.  

  **Example:**  
  
  curl "http://localhost:3000/api/v1/day_records?name=Lisbon&start_date=05-05-2025&end_date=05-07-2025"
  

  **Example Response (JSON):**  
  [
    {
      "date": "05-05-2025",
      "sunrise_time": "05-05-2025 06:35",
      "sunset_time": "05-05-2025 18:45",
      "golden_hour_start": "05-05-2025 07:35",
      "golden_hour_end": "05-05-2025 17:45"
    }
  ]

---

## 🌐 Frontend (React + Vite)

### Requirements

- Node.js ≥ 16.x  
- npm  

### Setup

1. Navigate to the frontend directory:  
   
   cd front-end
   

2. Install dependencies:  
   
   npm install
   npm install chart.js react-chartjs-2
   

3. Start the development server:  
   
   npm run dev
   

4. Open the app in your browser at:  
   
   http://localhost:5173
   

---

## Validations & Styling

- **City** field must not be empty and dates must follow the `MM-DD-YYYY` format.  
- The **Consult** button is disabled until all inputs are valid.  
- Error messages appear below the form.  
- Responsive layout: inputs stack on mobile and align in a row on desktop.

---

## Usage

1. Enter the **city name**.  
2. Enter the **start date** and **end date** in `MM-DD-YYYY` format.  
3. Click **Consult**.  
4. View the results in the **table** and **chart**.

---

## Notes

- The backend implements caching: once a date range is requested, its data is stored and reused.  
- For production, tighten your CORS settings and replace SQLite with PostgreSQL or another database.

---

## Testing Example

You can test a large range (e.g., one year) as follows:


curl "http://localhost:3000/api/v1/day_records?name=Parana&start_date=05-05-2025&end_date=05-07-2026"


In the Rails logs you should see something like:

TRANSACTION (0.1ms)  COMMIT TRANSACTION
↳ app/controllers/api/v1/day_records_controller.rb:53:in `day_record_for'
Completed 200 OK in 199890ms (Views: 1.5ms | ActiveRecord: 1275.9ms (734 queries, 0 cached) | GC: 1.4ms)
