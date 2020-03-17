# encoding: UTF-8
class Gooo
class << self

  def init_all
    info("Initialisation complète…")
    config.init
    Lieu.init
    info("Fin de l'initialisation")
  end

  def config
    @config ||= Config.new(self)
  end

end #/ << self
end #/Gooo
