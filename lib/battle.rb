class Battle < ActiveRecord::Base

    attr_accessor :p_id_one, :p_id_two, :t_id_one, :t_id_two
    has_many :trainers, through: :pokemons
    has_many :pokemons

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
        if player_num == @@user_mon
            puts "#{@@user_mon.name} attacks #{@@rival_mon.name}!"
            @pokemon_2_temp_hp -= @pokemon_1_temp_attack
        else
            puts "#{@@rival_mon.name} attacks #{@@user_mon.name}!"
            @pokemon_1_temp_hp -= @pokemon_2_temp_attack
        end
    end

    def boost(player_num)
        option = [1, 2]
        pick = option.sample
        if player_num == @@user_mon
            if pick == 1
                puts "#{@@user_mon.name}'s attack increased!"
                @pokemon_1_temp_attack += 10
            else
                puts "#{@@user_mon.name}'s speed increased!"
                @pokemon_1_temp_speed += 10
            end
        else
            if pick == 1
                puts "#{@@rival_mon.name}'s attack increased!"
                @pokemon_2_temp_attack += 10
            else
                puts "#{@@rival_mon.name}'s speed increased!"
                @pokemon_2_temp_speed += 10
            end
        end
    end

    def turn(player_num)
        prompt = TTY::Prompt.new
        if player_num == @@user_mon
            input = prompt.select("What would you like to do?", %w(Attack Boost))
                if input == "Attack"
                    attack(player_num)
                elsif input == "Boost"
                    boost(player_num)
                end
        else 
            option = [1, 1, 1, 2]
            pick = option.sample
            if pick == 1
                attack(player_num)
            else
                boost(player_num)
            end
        end
    end

    def start

        pmon_1 = Pokemon.find(self.p_id_one)
        pmon_2 = Pokemon.find(self.p_id_two)
        t_1 = Trainer.find(self.t_id_one)
        t_2 = Trainer.find(self.t_id_two)

        @@user_mon = pmon_1
        @@rival_mon = pmon_2

        puts "#{t_1.name} and their #{@@user_mon.name} challenge #{t_2.name} and their #{@@rival_mon.name} to a battle!"

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