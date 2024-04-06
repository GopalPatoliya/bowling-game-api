require 'rails_helper'

RSpec.describe Api::V1::BowlingGameController, type: :controller do
  describe "POST #start" do
    it "creates a new bowling game for the player" do
      player_name = "player1"
      post :start, params: { player_name: player_name }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["message"]).to eq("New bowling game started")
      expect(JSON.parse(response.body)["game_id"]).to be_present
    end
  end

  describe "POST #roll" do
    let(:player) { create(:player) }
    let(:game) { create(:game, player: player) }

    context "when the game is not over" do
      it "rolls successfully" do
        post :roll, params: { game_id: game.id, pins: 5 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("Roll successful")
      end
    end

    context "when the game is over" do
      before do
        allow_any_instance_of(Game).to receive(:game_over?).and_return(true)
      end

      it "returns game completed message" do
        post :roll, params: { game_id: game.id, pins: 5 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("Game is completed")
      end
    end

    context "when rolling throws an error" do
      it "renders error message" do
        allow_any_instance_of(Game).to receive(:roll).and_raise(StandardError, "Error message")
        post :roll, params: { game_id: game.id, pins: 5 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Error message")
      end
    end
  end

  describe "GET #score" do
    let(:game) { create(:game) }

    it "returns the score of the game" do
      allow_any_instance_of(Game).to receive(:calculate_score).and_return(50)
      get :score, params: { game_id: game.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["score"]).to eq(50)
    end
  end
end
