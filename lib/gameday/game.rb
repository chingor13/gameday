module Gameday
  class Game
    include Tire::Model::Persistence

    property :away_team
    property :home_team

    property :year
    property :month
    property :day

    def self.import(year, month, day, game_id)
      url = sprintf("http://gd2.mlb.com/components/game/mlb/year_%0d/month_%02d/day_%02d/%s", year, month, day, game_id)
      boxscore_url = File.join(url, "boxscore.xml")
      puts "importing game: #{boxscore_url}"
      doc = Nokogiri::XML.parse(open(boxscore_url))
      game = new({
        :year => year,
        :month => month,
        :day => day,
        :id => game_id,
        :away_team => doc["away_team_code"],
        :home_team => doc["home_team_code"]
      })
      game.save

      players_url = File.join(url, "players.xml")
      puts "importing players: #{players_url}"
      Gameday::Player.import(open(players_url))

      inning_url = File.join(url, "inning/inning_all.xml")
      puts "importing pitchers: #{inning_url}"
      Gameday::Pitch.import(open(inning_url), game)
    end
  end
end