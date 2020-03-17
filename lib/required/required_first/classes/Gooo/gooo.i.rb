# encoding: UTF-8
class Gooo

  def run

    # curses
    init_screen
    start_color

    info("--> Gooo.init_all")
    Gooo.init_all
    info("<-- /fin Gooo.init_all")

    @threads = []

    mainThread = Thread.new {
      $DEBUG = true
      plan.win.keypad(true) # Pour utiliser KEY_DOWN, KEY_UP etc.
      # On boucle jusqu'à ce qu'on sorte
      PLAYER.current_lieu = Lieu.get(0)
      begin
        info('--- Indication du lieu')
        state("Vous êtes #{PLAYER.current_lieu.infos_directions}")
        PLAYER.choisir_next_lieu
        info("<-- choisir_next_lieu (#{PLAYER.current_lieu.name})")
      end while PLAYER.current_lieu.id != 0
    }
    @threads << mainThread

    # # On positionne les personnages et on les met en route
    info("---> BadGuy.set_up")
    @threads +=  BadGuy.set_up
    info("<--- /BadGuy.set_up")

    info("--> Démarrage des threads")
    @threads.each do |th|
      begin
        th.join
      rescue Exception => e
        close_screen
        puts "### ERREUR DANS UN THREAD : #{e.message}".rouge
        puts e.backtrace.join(RC).rouge
        th.exit
      end
    end
    info("<-- /Fin de démarrage des threads")


  rescue Exception => e
    info("### #{e}")
    info(e.backtrace.join(RC))
  ensure
    info("Le jeu est terminé.Merci d'avoir joué.", :info)
    sleep 5
    close_screen
    puts MESSAGES.join(RC)
  end

end #/Gooo
