# encoding: UTF-8
class Gooo
class User
  class << self

    def current
      @current ||= new()
    end

  end #/ << self
end #/ User
end #/ Gooo
