require_relative "Print.rb"
class Game
  include Print

  attr_reader :player_name, :player_role, :pegs, :board,
              :attempts_allowed, :code_length, :finished,
              :code, :keys
  attr_writer :code

  def initialize(attempts_allowed=8, code_length=4)
    @player_name = nil
    @player_role = nil
    @board = []
    @pegs = ["🔵", "🔴", "💛", "💚", "💜", "🧡"]
    @numbers = (1..6).to_a
    @attempt = ""
    @attempt_count = 0
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
    slow_print("\nEnter player name: ", 0.02)
    @player_name = gets.upcase.chomp
  end
  def select_role
    slow_print("\nSelect role: codebreaker or codemaker?\n\n"\
               "Type 'a' for codebreaker or 'b' for codemaker: ", 0.02)
    answer = gets.chomp.downcase
    if answer == 'a'
      @player_role = 'codebreaker'
    elsif answer == 'b'
      @player_role = 'codemaker'
    else
      slow_print("Invalid response. Try again.\n", 0.02)
      select_role
    end
  end
  def set_computer_code(computer_code)
    @code = computer_code
  end
  def get_player_code
    print_pegs_and_numbers
    slow_print("Enter your code: ", 0.02)
    @code = gets.chomp.split("")
    validate_or_retry(@code, get_player_code)
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
    slow_print(board_str, 0.005)
  end
  def pegs_and_numbers_str
    "\nAvailable pegs:\n"\
    "#{pegs[0]} #{pegs[1]} #{pegs[2]} "\
    "#{pegs[3]} #{pegs[4]} #{pegs[5]}\n"\
    "1  2  3  4  5  6\n"
  end
  def print_pegs_and_numbers
    slow_print(pegs_and_numbers_str, 0.02)
  end
  def make_attempt
    @attempt = gets.chomp.split("")
    validate_attempt
    emojify
    insert_guess
    draw_board
    print_pegs_and_numbers
    confirm_guess
  end
  def validate_attempt
    p "you made it!"
    if @attempt.size != 4
      slow_print("Invalid response, try again: ", 0.02)
      make_attempt
      return
    end
    puts "4 size confirmed."
    @attempt.each do |item|
      if !(@pegs.include?(item)) && !(@numbers.include?(item.to_i))
        slow_print("Invalid response, try again: ", 0.02)
        make_attempt
        break
      end
    end
    puts "passed array all test"
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
    @board[@attempt_count] = []
    @attempt.each { |peg| @board[@attempt_count] << peg }
  end
  def confirm_guess
    slow_print("\nType 'y' to confirm attempt or "\
               "'n' to change your code attempt: ", 0.02)
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      make_keys
    elsif answer == "n" || answer == "no"
      slow_print("\nChange code attempt: ", 0.02)
      make_attempt
    else
      slow_print("Invalid response. Try again.\n", 0.02)
      sleep(0.5)
      confirm_guess
    end
  end
  def make_keys
    @keys[@attempt_count] = []
    matched = []
    @attempt.each_with_index do |v, i|
      if v == @code[i]
        @keys[@attempt_count].prepend("⚫️")  
        matched << v
      elsif @code.include?(v)
        total = @code.select {|item| item == v}
        matched_total = matched.select {|item| item == v}
        if (total.size > matched_total.size)
          @keys[@attempt_count].append("⚪️")
          matched << v
        end
      end
    end
    while @keys[@attempt_count].size < @code.size
      @keys[@attempt_count] << "🕳 "
    end
    if @keys[@attempt_count].all?("⚫️")
      player_won
    elsif @attempt_count == @attempts_allowed - 1
      codemaker_won
    else
      @attempt_count += 1
    end
  end
  def player_won
    @finished = true
    slow_print("\nWe have a winner! Congrats #{@codebreaker},\nyou broke the gahhd damn code my geeeeee~\n", 0.02)
  end
  def codemaker_won
    @finished = true
    slow_print("\nUnlucky, you have used all #{attempts_allowed} "\
               "available attempts to break the code.\n", 0.02)
  end
end