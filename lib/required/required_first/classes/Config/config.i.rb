# encoding: UTF-8
class Gooo
class Config
  attr_reader :gooo

  def initialize gooo
    @gooo = gooo
  end

  def init
    load(path)
  end

  def method_missing method, *args, &block
    if method.to_s.end_with?('=')
      method = method[0...-1]
      values.merge!( method => args.first)
    else
      return values[method.to_s]
    end
  end

  def values
    @values ||= {}
  end

  def path
    @path ||= File.join(APPFOLDER,'config.rb')
  end
end #/Config
end #/Gooo
