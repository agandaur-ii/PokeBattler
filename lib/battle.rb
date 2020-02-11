class Battle < ActiveRecord::Base
    has_many :trainers, through: :pokemons
    has_many :pokemons

    def who_goes_first?
        @player_one = nil
        @player_two = nil
        list = [@pokemon_1, @pokemon_2]

        if @pokemon_1_temp_speed == @pokemon_2_temp_speed
            @player_one = list.delete(list.sample)
            @player_two = list[0]
        end

        if @pokemon_1_temp_speed > @pokemon_2_temp_speed
            @player_one = @pokemon_1
            @player_two = @pokemon_2
        else
            @player_one = @pokemon_2
            @player_two = @pokemon_1
        end
    end

    def attack(player_num)
        puts "attack!"
        if player_num == @pokemon_1
            @pokemon_2_temp_hp -= @pokemon_1_temp_attack
        else
            @pokemon_1_temp_hp -= @pokemon_2_temp_attack
        end
    end

    def boost(player_num)
        puts "Your pokemon feels stronger!"
    end

    def turn(player_num)
        #attack or boost?
        attack
    end

    def start
        binding.pry
        @pokemon_1_temp_hp = @pokemon_1.hp
        @pokemon_1_temp_attack = @pokemon_1.attack
        @pokemon_1_temp_speed = @pokemon_1.speed
        @pokemon_2_temp_hp = @pokemon_2.hp
        @pokemon_2_temp_attack = @pokemon_2.attack
        @pokemon_2_temp_speed = @pokemon_2.speed

        until @pokemon_1_temp_hp <= 0 || @pokemon_2_temp_hp <= 0 do 
          who_goes_first?
          turn(@player_one)
          turn(@player_two)
        end

        if @pokemon_1_temp_hp <= 0 
            winner = @pokemon_2
        else
            winner = @pokemon_1
        end
    end

end