# app/services/sunrise_sunset_service.rb
require 'httparty'
require 'time'

class SunriseSunsetService
  include HTTParty
  base_uri 'https://api.sunrisesunset.io'

  def initialize(lat:, lng:)
    @lat = lat
    @lng = lng
  end

  def fetch_for(date)
    formatted_date = date.strftime("%Y-%m-%d")
    response = self.class.get("/json", query: { lat: @lat, lng: @lng, date: formatted_date })
    raise "Error al llamar Sunrise-Sunset API: #{response.code}" unless response.success?

    results = response.parsed_response['results']
    raise "Respuesta inesperada de la API" unless results

    sunrise_str = results['sunrise']  # ej. "5:54:00 AM"
    sunset_str  = results['sunset']   # ej. "6:01:00 PM"

    # Combina fecha + hora, sin zona; Ruby usará tu zona local pero la fecha viene fija
    sunrise_time = DateTime.strptime(
      "#{formatted_date} #{sunrise_str}",
      "%Y-%m-%d %I:%M:%S %p"
    ).to_time

    sunset_time = DateTime.strptime(
      "#{formatted_date} #{sunset_str}",
      "%Y-%m-%d %I:%M:%S %p"
    ).to_time

    {
      sunrise_time:      sunrise_time,
      sunset_time:       sunset_time,
      golden_hour_start: sunrise_time + 1.hour,
      golden_hour_end:   sunset_time  - 1.hour
    }
  rescue JSON::ParserError, NoMethodError
    raise "Respuesta inesperada de Sunrise-Sunset API"
  end
end
