module Types
  class WeatherForecastType < Types::BaseObject
    field :location, String, null: false
    field :forecast, [ Types::ForecastDayType ], null: false
  end
end
