# encoding: UTF-8
class Gooo
class Lieu
  class << self

    def init
      info("Initialisation des lieux…")
      lieux
      info("Lieux initialisés.")
    rescue Exception => e
      info("### ERREUR : #{e.message.inspect}")
    end

    def get lieu_id
      @instances[lieu_id]
    end

    # Retourne un lieu au hasard
    def random
      get(instances_keys[rand(lieux_count)])
    end

    # ---------------------------------------------------------------------
    # Les différents lieux

    def hall      ; @hall     ||= get(11) end
    def cuisine   ; @cuisine  ||= get(12) end
    def sous_sol  ; @sous_sol ||= get(8) end


    # ---------------------------------------------------------------------

    def lieux
      @lieux ||= begin
        @instances = {}
        data.collect do |h|
          inst = new(h)
          @instances.merge!(inst.id => inst)
          inst
        end
      end
    end

    def instances_keys
      @instances_keys ||= @instances.keys
    end
    def lieux_count
      @lieux_count ||= lieux.count
    end

    def data
      @data ||= YAML.load_file(data_path)
    end

    def data_path
      @data_path ||= File.join(CLASSES_FOLDER,'Lieu','_data_lieux.yaml')
    end

  end #/ << self
end #/Lieu
end #/Gooo
