require_relative "player.rb"

class Game

    def initialize(*players)
        @players_arr = []
        @losses = Hash.new{}

        players.each do |playername|
            @players_arr << Player.new(playername)
            @losses[playername] = ""
        end

        @fragment = ""
        @dictionary = Hash.new{}
        File.foreach("dictionary.txt"){|line| @dictionary[line.chomp] = nil}
        @current_player = @players_arr[0]
        @previous_player = @players_arr[-1]

        @game_over = false
    

    end

    def current_word
        puts ">> The current word is #{@fragment}"
    end

    def current_player
        puts ">> The current player is #{@current_player.name}"
    end
    
    def next_player!
        @previous_player = @players_arr[0]
        @players_arr.rotate!
        @current_player = @players_arr[0]
    end

    def take_turn
        if @losses[@current_player.name] != "GHOST"

            puts ">> Hi #{@current_player.name} its your turn"
            puts ">> The current fragment is: #{@fragment}"

            current_guess = @current_player.guess
            current_fragment = @fragment + current_guess
            
            if valid_play?(current_guess)
                puts ">> Thanks that was a valid play"
                @fragment = current_fragment
            else
                puts ">> Your word would have been '#{current_fragment}' and thats not legal"
                record_loss
                @fragment = ""
                display_standings
            end
        end

        next_player!

    end

    def valid_play?(play)
        return false if play.length != 1 
        keys_arr = @dictionary.keys

        if ("a".."z").to_a.include?play
            @dictionary.keys.each do |key|
                if key.start_with?(@fragment + play)
                    return true
                end
            end
            return false
        else
            return false
        end
    end
    
    def record_loss
        ghost = "GHOST"
        player_id = @current_player.name

        @losses[player_id] = ghost[0...@losses[player_id].length + 1]

        if @losses.values.one?{|score| score != "GHOST"}
            @game_over = true
        end
    end


    def run
        while !@game_over
            take_turn
        end

        winner = ""
        
        @losses.each do |k,v|
            if v != "GHOST"
                winner = k
            end
        end

        puts "============================"
        puts "GAME OVER"
        puts "#{winner} WINS"
        puts "============================"

    end

    def display_standings
        puts "============================"
        puts "Player       || Score"
        puts "----------------------------"
        @losses.each do |k, v|
            puts "#{k}" + " "*(13-k.length) + "|| " + v
        end
    end


end

game = Game.new("Player1", "Player2", "Player3")
game.display_standings
game.run
