# encoding: UTF-8
=begin

  Pour la gestion des partied de l'écran

=end

# Un block d'écran
class BlockScreen

  class << self

    def info
      @info ||= new({lines: 10, top: 30})
    end
    def plan
      @plan ||= new({lines: 15, top: 0})
    end

  end #/ << self

  # La fenêtre curse du block
  attr_reader :win
  # Nombre de lignes pour le blocks
  attr_reader :linecount
  # Top de la première ligne
  attr_reader :top

  def initialize hdata
    @linecount  = hdata[:lines] || 1
    @top        = hdata[:top]  || raise("Il faut définir le top du bloc d'écran")
    @win        = Curses::Window.new(0, 0, @top, 2)
    reset
  end
  def reset
    @lines = Array.new(linecount)
    @color_green = 2
    init_pair(@color_green, COLOR_GREEN, COLOR_BLACK)
  end

  def << msg
    @lines.pop
    @lines.unshift(msg)

    # puts "@lines = #{@lines.inspect}"
    # sleep 4

    print_lines
  end
  def print_lines
    setpos(top, 2)
    # addstr(@lines.compact.join(RC).bleu)
    win.clear
    @lines.each do |line|
      next if line.nil?
      win.attron(color_pair(@color_green)) { win << line }
      clrtoeol
      win << RC
    end
    win.refresh
  end
end

def info(msg)
  BlockScreen.info << msg
end

def plan
  @plan ||= BlockScreen.plan
end

def dbg(msg)
  setpos(30, 2)
  addstr(msg)
  refresh
end
