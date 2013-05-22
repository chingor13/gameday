require 'tire'
require 'nokogiri'

module Gameday
  BASE_URL = "http://gd2.mlb.com/components/game/mlb/"

  autoload :Player, "gameday/player"
  autoload :Pitch, "gameday/pitch"
  autoload :Team, "gameday/team"
end
