# encoding: UTF-8
=begin
  Les méthodes d'entrée/sortie utiles pour le Terminal

  Version 1.0.0 (5 mars 2020)
  ---------------------------

=end
TESTS = false unless defined?(TESTS)

RC = "
"

# Pour mettre le focus à la fenêtre Terminal
def activate_terminal
  `open -a Terminal`
  `open -a Terminal`
  `open -a Terminal`
end

def promptBlink(amorce, question)
  return IOConsole.wait_for_string_with_blink_double_message(amorce, question)
end
def prompt(question)
  return IOConsole.wait_for_string(question)
end

def promptChar(question)
  return IOConsole.wait_for_char(question)
end

def yesNo(question)
  return IOConsole.yesNo(question)
end

# Permet d'indenter un texte lorsqu'il doit être affiché avec des retours
# chariot, par exemple :
#   "
#   " label : Un texte qui doit s'afficher en
#   "         s'enroulant pour revenir bien à
#   "         la ligne.
#   "
# Ci-dessus, la longueur ' label : ' peut être fixée par :indent dans les
# options, sinon, c'est la longueur du label qui est utilisée.
# (options[:indent]). Le nom ' label : ' est le label
# +options+::[Hash]
#     :label      Si fourni, on le met sur la première ligne, sinon, on
#                 ne met rien mais on compte son indentation pour que le
#                 début du texte, commence à rien.
#     :delim      Délimiteur de mots. Par défaut, l'espace.
def indent str, options = nil
  str = str.to_s # car peut être n'importe quelle valeur, comme un nombre ou nil
  options ||= {label: ' '*20}
  w = IOConsole.width # largeur de console actuelle
  indent = options[:indent] || options[:label].length
  options[:label] ||= ' ' * indent
  options[:delim] ||= ' '
  # Nombre de caractères restant pour le texte.
  max_len  = w - indent
  mots = str.gsub(/#{RC}/, ' __RET__ ')
  mots = mots.split(options[:delim])
  # puts "Mots : #{mots.inspect}"
  lines = []
  current_line = "#{options[:label]}"
  mots.each_with_index do |mot, index|
    if mot == '__RET__'
      lines << current_line
      current_line = ' '*indent
      next
    elsif current_line.length + mot.length > max_len
      lines << current_line
      current_line = " " * indent
    end
    current_line << "#{mot}#{options[:delim]}"
  end
  # Ajouter la dernière ligne
  lines << current_line
  # Retourner le texte complet
  lines.join(RC).strip
end

# Pour poser une question et produire une erreur en cas d'autre réponse
# que 'y'
# Pour fonctionner, la méthode (ou la sous-méthode) qui utilise cette
# formule doit se terminer par :
#     rescue NotAnError => e
#       e.puts_error_if_message
#     end
def yesOrStop(question)
  yesNo(question) || raise(NotAnError.new)
end


def getChar(question)
  IOConsole.getChar(question)
end

def clear
  return if defined?(ARGS) && ARGS[:options][:debug]
  return if TESTS
  puts "\n" # pour certaines méthodes
  puts "\033c"
end

# Méthode qui retourne TRUE si on presse la
# barre espace ou rien dans le cas contraire,
# sauf si c'est 'q'
def SPACEOrQuit(question)
  return IOConsole.waitForSpaceOrQuit(question)
end

class IOConsole
  SEPARATOR = ('-' * `tput cols`.to_i)
class << self
  def reset
    @width = nil
  end
  def getChar(question = nil)
    print "#{question} " if question
    old_state = `stty -g`
    system "stty raw -echo"
    char = STDIN.getc.chr
    # puts "Caractère pressé : '#{char}'"
    print "\r\n"
    return char
  ensure
    system "stty #{old_state}"
  end

  # Retourne la largeur de la console actuelle en nombre de caractère
  def width
    @width ||= `tput cols`.to_i
  end

  def waitForSpaceOrQuit(question)
    print "\n#{question} (SPACE ou 'q' pour quitter) "
    begin
      char = getChar
    end while char != 'q' && char != ' '
    if char == 'q'
      return nil
    else
      return true
    end
  end

  def yesNo(question)
    print "\n#{question} (y/n/q) "
    begin
      char = TESTS ? KEYS_STACK.shift : getChar
      char = 'y' if char == 'o'
    end while char != 'y' && char != 'n' && char != 'q'
    if char == 'q'
      return nil
    else
      return char == 'y'
    end
  end
  def wait_for_string question
    print "#{question} : "
    str = STDIN.gets
    str = str.strip
    if str == 'q' || str == ""
      return nil
    else
      str
    end
  end
  alias :prompt :wait_for_string

  # Méthode complexe qui affiche +amorce+ en clignotant, avant
  # de placer la +question+ et d'attendre un texte
  def wait_for_string_with_blink_double_message(amorce, question, options = {})
    blank_question = " " * (question.length + 1)
    blank_amorce = " " * (amorce.length)
    puts "\e[?25l"
    4.times do |i|
      print "\033[42;7m #{blank_amorce} \033[0m\r"
      sleep 0.11
      print "\033[42;7m #{amorce} \033[0m\r"
      sleep 0.11
    end
    print "\033[42;7m #{question} \033[0m"
    print "\e[?25h"
    wait_for_string('')
  end

  def wait_for_char question
    print "\n#{question}"
    char = getChar
    if char == 'q'
      return nil
    else
      char
    end
  end

end #/<< self
end #/IOConsole
