module Gameday
  class Player
    include Tire::Model::Persistence

    property :first
    property :last
    property :num
    property :team_id
    property :team_abbrev

    def self.import(xml)
      doc = Nokogiri::XML(xml)
      doc.xpath("//team").each do |team|
        Gameday::Team.from_doc(team).save
        team.xpath("player").each do |player|
          self.from_doc(player).tap do |p|
            p.team_id = team["id"]
          end.save
        end
      end
      true
    end

    def self.from_doc(doc)
      new({
        :first => doc["first"],
        :last => doc["last"],
        :num => doc["num"],
        :team_id => doc["team_id"],
        :team_abbrev => doc["team_abbrev"]
      })
    end
  end
end