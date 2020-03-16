# encoding: UTF-8
class Gooo
  class Lieu
    attr_reader :data
    def initialize hdata
      @data = hdata
    end

    def id    ; @id   ||= data['id']    end
    def name  ; @name ||= data['name']  end
    def near  ; @near ||= data['near']  end
    def near_values
      @near_values ||= begin
        near.collect do |item_id|
          self.class.get(item_id).as_value
        end
      end
    end

    def as_value ; @as_value ||= {value:id, name: name} end

  end #/Lieu
end #/Gooo
