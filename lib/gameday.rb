require 'tire'
require 'nokogiri'
require 'open-uri'

module Gameday
  BASE_URL = "http://gd2.mlb.com/components/game/mlb/"
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36"

  autoload :Player, "gameday/player"
  autoload :Pitch, "gameday/pitch"
  autoload :Team, "gameday/team"
  autoload :Game, "gameday/game"
  autoload :DayScraper, "gameday/day_scraper"
  autoload :RangeScraper, "gameday/range_scraper"

  def self.open(url)
    open(url, "User-Agent" => USER_AGENT)
  end
end
