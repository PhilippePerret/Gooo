# encoding: UTF-8
class Gooo
class BadGuy

  attr_reader :data

  # [Gooo::Lieu] Lieu où se trouve le personnage
  attr_accessor :current_lieu

  def initialize hdata
    @data = hdata
  end

  # On doit définir où il en est au début du jeu
  def set_up
    # On doit lui choisir une pièce
    on_come_in(Lieu.random)
    return self # chainage
  end

  # Méthode qui déplace le personnage
  def move

  end

  # Méthode appelée lorsque le personnage rentre dans une pièce
  def on_come_in(lieu)
    current_lieu.rem_bad_guy unless current_lieu.nil?
    lieu.add_bad_guy(self)
    current_lieu = lieu
    info("#{name} rentre dans #{current_lieu.le_name}")
  end

  # ---------------------------------------------------------------------
  #
  #   PROPRIÉTÉS
  #
  # ---------------------------------------------------------------------

  def id      ; @id       ||= data['id']        end
  def name    ; @name     ||= data['name']      end
  def force   ; @force    ||= data['force']     end
  def speed   ; @speed    ||= data['speed']     end


end #/ BadGuy
end #/ Gooo
