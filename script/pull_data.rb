Bundler.require

require 'optparse'
require 'open-uri'
require 'pp'

options = {
  :year => Date.today.year,
  :month => Date.today.month,
  :day => Date.today.day
}
OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
  opts.on "-y", "--year=YEAR", OptionParser::DecimalInteger, "Parse all pitches for the year" do |year|
    options[:year] = year
  end
  opts.on "-m", "--month=MONTH", OptionParser::DecimalInteger, "Parse all pitches for the month" do |month|
    options[:month] = month
  end
  opts.on "-d", "--day=DAY", OptionParser::DecimalInteger, "Parse all pitches for the day" do |day|
    options[:day] = day
  end
end.parse!

url = sprintf("http://gd2.mlb.com/components/game/mlb/year_%0d/month_%02d/day_%02d/", options[:year], options[:month], options[:day])

doc = Nokogiri::HTML.parse(open(url))
doc.xpath("//a").each do |link|
  if link["href"].match(/^gid.*/)
    game_url = File.join(url, link["href"], "inning/inning_all.xml")
    players_url = File.join(url, link["href"], "players.xml")

    puts "importing players: #{link["href"]}"
    Gameday::Player.import(open(players_url))
    puts "importing pitches: #{link["href"]}"
    Gameday::Pitch.import(open(game_url))
  end
end

