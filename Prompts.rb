require 'io/console'
require_relative 'Print.rb'
include Print
module Prompts
  def press_any_key
    slow_print("Press any key to start!", 0.02)
    STDIN.getch
  end
end
