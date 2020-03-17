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
      lieu_id = 0
      begin
        plan.win.clear
        lieu_id = choisir_lieu_from(Lieu.get(lieu_id))
      end while lieu_id != 0
    }
    mainThread.join

  rescue Exception => e
    info("### #{e.message.inspect}")
  ensure
    info("Le jeu est terminé")
    sleep 10
    close_screen
  end

  def choisir_lieu_from(lieu)
    lieux = lieu.near_values
    key = plan.win.getch

    case key
    when Key::DOWN
      plan << "Flèche bas"
    when Key::UP
      plan << "Flèche haut"
    when KEY_LEFT
      plan << "Flèche gauche"
    when KEY_RIGHT
      plan << "Flèche droite"
    else
      plan << "Touche inconnue : #{key}"
    end
    puts "KEY_DOWN: #{Key::DOWN.inspect}/key:#{key.inspect}"
    sleep 5
    # # puts "lieux de #{lieu.name.upcase} : #{lieux.inspect}"
    # Q.select("Vous êtes #{lieu.dans_hname.upcase.bleu}") do |q|
    #   q.choices lieux
    #   q.per_page lieux.count
    # end
  end

end #/Gooo
