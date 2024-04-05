class Frame < ApplicationRecord
  belongs_to :game
  has_many :rolls

  validate :rolls_limit
  validate :rolls_sum
  validate :game_frames_limit

  MAX_PINS = 10
  MAX_FRAMES = 10

  def rolls_limit
    errors.add(:base, "Frame can have maximum three rolls") if rolls.size > 2 && !game.frames.last.strike? && !game.frames.last.strike?
  end

  def rolls_sum
    total_score = rolls.sum(:score)
    errors.add(:base, "Total score of rolls cannot exceed 10") if total_score > 10
  end

  def game_frames_limit
    errors.add(:base, "Game can have maximum 10 frames") if game.frames.size >= 10
  end


  def complete?
    return false if frame_number == MAX_FRAMES && rolls.size < 3 && (strike? || spare?)
    return true if frame_number == MAX_FRAMES && rolls.size == 3 && (strike? || spare?)
    return true if frame_number == MAX_FRAMES && rolls.size >= 2 && !strike? && !spare?
    return true if strike? || rolls.size == 2
    false
  end

  def strike?
    rolls.first.pins_knocked_down == MAX_PINS rescue false
  end

  def spare?
    rolls.size == 2 && rolls.sum(:pins_knocked_down) == MAX_PINS rescue false
  end

  def score
    if frame_number == MAX_FRAMES
      score = rolls.sum(:pins_knocked_down)
    elsif strike?
      if self.next.rolls.count == 1
        score = 10+ self.next.rolls.first.pins_knocked_down + self.next.next.rolls.first.pins_knocked_down
      elsif self.next.frame_number == 10
        score = 10+ self.next.rolls.first(2).pluck(:pins_knocked_down).sum
      else
        score = 10+ self.next.rolls.sum(:pins_knocked_down)
      end

    elsif spare?
      score = self.next.rolls.first.pins_knocked_down + 10
    else
      score = rolls.sum(:pins_knocked_down)
    end
    score
  end

  def next
    Frame.find_by(frame_number: self.frame_number + 1)
  end
end
