class Frame < ApplicationRecord
  belongs_to :game
  has_many :rolls, dependent: :destroy

  MAX_PINS = 10
  MAX_FRAMES = 10

  # Validates the maximum number of frames per game
  validate :game_frames_limit

  # Checks if the maximum number of frames for the game has been reached
  def game_frames_limit
    errors.add(:base, "Game can have maximum #{MAX_FRAMES} frames") if game.frames.size >= MAX_FRAMES
  end

  # Checks if the frame is complete based on its rolls
  def complete?
    return false if frame_number == MAX_FRAMES && rolls.size < 3 && (strike? || spare?)
    return true if frame_number == MAX_FRAMES && rolls.size == 3 && (strike? || spare?)
    return true if frame_number == MAX_FRAMES && rolls.size >= 2 && !strike? && !spare?
    return true if strike? || rolls.size == 2
    false
  end

  # Checks if the frame is a strike
  def strike?
    rolls.first.pins_knocked_down == MAX_PINS rescue false
  end

  # Checks if the frame is a spare
  def spare?
    rolls.size == 2 && rolls.sum(:pins_knocked_down) == MAX_PINS rescue false
  end

  # Calculates the score for the frame
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

  # Retrieves the next frame
  def next
    game.frames.find_by(frame_number: self.frame_number + 1)
  end
end
