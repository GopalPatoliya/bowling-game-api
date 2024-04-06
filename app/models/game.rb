class Game < ApplicationRecord
  belongs_to :player
  has_many :frames, dependent: :destroy

  # Method to simulate rolling the ball in the game
  def roll(pins)
    current_frame = frames.last || frames.create(frame_number: 1) 
    if current_frame.complete? # If the current frame is complete, create a new frame
      current_frame = frames.create(frame_number: frames.size + 1) 
    end
    current_frame.rolls.create!(pins_knocked_down: pins)     # Add a new roll with the number of pins knocked down
  end

  # Method to calculate the total score of the game
  def calculate_score
    total_score = 0
    return 0 unless frames.present? 

    unless game_over?
      # If the game is not over, return a message based on the current frame's state
      return "Please complete a strike to calculate the score" if frames.last.strike?
      return "Please complete a spare to calculate the score" if frames.last.spare?
      return "Please complete a strike to calculate the score" if frames.last(2).first.strike? && frames.last.rolls.count != 2
    end

    # Calculate the total score by summing the score of each frame
    frames&.each do |frame|
      total_score += frame.score
    end

    total_score
  end

  # Method to check if the game is over
  def game_over?
    frames.count == 10 && frames.last.complete?
  end
end
