# app/models/player.rb
class Player < ApplicationRecord
  has_many :games
end
