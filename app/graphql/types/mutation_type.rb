# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_favorite, mutation: Mutations::AddFavorite
    field :remove_favorite, mutation: Mutations::RemoveFavorite
  end
end
