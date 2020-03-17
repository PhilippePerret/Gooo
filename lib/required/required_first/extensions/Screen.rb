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
      @plan ||= new({lines:15, top:0, height:15, width:0, left:2})
    end

    def user_state
      @user_state ||= new({lines:2, top:28, height:2, left:2})
    end

  end #/ << self

  # La fenêtre curse du block
  attr_reader :win
  # Nombre de lignes pour le blocks
  attr_reader :linecount
  # Top de la première ligne
  attr_reader :top

  def initialize hdata
    @linecount  = hdata[:lines]   || 1
    @top        = hdata[:top]     || raise("Il faut définir le top du bloc d'écran")
    @height     = hdata[:height]  || 10
    @width      = hdata[:width]   || 0
    @left       = hdata[:left]    || 2
    @win        = Curses::Window.new(@linecount, @width, @top, @left)
    reset
  end
  def reset
    @lines = Array.new(linecount)
    @color_blue = 1
    init_pair(@color_blue, COLOR_CYAN, COLOR_BLACK)
    @color_green  = 2
    init_pair(@color_green, COLOR_GREEN, COLOR_BLACK)
    @color_red    = 3
    init_pair(@color_red, COLOR_RED, COLOR_BLACK)
    @color_orange = 4
    init_pair(@color_orange, COLOR_YELLOW, COLOR_BLACK)
  end

  def << msg
    msg = [msg, nil] unless msg.is_a?(Array)
    MESSAGES << msg.first
    @lines.pop
    @lines.unshift(msg)
    print_lines
  end
  def print_lines
    setpos(top, 2)
    win.clear
    @lines.each do |dline|
      line, color = dline
      next if line.nil?
      win.attron(color_pair(color||@color_green)) { win << line }
      clrtoeol
      win << RC
    end
    win.refresh
  end
end

def info(msg, type = nil)
  type =  case type
          when :info    then 1
          when :error   then 3
          when :warning then 4
          else 2 # vert
          end
  BlockScreen.info << [msg, type]
end

def state(msg)
  BlockScreen.user_state << [msg,1]
end

def plan
  @plan ||= BlockScreen.plan
end
