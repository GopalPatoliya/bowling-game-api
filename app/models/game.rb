
class Game < ApplicationRecord
  belongs_to :player
  has_many :frames

  def roll(pins)
    current_frame = frames.last || frames.create(frame_number: 1) 
    if current_frame.complete?
      current_frame = frames.create(frame_number: frames.size + 1) 
    end
    current_frame.rolls.create!(pins_knocked_down: pins) 
  end

  def calculate_score
    total_score = 0
    return 0 unless frames.present?
    unless game_over?
      return "please complete strike to calculate score" if frames.last.strike?
      return "please complete spare to calculate score" if frames.last.spare?
      return "please complete strike to calculate score" if frames.last(2).first.strike? && frames.last.rolls.count !=2
    end
    frames&.each do |frame|
      total_score += frame.score
    end
    total_score
  end

  def game_over?
    frames.count == 10 && frames.last.complete?
  end
end
