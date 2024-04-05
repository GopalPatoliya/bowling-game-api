class Roll < ApplicationRecord
  belongs_to :frame
  validates :pins_knocked_down, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  validate :rolls_limit
  validate :rolls_sum

  def rolls_limit
    errors.add(:base, "Frame can have maximum three rolls") if frame.rolls.size > 2 && !frame.game.frames.last.strike? && !frame.game.frames.last.strike?
  end

  def rolls_sum
    total_score = frame.rolls.sum(:pins_knocked_down) + self.pins_knocked_down 
    errors.add(:base, "Total score of rolls cannot exceed 10") if total_score > 10 && frame.frame_number != 10
  end
end
