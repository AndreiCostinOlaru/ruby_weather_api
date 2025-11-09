# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :cities, [ String ], null: false, description: "List of available cities" do
      argument :search, String, required: false
    end
    def cities(search: nil)
      city_list = WeatherController::CITY_COORDINATES.keys
      city_list = city_list.select { |city| city.downcase.include?(search.downcase) } if search.present?
      city_list.sort
    end

    field :weekly_forecast, Types::WeatherForecastType, null: true, description: "Get weekly forecast for a city" do
      argument :city, String, required: true
    end
    def weekly_forecast(city:)
      controller = WeatherController.new
      coords = controller.send(:get_city_coordinates, city)
      return nil unless coords

      response = HTTParty.get("https://api.open-meteo.com/v1/forecast", {
        query: {
          latitude: coords[:lat],
          longitude: coords[:lng],
          daily: "temperature_2m_max,temperature_2m_min,weather_code",
          temperature_unit: "fahrenheit",
          forecast_days: 7
        }
      })

      return nil unless response.success?

      daily_data = response["daily"]
      forecast = (0..6).map do |i|
        condition = controller.send(:weather_code_to_condition, daily_data["weather_code"][i])
        {
          day: Date.parse(daily_data["time"][i]).strftime("%A"),
          high: daily_data["temperature_2m_max"][i].round,
          low: daily_data["temperature_2m_min"][i].round,
          condition: condition,
          icon: "/icons/weather/#{controller.send(:condition_to_icon, condition)}"
        }
      end

      { location: city, forecast: forecast }
    end

    field :favorites, [ String ], null: false, description: "Get user's favorite cities" do
      argument :user_id, String, required: false, default_value: "default_user"
    end
    def favorites(user_id:)
      Favorite.where(user_id: user_id).pluck(:city)
    end
  end
end
