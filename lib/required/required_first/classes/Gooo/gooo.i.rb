# encoding: UTF-8
class Gooo

  def run
    Gooo.init_all
    puts "Je lance le jeu"
    puts "Lieu.start_values = #{Lieu.start_values.inspect}"
    lieu = choisir_lieu_from()
    puts "Vous entrez par #{lieu}"
    next_lieu = choisir_lieu_from(lieu, "Où voulez-vous aller maintenant ?")
  end

  def choisir_lieu_from(lieu = nil, question = "Par où voulez-vous entrer ?")
    lieux =
      if lieu.nil?
        Lieu.start_values
      else
        lieu.near_values
      end
    choix = Q.select(question) do |q|
      q.choices lieux
      q.per_page lieux.count
    end
    Lieu.get(choix)
  end

end #/Gooo
