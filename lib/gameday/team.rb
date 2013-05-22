module Gameday
  class Team
    include Tire::Model::Persistence

    property :name

    def self.from_doc(doc)
      new({
        :name => doc["name"],
        :id => doc["id"]
      })
    end
  end
end