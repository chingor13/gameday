require 'sidekiq'
require 'open-uri'
module Gameday
  class RangeScraper
    include Sidekiq::Worker

    def perform(start, finish = nil)
      start = Date.parse(start)
      finish = finish ? Date.parse(finish) : Date.today
      (start..finish).each do |date|
        DayScraper.perform_async(date.year, date.month, date.day)
      end
    end
  end
end