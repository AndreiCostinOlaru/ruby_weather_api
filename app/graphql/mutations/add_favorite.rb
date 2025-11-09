module Mutations
  class AddFavorite < BaseMutation
    argument :city, String, required: true
    argument :user_id, String, required: false

    field :city, String, null: false
    field :message, String, null: false

    def resolve(city:, user_id: "default_user")
      favorite = Favorite.find_or_create_by(user_id: user_id, city: city)
      {
        city: favorite.city,
        message: "City added to favorites"
      }
    end
  end
end
