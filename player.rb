class Player

    attr_reader :name, :player_input

    def initialize(name)
        @name = name
    end

    def guess
        @player_input = gets.chomp
    end

end