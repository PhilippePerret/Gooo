# encoding: UTF-8

class Log
class << self

  def << ary_msg

  end

  def close
    rf.close
  end
  
  def rf
    @rf ||= begin
      File.unlink(path) if File.exists?(path)
      File.open(path,'a')
    end
  end
  def path
    @path ||= File.join(APPFOLDER,'gooo.log')
  end
end #/ << self
end #/Log

def log msg, type = :notice
  Log << [msg, type]
end
