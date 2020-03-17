# encoding: UTF-8
class Gooo
class BadGuy
  class << self

    # On prépare (set_up) et on met en route (move) les méchants
    def set_up
      info("Initialisation des bad guys…")
      @threads = []
      if Gooo.config.badguys_count == :all
        badguys.count
      else
        Gooo.config.badguys_count
      end.times do |i|
        @threads << Thread.new { badguys_shuffled[i].set_up }
      end
      # On démarre les threads
      info("Nombre de méchants : #{@threads.count}")

      return @threads
    end

    def badguys_shuffled
      badguys.shuffle.shuffle
    end

    def badguys
      @badguys ||= begin
        data.collect do |h|
          new(h)
        end
      end
    end

    def badguys_count
      @badguys_count ||= badguys.count
    end

    def data
      @data ||= YAML.load_file(data_path)
    end

    def data_path
      @data_path ||= File.join(CLASSES_FOLDER,'BadGuy','_data_guys.yaml')
    end

  end #<< self
end #/BadGuy
end #/Gooo
