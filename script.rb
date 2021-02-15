require_relative "Print.rb"
require_relative "Prompts.rb"
require_relative "Game.rb"
require_relative "Player.rb"
require_relative "Computer.rb"
require_relative "Human.rb"

include Print, Prompts

slow_print("\nCLI Mastermind.\n\n", 0.02)
press_any_key
game = Game.new
slow_print("\n\nNew game has started.\n", 0.02)
game.get_player_name
slow_print("\nWelcome, #{game.player_name}.\n", 0.02)
computer = Computer.new
game.select_role
case game.player_role
when 'codebreaker'
  computer.generate_code(game.code_length, game.pegs)
  game.set_computer_code(computer.code)
  p game.code
  while game.finished == false
    game.draw_board
    game.print_pegs_and_numbers
    slow_print("\nMake an attempt: ", 0.02)
    game.make_attempt
  end
when 'codemaker'
  game.get_player_code
  
end










# slow_print("Attempts allowed: ", 0.02)
# attempts_allowed = gets.chomp.to_i
# slow_print("code length: ", 0.02)
# code_length = gets.chomp.to_i