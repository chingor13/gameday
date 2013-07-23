module Gameday
  class Pitch
    include Tire::Model::Persistence

    property :game_id

    property :pitcher
    property :batter
    property :result
    property :pitch_type
    property :pitch_id
    property :description
    property :x, type: "float"
    property :y, type: "float"
    property :start_speed, type: "float"
    property :end_speed, type: "float"
    property :sz_top, type: "float"
    property :sz_bot, type: "float"
    property :pfx_x, type: "float"
    property :pfx_z, type: "float"
    property :px, type: "float"
    property :pz, type: "float"
    property :x0, type: "float"
    property :y0, type: "float"
    property :z0, type: "float"
    property :vx0, type: "float"
    property :vy0, type: "float"
    property :vz0, type: "float"
    property :ax, type: "float"
    property :ay, type: "float"
    property :az, type: "float"
    property :break_y, type: "float"
    property :break_angle, type: "float"
    property :break_length, type: "float"
    property :type_confidence, type: "float"
    property :zone
    property :nasty, type: "integer"
    property :spin_dir, type: "float"
    property :spin_rate, type: "float"
    property :count, index: :not_analyzed
    property :batter_hand

    class << self
      def import(xml, game = nil)
        doc = Nokogiri::XML(xml)
        doc.xpath("//atbat").each do |at_bat|
          balls = 0
          strikes = 0
          at_bat.xpath("pitch").each do |pitch|
            self.from_doc(pitch).tap do |p|
              p.count = "#{balls}-#{strikes}"
              p.batter_hand = at_bat["stand"]
              p.batter = at_bat["batter"]
              p.pitcher = at_bat["pitcher"]
              p.game_id = game.id if game
            end.save
            case pitch["type"]
            when "B"
              balls += 1
            else
              strikes = [2, strikes + 1].min
            end
          end
        end
        true
      end

      def from_doc(doc)
        new({
          id:           doc["sv_id"],
          result:       doc["type"],
          pitch_type:   doc["pitch_type"],
          description:  doc["desc"],
          x:            doc["x"],
          y:            doc["y"],
          start_speed:  doc["start_speed"].to_f,
          end_speed:    doc["end_speed"].to_f,
          sz_top:       doc["sz_top"],
          sz_bot:       doc["sz_top"],
          pfx_x:        doc["pfx_x"],
          pfx_z:        doc["pfx_z"],
          px:           doc["px"],
          pz:           doc["pz"],
          x0:           doc["x0"],
          y0:           doc["y0"],
          z0:           doc["z0"],
          vx0:          doc["vx0"],
          vy0:          doc["vy0"],
          vz0:          doc["vz0"],
          ax:           doc["ax"],
          ay:           doc["ay"],
          az:           doc["az"],
          break_y:      doc["break_y"],
          break_angle:  doc["break_angle"],
          break_length: doc["break_length"],
          type_confidence: doc["type_confidence"],
          spin_dir:     doc["spin_dir"],
          spin_rate:    doc["spin_rate"],
          nasty:        doc["nasty"].to_i, 
        })
      end
    end
  end
end