# encoding: UTF-8
class Gooo
  class Lieu
    attr_reader :data
    def initialize hdata
      @data = hdata

      @occupants = {}
    end


    # ---------------------------------------------------------------------
    #
    #     MÉTHODES PUBLIQUES
    #
    # ---------------------------------------------------------------------

    # Méthode appelée quand un méchant entre dans le lieu
    def add_bad_guy(badguy)
      @occupants.merge!(badguy.id => badguy)
    end

    def rem_bad_guy(badguy)
      @occupants.delete(badguy.id)
    end

    # Méthode appelée quand on prend la direction +dir+ depuis cette
    # pièce
    # +Params+::
    #   +dir+::[Symbol], :up, :down, :left ou :right
    #
    # +return+:: Le lieu, ou nil si aucun
    def on_move_to(dir)
      near_room_at(dir)
    end

    def near_room_at(dir)
      near_rooms[dir]
    end

    # Affiche le lieu et les informations sur les directions
    DIR_TO_FLECHE = {
      up: '🔼', down: '🔽 ', left: '◀️ ', right: '▶️ '
    }
    def infos_directions
      @infos_directions ||= begin
        str = ["#{name.upcase}"]
        near_rooms.each do |dir, lieu|
          str << "#{DIR_TO_FLECHE[dir]}#{lieu.name}"
        end
        str.join(' ')
      end
    end

    # Retourne un autre lieu aléatoire à partir de ce lieu
    def random_next_lieu
      k = near_rooms.keys[rand(near_rooms.keys.count)]
      near_rooms[k]
    end

    # ---------------------------------------------------------------------
    #
    #     PROPRIÉTÉS
    #
    # ---------------------------------------------------------------------

    def id      ; @id     ||= data['id']      end
    def name    ; @name   ||= data['name']    end
    def near    ; @near   ||= data['near']    end

    # M: masculin, F: féminin, E: ellipse, P:pluriel
    def genre     ; @genre  ||= data['genre']     end

    # Triplet [<id lieu>, <window|door>[, <down>]]
    def output    ; @output ||= data['output']    end
    def feminin   ; @feminin ||= data['feminin']  end


    # ---------------------------------------------------------------------
    #
    #   PROPRIÉTÉS VOLATILES
    #
    # ---------------------------------------------------------------------

    def le_name
      @le_name ||= "#{le} #{name_min}"
    end
    def dans_hname
      @dans_hname ||= (exterieur? ? 'à l’extérieur de la maison' : "dans #{le_name}")
    end

    def name_min; @name_min ||= name.downcase end

    LEs = {'M' => 'le', 'F' => 'la', 'E' => 'l’', 'P' => 'les'}
    UNs = {'M' => 'un', 'F' => 'une', 'E' => 'un', 'P' => 'des'}
    def le ; @le  ||= LEs[genre]  end
    def un ; @un  ||= UNs[genre]  end

    def feminin?  ; @is_feminin ||= genre === 'F'  end

    # +return+ true si on est à l'extérieur
    def exterieur?
      id == 0
    end
    def from_exterieur?
      !!@is_from_ext
    end
    def set_from_exterieur(value)
      @is_from_ext = value
    end

    def near_rooms
      @near_rooms ||= begin
        h = {}
        near.each do |truplet|
          item_id, dirH, dirV = truplet
          nlieu = self.class.get(item_id)
          h.merge!(dirH.to_sym => nlieu)
        end
        h.merge!(output[1].to_sym => Lieu.get(0)) if output
        h
      end
    end

    def f_output
      @f_output ||= begin
        str = []
        str << 'Sortir'
        str << ' en sautant' if output[1] == 'down'
        str << case output[0]
        when 'window'
          'par la fenêtre'
        when 'door'
          'par la porte'
        end
        str.join(' ')
      end
    end


    DIRHS = {'left' => 'à gauche', 'right' => 'à droite', 'front' => 'devant', 'back' => 'derrière'}
    VERBEGOS = {'top' => 'Monter', 'down' => 'Descendre'}
    def as_value(dirH, dirV)
      verbe = from_exterieur? ? 'Entrer' : (VERBEGOS[dirV] || 'Prendre')
      phrase = "#{verbe} #{DIRHS[dirH]} #{from_exterieur? ? 'par' : 'dans'} #{le} #{name.downcase}"
      {value:id, name:phrase}
    end

  end #/Lieu
end #/Gooo
