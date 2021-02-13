# MODULES
module Print
  def slow_print(msg, time)
    msg.each_char {|c| print c; sleep(time)}
  end
end

include Print

slow_print("sdlkfjslfskdfj", 0.05)