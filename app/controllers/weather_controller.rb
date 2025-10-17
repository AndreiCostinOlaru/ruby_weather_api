require "httparty"

class WeatherController < ApplicationController
  include HTTParty

  def weekly_forecast
    city = params[:city]
    return render json: { error: "City parameter is required" }, status: 400 unless city

    coords = get_city_coordinates(city)
    return render json: { error: "City not found" }, status: 404 unless coords

    response = HTTParty.get("https://api.open-meteo.com/v1/forecast", {
      query: {
        latitude: coords[:lat],
        longitude: coords[:lng],
        daily: "temperature_2m_max,temperature_2m_min,weather_code",
        temperature_unit: "fahrenheit",
        forecast_days: 7
      }
    })

    if response.success?
      daily_data = response["daily"]
      render json: {
        location: city,
        forecast: (0..6).map do |i|
          {
            day: Date.parse(daily_data["time"][i]).strftime("%A"),
            temperature: {
              high: daily_data["temperature_2m_max"][i].round,
              low: daily_data["temperature_2m_min"][i].round
            },
            condition: weather_code_to_condition(daily_data["weather_code"][i])
          }
        end
      }
    else
      render json: { error: "Weather data not available" }, status: 404
    end
  end

  private

  def get_city_coordinates(city)
    city_coords = {
      "New York" => { lat: 40.7128, lng: -74.0060 },
      "Los Angeles" => { lat: 34.0522, lng: -118.2437 },
      "Chicago" => { lat: 41.8781, lng: -87.6298 },
      "Houston" => { lat: 29.7604, lng: -95.3698 },
      "Phoenix" => { lat: 33.4484, lng: -112.0740 },
      "Philadelphia" => { lat: 39.9526, lng: -75.1652 },
      "San Antonio" => { lat: 29.4241, lng: -98.4936 },
      "San Diego" => { lat: 32.7157, lng: -117.1611 },
      "Dallas" => { lat: 32.7767, lng: -96.7970 },
      "San Jose" => { lat: 37.3382, lng: -121.8863 }
    }
    city_coords[city]
  end

  def weather_code_to_condition(code)
    case code
    when 0 then "Clear"
    when 1, 2, 3 then "Partly Cloudy"
    when 45, 48 then "Foggy"
    when 51, 53, 55, 61, 63, 65 then "Rainy"
    when 71, 73, 75, 77 then "Snowy"
    when 80, 81, 82 then "Showers"
    when 95, 96, 99 then "Thunderstorm"
    else "Unknown"
    end
  end

  public

  def cities
    render json: {
      cities: [
        "New York",
        "Los Angeles",
        "Chicago",
        "Houston",
        "Phoenix",
        "Philadelphia",
        "San Antonio",
        "San Diego",
        "Dallas",
        "San Jose"
      ]
    }
  end
end
