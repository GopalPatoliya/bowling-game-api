module Api
  module V1
    class BowlingGameController < ApplicationController
      before_action :set_player, only: [:start]
      before_action :set_game, only: [:roll, :score]

      def start
        @game = @player.games.create
        render json: { message: "New bowling game started", data: @game.id }
      end

      def roll
        if @game.game_over?
          render json: { message: "Game is completed" } 
        else
          pins = params[:pins].to_i
          @game.roll(pins)
          render json: { message: "Roll successful" }
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def score
        render json: { score: @game.calculate_score }
      end

      private
      
      def set_player
        @player = Player.find_or_create_by(name: params[:player_name])
      end

      def set_game
        @game = Game.find(params[:game_id])
      end

    end
  end
end
