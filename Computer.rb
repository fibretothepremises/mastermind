require_relative 'Player.rb'

class Computer < Player
  attr_reader :code, :attempts
  def initialize
    @name = "COMPUTER"
    @pegs = ["🔵", "🔴", "💛", "💚", "💜", "🧡"]
    @round = 0
    @attempts = []
    @bagel = "⚫️"
    @pico = "⚪️"
    @fermi = "🕳 "
    @bagels = nil
    @picos = nil
    @fermis = nil
    @prev_bnp = 0
    @code = []
    @set = []
    create_set(@pegs)
  end
  def generate_code(pegs, code_length=4)
    code_length.times { @code << pegs.sample }
  end
  def create_set(pegs, code_length=4)
    pegs.each do |thousands|
      pegs.each do |hundreds|
        pegs.each do |tens|
          pegs.each do | ones|
            @set << [thousands, hundreds, tens, ones]
          end
        end
      end
    end
  end
  def prepare_new_attempt_array
    @attempts << []
  end
  def delete_prev_attempt
    @set.delete(@attempts[-2])
  end
  def make_attempt(board, keys)
    prepare_new_attempt_array
    new_attempt = @attempts[-1]
    delete_prev_attempt
    fg_digit = @pegs[@round-1]
    bg_digit = @pegs[@round]
    bagels = keys[@round-1].select {|key| key == @bagel}
    picos = keys[@round-1].select {|key| key == @pico}
    fermis = keys[@round-1].select {|key| key == @fermi}
    new_bnp = bagels.size + picos.size
    diff = new_bnp - @prev_bnp
    if @round == 0
      new_attempt = [bg_digit, bg_digit, bg_digit, bg_digit]
    elsif @round == 1 && bagels.size > 0
      @set = @set.select do |code|
        selection = code.select {|val| val == fg_digit}
        selection.size == bagels.size
      end
      selection = @set.select do |code|
        code.all? {|v| @pegs.first(@round + 1).include?(v)}
      end
      new_attempt = selection.first
    elsif fermis.size == 4
      @set.delete_if {|code| code.include?(fg_digit)}
      new_attempt = [bg_digit, bg_digit, 
                     bg_digit, bg_digit]
    elsif bagels.size + picos.size > @prev_bnp
      puts "pegs found"
      @set = @set.select do |code|
        selection = code.select {|val| val == fg_digit}
        selection.size == diff
      end
      selection = @set.select do |code|
        code.all? {|v| @pegs.first(@round + 1).include?(v)}
      end
      new_attempt = selection.first
    elsif (bagels.size + picos.size) == @prev_bnp
      puts "no new keys"
      @set = @set.select do |code|
        !(code.include?(fg_digit))
      end
      selection = @set.select do |code|
        code.all? {|v| @pegs.first(@round + 1).include?(v)}
      end
      new_attempt = @set.first
    end
    @attempts[@round] = new_attempt
    puts "new attempt: #{new_attempt}"
    puts "@attempts[@round]: #{@attempts[@round]}"
    @prev_bnp = bagels.size + picos.size
    @round += 1
  end
  def delete_all_containing(peg)
    @set = @set.select do |code|
      !(code.include?(peg))
    end
  end
  def select_containing_num(peg, num)
    @set = @set.select do |code|
      selection = code.select {|val| val == peg}
      selection.size == num
    end
  end
  def simple(board, keys)
    prepare_new_attempt_array
    new_attempt = @attempts[-1]
    delete_prev_attempt
    bagels = keys[@round-1].select {|key| key == @bagel}
    picos = keys[@round-1].select {|key| key == @pico}
    fermis = keys[@round-1].select {|key| key == @fermi}
    bs = bagels.size
    ps = picos.size
    fs = fermis.size
    puts "\nRound #{@round}: #{bs} Bagels, #{ps} Picos, and #{fs} Fermis.\n"
    if @round == 0
      @attempts.last = ["🔵", "🔵", "🔴", "🔴"]
    elsif bs == 3 && fs == 1
      uniq_vals = @attempts[-2].uniq
      a = @attempts[-2].select {|e| e == uniq_vals[0]}
      b = @attempts[-2].select {|e| e == uniq_vals[1]}
      byebyepeg = a.size < b.size ? uniq_vals[0] : uniq_vals[1]
      keeper = a.size > b.size ? uniq_vals[0] : uniq_vals[1]
      delete_all_containing(byebyepeg)
      select_containing_num(keeper, 3)
      @attempts.last = @set.first
    elsif bs == 2 && fs == 2
    end
  end
end