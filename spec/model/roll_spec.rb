require 'rails_helper'

RSpec.describe Roll, type: :model do
  describe "validations" do
    let(:game) { create(:game) }
    let(:frame) { create(:frame, game: game) }
    let(:roll) { build(:roll, frame: frame) }

    before do
      frame.game.frames << frame
    end

    it "is valid with valid attributes" do
      expect(roll).to be_valid
    end

    it "is not valid with pins_knocked_down less than 0" do
      roll.pins_knocked_down = -1
      expect(roll).to_not be_valid
    end

    it "is not valid with pins_knocked_down greater than 10" do
      roll.pins_knocked_down = 11
      expect(roll).to_not be_valid
    end

    it "is not valid if frame has more than three rolls" do
      2.times { create(:roll, frame: frame) }
      roll = build(:roll, pins_knocked_down: 4, frame: frame)
      expect(roll).to_not be_valid
    end

    it "is not valid if total score of rolls exceeds 10" do
      2.times { create(:roll, frame: frame) }
      build(:roll, frame: frame, pins_knocked_down: 4)
      expect(roll).to_not be_valid
    end

    it "is valid if total score of rolls exceeds 10 in frame 10" do
      frame.update(frame_number: 10)
      create(:roll, frame: frame, pins_knocked_down: 5)
      expect(roll).to be_valid
    end
  end
end
