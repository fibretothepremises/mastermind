class Computer < Player
  attr_reader :code
  def initialize
    @name = "COMPUTER"
    @code = []
  end
  def generate_code(code_length, pegs)
    code_length.times { @code << pegs.sample }
  end
end