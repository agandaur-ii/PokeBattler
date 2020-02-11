class Battle < ActiveRecord::Base
    has_many :trainers, through: :pokemons
    has_many :pokemons

    def who_goes_first?
        @player_one = nil
        @player_two = nil
        list = [@pokemon_1, @pokemon_2]

        if @pokemon_1.speed == @pokemon_2.speed
            @player_one = list.delete(list.sample)
            @player_two = list[0]
        end

        if @pokemon_1.speed > @pokemon_2.speed
            @player_one = @pokemon_1
            @player_two = @pokemon_2
        else
            @player_one = @pokemon_2
            @player_two = @pokemon_1
        end
    end

    def start

    end

end