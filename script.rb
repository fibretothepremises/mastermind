require_relative "Print.rb"
require_relative "Prompts.rb"
require_relative "Game.rb"
require_relative "Player.rb"
require_relative "Computer.rb"
require_relative "Human.rb"

include Print, Prompts

slow_print("\nCLI Mastermind.\n\n", 0.00)
press_any_key
game = Game.new
slow_print("\n\nNew game has started.\n", 0.00)
game.get_player_name
slow_print("\nWelcome, #{game.player_name}.\n", 0.00)
computer = Computer.new
game.select_role
case game.player_role
when 'codebreaker'
  game.codebreaker = game.player_name
  computer.generate_code(game.pegs, game.code_length)
  game.set_computer_code(computer.code)
  while game.finished == false
    game.draw_board
    game.print_pegs_and_numbers
    slow_print("\nMake an attempt: ", 0.00)
    game.make_attempt
  end
when 'codemaker'
  game.codebreaker = 'COMPUTER'
  game.get_player_code
  while game.finished == false
    puts "\nRound #{game.round + 1}: \n"
    game.draw_board
    game.print_pegs_and_numbers
    slow_print("Computer making an attempt: ", 0.00)
    computer.make_attempt(game.board, game.keys)
    puts "New attempt created."
    puts "Attempt: #{computer.attempts[game.round]}"
    game.eval_computer_attempt(computer.attempts[game.round])
  end
end







# slow_print("Attempts allowed: ", 0.00)
# attempts_allowed = gets.chomp.to_i
# slow_print("code length: ", 0.00)
# code_length = gets.chomp.to_i