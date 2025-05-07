module Api
  module V1
    class DayRecordsController < ApplicationController
      # GET /api/v1/day_records
      def index
        name       = params[:name]
        start_str  = params[:start_date]
        end_str    = params[:end_date]

        # Validaciones básicas
        if name.blank? || start_str.blank? || end_str.blank?
          return render json: { error: "Parámetros faltantes" }, status: :bad_request
        end

        begin
          start_date = Date.strptime(start_str, "%m-%d-%Y")
          end_date   = Date.strptime(end_str,   "%m-%d-%Y")
        rescue ArgumentError
          return render json: { error: "Formato de fecha inválido, use MM-DD-YYYY" }, status: :bad_request
        end

        if start_date > end_date
          return render json: { error: "start_date debe ser ≤ end_date" }, status: :bad_request
        end

        # Buscar o crear Location por nombre
        location = ::Location.find_or_create_by(name: name) do |loc|
          # Como no tenemos lat/lng del input, fijamos dummy 0,0
          loc.latitude  = 0.0
          loc.longitude = 0.0
          loc.timezone  = "UTC"
        end

        # Para cada fecha en el rango, obtener o calcular el registro
        records = (start_date..end_date).map do |date|
          day_record_for(location, date)
        end

        render json: records, status: :ok
      end

      private

      # Busca o genera un DayRecord para la location y fecha dada
      def day_record_for(location, date)
        record = ::DayRecord.find_by(location: location, date: date)
        return serialize(record) if record

        # Como no tenemos lat/lng reales, idealmente en Location se hubieran guardado.
        service = SunriseSunsetService.new(lat: location.latitude, lng: location.longitude)
        data    = service.fetch_for(date)

        record = ::DayRecord.create!(
          location:            location,
          date:                date,
          sunrise_time:        data[:sunrise_time],
          sunset_time:         data[:sunset_time],
          golden_hour_start:   data[:golden_hour_start],
          golden_hour_end:     data[:golden_hour_end]
        )

        serialize(record)
      rescue => e
        # Captura errores de la API o creación
        { date: date, error: "No reconocido o error externo" }
      end

      # Serializa un registro para JSON
      def serialize(record)
        {
          date:                record.date.strftime("%m-%d-%Y"),
          sunrise_time:        record.sunrise_time.strftime("%m-%d-%Y %H:%M"),
          sunset_time:         record.sunset_time.strftime("%m-%d-%Y %H:%M"),
          golden_hour_start:   record.golden_hour_start.strftime("%m-%d-%Y %H:%M"),
          golden_hour_end:     record.golden_hour_end.strftime("%m-%d-%Y %H:%M")
        }
      end
    end
  end
end
