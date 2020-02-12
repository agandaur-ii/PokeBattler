class Battle < ActiveRecord::Base

    attr_accessor :id_one, :id_two #:winning_pokemon_id, :winning_trainer_id, :losing_pokemon_id, :losing_trainer_id
    has_many :trainers, through: :pokemons
    has_many :pokemons

    #pmon_1 = Pokemon.find(self.id_one)
    #pmon_2 = Pokemon.find(self.id_two)

    #@@user_mon = pmon_1
    #@@rival_mon = pmon_2

    def who_goes_first?
        @player_one = nil
        @player_two = nil
        list = [@@user_mon, @@rival_mon]

        if @pokemon_1_temp_speed == @pokemon_2_temp_speed
            @player_one = list.delete(list.sample)
            @player_two = list[0]
        end

        if @pokemon_1_temp_speed > @pokemon_2_temp_speed
            @player_one = @@user_mon
            @player_two = @@rival_mon
        else
            @player_one = @@rival_mon
            @player_two = @@user_mon
        end
    end

    def attack(player_num)
        puts "attack!"
        if player_num == @@user_mon
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
        attack(player_num)
    end

    def start

        pmon_1 = Pokemon.find(self.id_one)
        pmon_2 = Pokemon.find(self.id_two)

        @@user_mon = pmon_1
        @@rival_mon = pmon_2

        @pokemon_1_temp_hp = @@user_mon.hp
        @pokemon_1_temp_attack = @@user_mon.attack
        @pokemon_1_temp_speed = @@user_mon.speed
        @pokemon_2_temp_hp = @@rival_mon.hp
        @pokemon_2_temp_attack = @@rival_mon.attack
        @pokemon_2_temp_speed = @@rival_mon.speed

        until @pokemon_1_temp_hp <= 0 || @pokemon_2_temp_hp <= 0 do 
          who_goes_first?
          turn(@player_one)
          turn(@player_two)
        end

        if @pokemon_1_temp_hp <= 0 
            winner = @@rival_mon
            loser = @@user_mon
        else
            winner = @@user_mon
            loser = @@rival_mon
        end

        self.winning_pokemon_id = winner.id
        self.winning_trainer_id = winner.trainer_id
        self.losing_pokemon_id = loser.id
        self.losing_trainer_id = loser.trainer_id
        self.save
        winner.trainer_id
    end
end