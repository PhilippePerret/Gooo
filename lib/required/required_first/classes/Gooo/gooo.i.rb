# encoding: UTF-8
class Gooo

  def run

    # curses
    init_screen
    start_color

    Gooo.init_all
    info("Retour de Gooo.init_all")

    @threads = []

    mainThread = Thread.new {
      plan.win.keypad(true) # Pour utiliser KEY_DOWN, KEY_UP etc.
      # On boucle jusqu'à ce qu'on sorte
      current_lieu = Lieu.get(0)
      begin
        plan.win.clear
        state("#{current_lieu.infos_directions}")
        current_lieu = choisir_lieu_from(current_lieu)
      end while current_lieu.id != 0
    }
    @threads << mainThread

    # # On positionne les personnages et on les met en route
    info("---> BadGuy.set_up")
    @threads +=  BadGuy.set_up
    info("<--- /BadGuy.set_up")

    @threads.each do |th|
      begin
        th.join
      rescue Exception => e
        close_screen
        puts e.message.rouge
        puts e.backtrace.join(RC).rouge
        raise
      end
    end


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
