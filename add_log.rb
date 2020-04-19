# rbtrace --pid=$(pgrep ruby add_log.rb) --interactive
#
# module AModule;module Really;class Nested;class Oh;def multiply;p 'del chill';a = 2;b = 3;a * b;end;end;end;end;end
#
# # Bypass the argument limit limitation
# # https://github.com/tmm1/rbtrace/blob/6d995faf97e670daf488b8b5babba08de94365f3/lib/rbtrace/msgq.rb#L8
# # https://github.com/tmm1/rbtrace/blob/e6f8d700d1d026c489c44995e0485b7eb9e5b4af/lib/rbtrace/rbtracer.rb#L326
#
# i = 'module AModule;module Really;class Nested;'
# f = 'class Oh;def multiply;p "del chill";a = 2;b = 3;a * b;end;'
# j = 'end;end;end;end'
#
# eval("#{i}#{f}#{j}")

require 'rbtrace'

module AModule
  module Really
    class Nested
      class Oh
        IMA_CONSTANT = 1

        def multiply
          a = 2
          b = 3

          a * b
        end
      end
    end
  end
end

loop {
  oh = AModule::Really::Nested::Oh.new

  puts oh.multiply

  sleep 1
}