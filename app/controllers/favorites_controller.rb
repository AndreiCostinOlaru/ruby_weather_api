class FavoritesController < ApplicationController
  def index
    user_id = params[:user_id] || "default_user"
    favorites = Favorite.where(user_id: user_id)

    render json: {
      favorites: favorites.map(&:city)
    }
  end

  def create
    user_id = params[:user_id] || "default_user"
    city = params[:city]

    return render json: { error: "City is required" }, status: 400 unless city

    favorite = Favorite.find_or_create_by(user_id: user_id, city: city)

    render json: { message: "City added to favorites", city: favorite.city }, status: 201
  end

  def destroy
    user_id = params[:user_id] || "default_user"
    city = params[:city]

    favorite = Favorite.find_by(user_id: user_id, city: city)

    if favorite
      favorite.destroy
      render json: { message: "City removed from favorites" }
    else
      render json: { error: "Favorite not found" }, status: 404
    end
  end
end
