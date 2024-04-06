module Api
  module V1
    class BowlingGameController < ApplicationController
      # Sets the player before starting the game
      before_action :set_player, only: [:start]
      # Sets the game before rolling or calculating the score
      before_action :set_game, only: [:roll, :score]

      # Start a new bowling game for the player
      def start
        @game = @player.games.create
        render json: { message: "New bowling game started", game_id: @game.id }
      end

      # Roll the ball for the current game
      def roll
        if @game.game_over?
          render json: { message: "Game is completed" } 
        else
          pins = params[:pins].to_i
          @game.roll(pins)
          if @game.game_over?
            render json: { message: "Roll successful. Game is completed" }
          else
            render json: { message: "Roll successful" }
          end
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # Calculate and return the score of the current game
      def score
        render json: { score: @game.calculate_score }
      end

      private
      
      # Finds or creates a player based on the provided player_name parameter
      def set_player
        @player = Player.find_or_create_by(name: params[:player_name])
      end

      # Finds the game based on the provided game_id parameter
      def set_game
        @game = Game.find_by(id: params[:game_id])
        if @game.nil?
          render json: { error: 'Game not found' }, status: :not_found
        end
      end

    end
  end
end
