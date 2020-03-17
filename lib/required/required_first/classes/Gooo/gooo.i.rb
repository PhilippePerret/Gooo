# encoding: UTF-8
class Gooo

  def run

    # curses
    init_screen
    start_color

    Gooo.init_all
    # On positionne les personnages et on les met en route
    BadGuy.set_up
    mainThread = Thread.new {
      plan.win.keypad(true) # Pour utiliser KEY_DOWN, KEY_UP etc.
      # On boucle jusqu'à ce qu'on sorte
      current_lieu = Lieu.get(0)
      begin
        plan.win.clear
        current_lieu = choisir_lieu_from(current_lieu)
        info("#{current_lieu.infos_directions}")
      end while current_lieu.id != 0
    }
    mainThread.join

  rescue Exception => e
    info("### #{e.message}")
    info(e.backtrace.join(RC))
  ensure
    info("Le jeu est terminé")
    close_screen
    puts MESSAGES.join(RC)
  end

  def choisir_lieu_from(lieu)
    while true
      key =
        case plan.win.getch
        when KEY_DOWN   then :down
        when KEY_UP     then :up
        when KEY_LEFT   then :left
        when KEY_RIGHT  then :right
        when 'q' then raise("Fin du jeu demandé")
        end
      new_lieu = lieu.on_move_to(key)
      return new_lieu unless new_lieu.nil?
    end
  end

end #/Gooo
