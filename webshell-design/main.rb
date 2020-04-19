# Shell payload: class ::Hello;def world; 'nope' ;end;end

require 'sinatra'
require 'json'

class Hello
  def world
    'Hello World'
  end

  def other_method
    'Que lo what'
  end
end

set :public_folder, 'public'

$commands = []

get '/' do
  <<~EOF
    #{Hello.new.world}
    #{Hello.new.other_method}
  EOF
end

get '/shell' do
  erb :shell
end

post '/shell' do
  command = params['command']
  puts "[START] Executing CMD: #{command}"
  execution = execute(command)
  puts "[COMPLETE] Output CMD: #{execution}"

  $commands.push({
    command: command,
    output: execution
  })

  message = execution[:message]
  JSON.dump({
    exit: execution[:exit],
    message: message.to_s.gsub('\n', "\n")
  })
end

def execute(cmd)
  evaluation = eval(cmd)
  {
    command: cmd,
    exit: :success,
    message: if evaluation.class == Symbol
      ":#{evaluation}"
    else
      evaluation
    end
  }
rescue StandardError => e
  {
    command: cmd,
    exit: :fail,
    message: ["[[!b;#db1818;none]#{e.to_s}]", e.backtrace].flatten.join('\n')
  }
end