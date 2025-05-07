// src/App.jsx
import React, { useState } from 'react';
import { Line } from 'react-chartjs-2';
import 'chart.js/auto';
import './App.css';

export default function App() {
  const [location, setLocation] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Validaciones de entrada
  const dateRegex = /^\d{2}-\d{2}-\d{4}$/;
  const isValid =
    location.trim() !== '' &&
    dateRegex.test(startDate) &&
    dateRegex.test(endDate) &&
    new Date(startDate) <= new Date(endDate);

  const fetchData = async () => {
    if (!isValid) {
      setError('Por favor completa campos con formato MM-DD-YYYY y fechas válidas.');
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(
        `http://localhost:3000/api/v1/day_records?name=${encodeURIComponent(
          location
        )}&start_date=${startDate}&end_date=${endDate}`
      );
      if (!res.ok) throw new Error('Error en la petición');
      const data = await res.json();
      setRecords(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const labels = records.map(r => r.date);
  const parseHour = datetime => {
    const parts = datetime.split(' ')[1].split(':').map(Number);
    return parts[0] + parts[1] / 60;
  };
  const sunriseData = records.map(r => parseHour(r.sunrise_time));
  const sunsetData = records.map(r => parseHour(r.sunset_time));

  const chartData = {
    labels,
    datasets: [
      { label: 'Amanecer (h)', data: sunriseData, tension: 0.3 },
      { label: 'Atardecer (h)', data: sunsetData, tension: 0.3 }
    ]
  };

  return (
    <div className="p-4 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Sunrise Sunset App</h1>

      <div className="flex flex-wrap sm:flex-nowrap space-x-0 sm:space-x-2 mb-4">
        <input
          className="border p-2 flex-1 mb-2 sm:mb-0"
          placeholder="Ciudad"
          value={location}
          onChange={e => setLocation(e.target.value)}
        />
        <input
          className="border p-2 w-full sm:w-32 mb-2 sm:mb-0"
          placeholder="MM-DD-YYYY"
          value={startDate}
          onChange={e => setStartDate(e.target.value)}
        />
        <input
          className="border p-2 w-full sm:w-32 mb-2 sm:mb-0"
          placeholder="MM-DD-YYYY"
          value={endDate}
          onChange={e => setEndDate(e.target.value)}
        />
        <button
          className={`px-4 py-2 rounded text-white ${
            isValid ? 'bg-blue-500 hover:bg-blue-600' : 'bg-gray-400 cursor-not-allowed'
          }`}
          onClick={fetchData}
          disabled={!isValid}
        >
          Consultar
        </button>
      </div>

      {loading && <p>Cargando...</p>}
      {error && <p className="text-red-500 mb-4">{error}</p>}

      {records.length > 0 && (
        <>
          <table className="w-full border-collapse mb-4">
            <thead>
              <tr>
                <th className="border p-2">Fecha</th>
                <th className="border p-2">Amanecer</th>
                <th className="border p-2">Atardecer</th>
                <th className="border p-2">Golden Start</th>
                <th className="border p-2">Golden End</th>
              </tr>
            </thead>
            <tbody>
              {records.map((r, idx) => (
                <tr key={idx} className="even:bg-gray-50">
                  <td className="border p-2">{r.date}</td>
                  <td className="border p-2">{r.sunrise_time.split(' ')[1]}</td>
                  <td className="border p-2">{r.sunset_time.split(' ')[1]}</td>
                  <td className="border p-2">{r.golden_hour_start.split(' ')[1]}</td>
                  <td className="border p-2">{r.golden_hour_end.split(' ')[1]}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <Line data={chartData} />
        </>
      )}
    </div>
  );
}
