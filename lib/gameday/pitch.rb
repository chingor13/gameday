module Gameday
  class Pitch
    include Tire::Model::Persistence

    property :pitcher
    property :batter
    property :result
    property :pitch_type
    property :pitch_id
    property :description
    property :x
    property :y
    property :start_speed
    property :end_speed
    property :sz_top
    property :sz_bot
    property :pfx_x
    property :pfx_z
    property :px
    property :pz
    property :x0
    property :y0
    property :z0
    property :vx0
    property :vy0
    property :vz0
    property :ax
    property :ay
    property :az
    property :break_y
    property :break_angle
    property :break_length
    property :type_confidence
    property :zone
    property :nasty
    property :spin_dir
    property :spin_rate

    def self.import(xml)
      doc = Nokogiri::XML(xml)
      doc.xpath("//atbat").each do |at_bat|
        at_bat.xpath("pitch").each do |pitch|
          self.from_doc(pitch).tap do |p|
            p.batter = at_bat["batter"]
            p.pitcher = at_bat["pitcher"]
          end.save
        end
      end
      true
    end

    def self.from_doc(doc)
      new({
        :id => doc["sv_id"],
        :result => doc["type"],
        :pitch_type => doc["pitch_type"],
        :description => doc["desc"],
        :x => doc["x"],
        :y => doc["y"],
        :start_speed => doc["start_speed"],
        :end_speed => doc["end_speed"],
        :sz_top => doc["sz_top"],
        :sz_bot => doc["sz_top"],
        :pfx_x => doc["pfx_x"],
        :pfx_z => doc["pfx_z"],
        :px => doc["px"],
        :pz => doc["pz"],
        :x0 => doc["x0"],
        :y0 => doc["y0"],
        :z0 => doc["z0"],
        :vx0 => doc["vx0"],
        :vy0 => doc["vy0"],
        :vz0 => doc["vz0"],
        :ax => doc["ax"],
        :ay => doc["ay"],
        :az => doc["az"],
        :break_y => doc["break_y"],
        :break_angle => doc["break_angle"],
        :break_length => doc["break_length"],
        :type_confidence => doc["type_confidence"],
        :spin_dir => doc["spin_dir"],
        :spin_rate => doc["spin_rate"]
      })
    end
  end
end