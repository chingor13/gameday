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
  opts.on "-y", "--year=YEAR", OptionParser::DecimalInteger, "Starting year" do |year|
    options[:year] = year
  end
  opts.on "-m", "--month=MONTH", OptionParser::DecimalInteger, "Starting month" do |month|
    options[:month] = month
  end
  opts.on "-d", "--day=DAY", OptionParser::DecimalInteger, "Starting day" do |day|
    options[:day] = day
  end
end.parse!

start_date = Date.parse(sprintf("%04d-%02d-%02d", options[:year], options[:month], options[:day]))
(start_date..Date.today).each do |date|
  date_url = sprintf("http://gd2.mlb.com/components/game/mlb/year_%0d/month_%02d/day_%02d/", date.year, date.month, date.day)
  data = open(date_url) rescue nil
  next unless data

  doc = Nokogiri::HTML.parse(data)
  doc.xpath("//a").each do |link|
    if matches = link["href"].match(/^(gid.*)\//) 
      game_id = matches[1]
      Gameday::Game.import(date, game_id) unless Gameday::Game.find(game_id)
    end
  end
end
