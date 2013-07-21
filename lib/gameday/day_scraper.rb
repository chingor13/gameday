require 'sidekiq'
require 'open-uri'
module Gameday
  class DayScraper
    include Sidekiq::Worker

    def perform(year, month, day)
      date = Date.new(year, month, day)
      url = sprintf("http://gd2.mlb.com/components/game/mlb/year_%0d/month_%02d/day_%02d/", 
        date.year, date.month, date.day)

      doc = Nokogiri::HTML.parse(open(url))
      doc.xpath("//a").each do |link|
        if matches = link["href"].match(/^(gid.*)\//) 
          game_id = matches[1]
          Gameday::Game.import(date, game_id)
        end
      end
    end
  end
end