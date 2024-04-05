# Bowling API app

Welcome to the Bowling API app
## Description

This is a web application built with Ruby on Rails calculate the score of bowling game

# Before you begin, ensure you have met the following requirements:

- Ruby
- Rails
- sqlite

## Installation

1. Clone the repository:
   ```bash
   git clone  https://github.com/GopalPatoliya/bowling-game-api.git

2. bundle install

3. rails db:create

4. rails db:migrate

5. rails s

## Use case

- There is mainly 3 API
  1. For starting game, In which you need to pass the player_name
  2. To roll the bowl, In which you need to pass game_id and count of fallen pins
  3. To fetch the score, In which you need to pass the game_id

## Here are the curl commands for endpoint

  - curl -X POST -d "player_name=player" http://localhost:3000/api/v1/start

  - curl -X POST -d "game_id=1&pins=2" http://localhost:3000/api/v1/roll

  - curl -X GET http://localhost:3000/api/v1/score?game_id=1&pins=5
