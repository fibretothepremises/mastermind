require_relative 'Player.rb'

class Computer < Player
  attr_reader :code
  def initialize
    @name = "COMPUTER"
    pegs = ["🔵", "🔴", "💛", "💚", "💜", "🧡"]
    @round = 0
    @attempts = []
    @bagel = "⚫️"
    @pico = "⚪️"
    @fermi = "🕳 "
    @bagels = nil
    @picos = nil
    @fermis = nil
    @code = []
    @set = []
  end
  def generate_code(pegs, code_length=4)
    code_length.times { @code << pegs.sample }
  end
  def create_set(pegs, code_length=4)
    pegs.each do |thousands|
      pegs.each do |hundreds|
        pegs.each do |tens|
          pegs.each do | ones|
            @sets << [thousands, hundreds, tens, ones]
          end
        end
      end
    end
  end
  def make_attempt(board, keys)
    prev_attempt = @attempts[@round-1]
    prev_digit = @pegs[@round-1]
    bg_digit = @pegs[@round]
    bagels = keys[@round-1].select {|key| key == @bagel}
    picos = keys[@round-1].select {|key| key == @pico}
    fermis = keys[@round-1].select {|key| key == @fermi}
    if @round = 0
      @attempts[@round] = [@pegs[0], @pegs[0], @pegs[0], @pegs[0]]
    elsif fermis.size == 4
      @attempt = [@fermi, @fermi, @fermi, @fermi]
    end
  end
end

c = Computer.new
c.create_set(pegs)
