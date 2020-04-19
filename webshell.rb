# Shell payload: class ::Hello;def world; 'nope' ;end;end

require 'sinatra'

class Hello
  def world
    'Hello World'
  end

  def other_method
    'Que lo what'
  end
end

$commands = []

get '/' do
  <<~EOF
    #{Hello.new.world}
    #{Hello.new.other_method}
  EOF
end

get '/shell' do
  <<~EOF
    #{form}
    #{commands}
  EOF
end

post '/shell' do
  cmd = params[:command]

  $commands.push({
    cmd: cmd,
    output: execute(cmd)
  })

  <<~EOF
    #{form}
    #{commands}
  EOF
end

def execute(cmd)
  eval(cmd)
rescue StandardError=> e
  [e.to_s, e.backtrace].flatten.join('\n')
end

def form
  <<~EOF
    <form action="/shell" method="POST">
      Command: <textarea name="command"></textarea>
      <button type="submit">Execute</button>
    </form>
  EOF
end

def commands
  $commands.reverse.map do |command|
    <<~EOF
      <p>command: #{command[:cmd]}</p>
      <hr/>
      <p>output: #{command[:output]}</p>
      <hr/>
    EOF
  end.join
end