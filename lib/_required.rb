# encoding: UTF-8
require 'yaml'
require 'tty-prompt'

require 'curses'
include Curses

Q = TTY::Prompt.new

APPFOLDER = File.expand_path(File.dirname(File.dirname(__FILE__)))
LIB_FOLDER = File.join(APPFOLDER, 'lib')
REQUIRED_FOLDER = File.join(LIB_FOLDER, 'required')
CLASSES_FOLDER  = File.join(REQUIRED_FOLDER,'required_first','classes')
Dir["#{LIB_FOLDER}/required/required_first/**/*.rb"].each{|m|require(m)}
