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
      puts "#{game_id}:"
      Gameday::Pitch.import(open(inning_url), game)
    rescue OpenURI::HTTPError => e
      puts "error: #{e.message}"
    end
  end
end