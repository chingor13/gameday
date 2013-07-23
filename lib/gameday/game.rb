require 'open-uri'
module Gameday
  class Game
    include Tire::Model::Persistence

    property :away_team
    property :home_team

    property :year
    property :month
    property :day
    property :date, type: 'date'

    def self.import(date, game_id)
      begin
        Timeout::timeout(75) do
          url = sprintf("http://gd2.mlb.com/components/game/mlb/year_%0d/month_%02d/day_%02d/%s", 
            date.year, date.month, date.day, game_id)
          boxscore_url = File.join(url, "boxscore.xml")
          puts "#{game_id}: importing game"
          xml = open(boxscore_url)
          doc = Nokogiri::XML.parse(xml)
          game = new({
            date: date,
            id: game_id,
            away_team: doc["away_team_code"],
            home_team: doc["home_team_code"]
          })
          game.save

          players_url = File.join(url, "players.xml")
          puts "#{game_id}: importing players"
          Gameday::Player.import(open(players_url))

          inning_url = File.join(url, "inning/inning_all.xml")
          puts "#{game_id}: importing pitches #{inning_url}"
          Gameday::Pitch.import(open(inning_url), game)
        end
      rescue OpenURI::HTTPError => e
        puts "error: #{e.message}"  
      rescue Timeout::Error
        puts "took too long"
      end
    end
  end
end