# encoding: UTF-8
class Gooo
class User

  # Le lieu actuel du player
  attr_reader :current_lieu

  def initialize

  end

  # Quand le player rentre dans un nouveau lieu
  def current_lieu= new_lieu
    @current_lieu = new_lieu
    if new_lieu.with_bad_guys?
      info("Il y a #{new_lieu.hlist_bad_guys} à cet endroit !" , :error)
    end
  end

  # Méthode pour choisir le prochain lieu
  def choisir_next_lieu()
    info('--> choisir_next_lieu()')
    while true
      key =
        case plan.win.getch
        when KEY_DOWN   then :down
        when KEY_UP     then :up
        when KEY_LEFT   then :left
        when KEY_RIGHT  then :right
        when 'q' then raise("Fin du jeu demandé")
        end
      info("Key : #{key.inspect} (current_lieu: #{current_lieu.name})")
      new_lieu = current_lieu.on_move_to(key)
      unless new_lieu.nil?
        @current_lieu = new_lieu
        return
      end
    end
  end

end #/ User
end #/ Gooo
