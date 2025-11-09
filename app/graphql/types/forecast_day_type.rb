module Types
  class ForecastDayType < Types::BaseObject
    field :day, String, null: false
    field :high, Integer, null: false
    field :low, Integer, null: false
    field :condition, String, null: false
    field :icon, String, null: false
  end
end
