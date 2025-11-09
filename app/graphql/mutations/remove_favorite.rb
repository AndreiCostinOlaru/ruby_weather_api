module Mutations
  class RemoveFavorite < BaseMutation
    argument :city, String, required: true
    argument :user_id, String, required: false

    field :message, String, null: false

    def resolve(city:, user_id: "default_user")
      favorite = Favorite.find_by(user_id: user_id, city: city)

      if favorite
        favorite.destroy
        { message: "City removed from favorites" }
      else
        { message: "Favorite not found" }
      end
    end
  end
end
