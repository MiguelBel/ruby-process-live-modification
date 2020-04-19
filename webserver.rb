# rbtrace --pid=$(pgrep ruby webserver.rb) --interactive irb
#
# class ::Hello;def world; 'nope' ;end;end

require 'sinatra'
require 'rbtrace'

class Hello
  def world
    'Hello World'
  end
end

get '/' do
  Hello.new.world
end