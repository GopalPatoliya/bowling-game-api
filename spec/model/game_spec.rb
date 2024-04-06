require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "#roll" do
    let(:player) { create(:player) }
    let(:game) { create(:game, player: player) }

    it "creates a new frame and roll if current frame is complete" do
      expect { game.roll(5) }.to change { game.frames.count }.by(1)
      expect(game.frames.last.rolls.count).to eq(1)
      expect(game.frames.last.rolls.first.pins_knocked_down).to eq(5)
    end

    it "uses existing frame if current frame is incomplete" do
      game.roll(5)
      expect { game.roll(3) }.to_not change { game.frames.count }
      expect(game.frames.last.rolls.count).to eq(2)
      expect(game.frames.last.rolls.last.pins_knocked_down).to eq(3)
    end
  end

  describe "#calculate_score" do
    let(:player) { create(:player) }
    let(:game) { create(:game, player: player) }

    context "when no frames exist" do
      it "returns 0" do
        expect(game.calculate_score).to eq(0)
      end
    end

    context "when frames exist but game is not over" do
      it "returns appropriate message" do
        game.frames.create(frame_number: 1, rolls: [build(:roll, pins_knocked_down: 10)])
        expect(game.calculate_score).to eq("Please complete a strike to calculate the score")
      end
    end

    context "when frames exist and game is over" do
      it "calculates total score correctly" do
        allow(game).to receive(:game_over?).and_return(true)
        game.frames.create(frame_number: 1, rolls: [build(:roll, pins_knocked_down: 5), build(:roll, pins_knocked_down: 4)])
        expect(game.calculate_score).to eq(9)
      end
    end
  end

  describe "#game_over?" do
    let(:player) { create(:player) }
    let(:game) { create(:game, player: player) }

    it "returns true if 10 frames exist and last frame is complete" do
      9.times { |i| game.frames.create(frame_number: i + 1, rolls: [build(:roll, pins_knocked_down: 5), build(:roll, pins_knocked_down: 4)]) }
      game.frames.create(frame_number: 10, rolls: [build(:roll, pins_knocked_down: 5), build(:roll, pins_knocked_down: 4)])
      expect(game.game_over?).to eq(true)
    end

    it "returns false if fewer than 10 frames exist" do
      9.times { |i| game.frames.create(frame_number: i + 1, rolls: [build(:roll, pins_knocked_down: 5), build(:roll, pins_knocked_down: 4)]) }
      expect(game.game_over?).to eq(false)
    end

    it "returns false if 10 frames exist but last frame is incomplete" do
      9.times { |i| game.frames.create(frame_number: i + 1, rolls: [build(:roll, pins_knocked_down: 5), build(:roll, pins_knocked_down: 4)]) }
      game.frames.create(frame_number: 10, rolls: [build(:roll, pins_knocked_down: 5)])
      expect(game.game_over?).to eq(false)
    end
  end
end
