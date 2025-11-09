module Types
  class CityType < Types::BaseObject
    field :name, String, null: false
    field :video_url, String, null: true
  end
end
