class Human < Player
  attr_reader :name
  def initialize(name)
    @name = name.upcase.chomp
  end
end