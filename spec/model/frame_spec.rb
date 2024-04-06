require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe "#game_frames_limit" do
    let(:game) { create(:game) }

    it "does not add error when game is within maximum frames limit" do
      (Frame::MAX_FRAMES - 1).times { create(:frame, game: game) }
      frame = build(:frame, game: game)
      frame.valid?
      expect(frame.errors[:base]).not_to include("Game can have maximum 10 frames")
    end
  end
  
  describe "#complete?" do
    let(:frame) { create(:frame) }

    context "when frame is complete" do
      it "returns true" do
        allow(frame).to receive(:strike?).and_return(false)
        allow(frame).to receive(:spare?).and_return(false)
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 4)
        expect(frame.complete?).to eq(true)
      end
    end

    context "when frame is incomplete" do
      it "returns false" do
        expect(frame.complete?).to eq(false)
      end
    end
  end

  describe "#strike?" do
    let(:frame) { create(:frame) }

    context "when frame is a strike" do
      it "returns true" do
        frame.rolls.create(pins_knocked_down: 10)
        expect(frame.strike?).to eq(true)
      end
    end

    context "when frame is not a strike" do
      it "returns false" do
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 4)
        expect(frame.strike?).to eq(false)
      end
    end
  end

  describe "#spare?" do
    let(:frame) { create(:frame) }

    context "when frame is a spare" do
      it "returns true" do
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 5)
        expect(frame.spare?).to eq(true)
      end
    end

    context "when frame is not a spare" do
      it "returns false" do
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 4)
        expect(frame.spare?).to eq(false)
      end
    end
  end

  describe "#score" do
    let(:game) { create(:game) }
    let(:frame) { create(:frame ,game: game)}
    context "when frame is a strike" do
      it "calculates score correctly" do
        frame.rolls.create(pins_knocked_down: 10)
        next_frame = create(:frame, frame_number: frame.frame_number + 1, game: game)
        next_frame.rolls.create(pins_knocked_down: 10)
        next_next_frame = create(:frame, frame_number: frame.frame_number + 2, game: game)
        next_next_frame.rolls.create(pins_knocked_down: 4)
        expect(frame.score).to eq(24)
      end
    end

    context "when frame is a spare" do
      it "calculates score correctly" do
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 5)
        next_frame = create(:frame, frame_number: frame.frame_number + 1, game: game)
        next_frame.rolls.create(pins_knocked_down: 4)
        expect(frame.score).to eq(14)
      end
    end

    context "when frame is neither a strike nor a spare" do
      it "calculates score correctly" do
        frame.rolls.create(pins_knocked_down: 5)
        frame.rolls.create(pins_knocked_down: 4)
        expect(frame.score).to eq(9)
      end
    end
  end
end
