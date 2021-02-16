require_relative "Print.rb"
class Game
  include Print

  attr_reader :player_name, :player_role, :pegs, :board,
              :attempts_allowed, :code_length, :finished,
              :code, :keys, :round
  attr_writer :code, :codebreaker

  def initialize(attempts_allowed=8, code_length=4)
    @player_name = nil
    @player_role = nil
    @codebreaker = ''
    @board = []
    @pegs = ["🔵", "🔴", "💛", "💚", "💜", "🧡"]
    @round = 0
    @bagel = "⚫️"
    @pico = "⚪️"
    @fermi = "🕳 "
    @numbers = (1..6).to_a
    @attempt = ""
    @round = 0
    @attempts_allowed = attempts_allowed
    @code_length = code_length
    @code = nil
    @keys = []
    create_board
    @finished = false
  end
  def create_board
    @attempts_allowed.times {@board.push(["🕳 ", "🕳 ", "🕳 ", "🕳 "])}
    @attempts_allowed.times {@keys.push(["🕳 ", "🕳 ", "🕳 ", "🕳 "])}
  end
  def get_player_name
    slow_print("\nEnter player name: ", 0.00)
    @player_name = gets.upcase.chomp
  end
  def select_role
    slow_print("\nSelect role: codebreaker or codemaker?\n\n"\
               "Type 'a' for codebreaker or 'b' for codemaker: ", 0.00)
    answer = gets.chomp.downcase
    if answer == 'a'
      @player_role = 'codebreaker'
    elsif answer == 'b'
      @player_role = 'codemaker'
    else
      slow_print("Invalid response. Try again.\n", 0.00)
      select_role
    end
  end
  def set_computer_code(computer_code)
    @code = computer_code
  end
  def get_player_code
    print_pegs_and_numbers
    slow_print("Enter your code: ", 0.00)
    @code = gets.chomp.split("")
    validate(@code)
  end
  def board_str
    str = "\n"
    (0..(@attempts_allowed - 1)).step(1) do |i|
      str << "#{(i+1).to_s}|"\
             "#{@board[i][0]}|#{@board[i][1]}|#{@board[i][2]}|#{@board[i][3]}|"\
             "#{@keys[i][0]} #{@keys[i][1]} #{@keys[i][2]} #{@keys[i][3]}\n"
    end
    str
  end
  def draw_board
    slow_print(board_str, 0.002)
  end
  def pegs_and_numbers_str
    "\nAvailable pegs:\n"\
    "#{pegs[0]} #{pegs[1]} #{pegs[2]} "\
    "#{pegs[3]} #{pegs[4]} #{pegs[5]}\n"\
    "1  2  3  4  5  6\n"
  end
  def print_pegs_and_numbers
    slow_print(pegs_and_numbers_str, 0.00)
  end
  def make_attempt
    @attempt = gets.chomp.split("")
    validate(@attempt)
    emojify
    insert_guess
    draw_board
    print_pegs_and_numbers
    confirm_guess
  end
  def validate(array)
    valid = array.all? do |item|
      @pegs.include?(item) || @numbers.include?(item.to_i)
    end
    if !valid || array.size != 4
      slow_print("Invalid response, try again: ", 0.00)
      array = gets.chomp.split("")
      validate(array)
    end
    slow_print("Code validated.", 0.00)
  end
  def emojify
    @attempt = @attempt.map! do |c|
      if c.to_i > 0
        @pegs[(c.to_i)-1]
      else
        c
      end
    end
  end
  def insert_guess
    @board[@round] = []
    @attempt.each { |peg| @board[@round] << peg }
  end
  def confirm_guess
    slow_print("\nType 'y' to confirm attempt or "\
               "'n' to change your code attempt: ", 0.00)
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      make_keys
    elsif answer == "n" || answer == "no"
      slow_print("\nChange code attempt: ", 0.00)
      make_attempt
    else
      slow_print("Invalid response. Try again.\n", 0.00)
      sleep(0.5)
      confirm_guess
    end
  end
  def make_keys
    @keys[@round] = []
    unmatched = Array.new(@code)
    matched = []
    @attempt.each_with_index do |v, i|
      if v == unmatched[i] && v != nil
        unmatched[i] = nil
        @attempt[i] = nil
        @keys[@round].prepend(@bagel)
      end
    end
    @attempt.each_with_index do |v, i|
      if unmatched.include?(v) && v != nil
        unmatched.delete_at(unmatched.index(v))
        @keys[@round].append(@pico)
      end
    end
    while @keys[@round].size < @code.size
      @keys[@round] << @fermi
    end
    if @keys[@round].all?(@bagel)
      codebreaker_won
    elsif @round == @attempts_allowed - 1
      codemaker_won
    else
      @round += 1
    end
  end
  def codebreaker_won
    @finished = true
    draw_board
    slow_print("\nWe have a winner! Congrats #{@codebreaker},\nyou broke the gahhd damn code my geeeeee~\n", 0.00)
  end
  def codemaker_won
    @finished = true
    draw_board
    slow_print("\nUnlucky, all #{attempts_allowed} "\
               "attempts have been used to break the code.\n", 0.00)
  end
  def eval_computer_attempt(attempt)
    @attempt = attempt
    insert_guess
    draw_board
    make_keys
  end
end